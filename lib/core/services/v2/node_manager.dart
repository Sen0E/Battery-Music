import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NodeManager {
  static final NodeManager _nodeManager = NodeManager._internal();
  factory NodeManager() => _nodeManager;

  Process? _nodeProcess;

  Future<String?>? _nodeExecPathInitialization;

  String? _nodeExecPath;
  String? _nodeServiceUrl;
  String? _authToken; // 认证token

  NodeManager._internal() {
    _nodeExecPathInitialization = _initNodeService();
  }

  /// 初始化node服务路径，并返回node执行文件路径
  Future<String?> _initNodeService() async {
    String nodeServiceAssetPath, nodeServiceExecutableName;
    if (Platform.isLinux) {
      nodeServiceAssetPath = "assets/node_service/app_linux";
      nodeServiceExecutableName = "app_linux";
    } else if (Platform.isMacOS) {
      nodeServiceAssetPath = "assets/node_service/app_macos";
      nodeServiceExecutableName = "app_macos";
    } else if (Platform.isWindows) {
      nodeServiceAssetPath = "assets/node_service/app_win.exe";
      nodeServiceExecutableName = "app_win.exe";
    } else {
      throw UnimplementedError(
        "Unsupported platform:${Platform.operatingSystem}",
      );
    }

    final appSupportDir = await getApplicationSupportDirectory();
    final execDir = Directory("${appSupportDir.path}/node_service");
    if (!execDir.existsSync()) {
      execDir.createSync(recursive: true);
    }

    _nodeExecPath = "${execDir.path}/$nodeServiceExecutableName";
    final execFile = File(_nodeExecPath!);

    if (!execFile.existsSync()) {
      final assetBytes = await rootBundle.load(nodeServiceAssetPath);
      await execFile.writeAsBytes(
        assetBytes.buffer.asUint8List(
          assetBytes.offsetInBytes,
          assetBytes.lengthInBytes,
        ),
      );

      // Linux和MacOS下需要设置可执行权限
      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run("chmod", ["+x", _nodeExecPath!]);
      }
    }
    return _nodeExecPath;
  }

  /// 启动node服务
  /// 返回值为node服务地址
  Future<String> startNodeService() async {
    if (_nodeProcess != null) return _nodeServiceUrl!;

    // 在启动服务前，确保节点执行路径已初始化完成
    if (_nodeExecPath == null) {
      _nodeExecPath = await _nodeExecPathInitialization;
      if (_nodeExecPath == null) {
        throw Exception(
          "Node service executable path could not be determined.",
        );
      }
    }

    final Completer<String> completer = Completer();
    _authToken = Uuid().v4();

    _nodeProcess = await Process.start(
      _nodeExecPath!,
      [],
      environment: {
        'API_TOKEN': _authToken!,
        'PORT': '10086',
        'HOST': '127.0.0.1',
        'platform': 'lite',
      },
    );
    debugPrint("node service: started pid:${_nodeProcess!.pid}");

    _nodeProcess!.stdout.transform(utf8.decoder).listen((event) {
      if (!completer.isCompleted && event.contains('server running @')) {
        final match = RegExp(r'(http://127\.0\.0\.1:\d+)').firstMatch(event);
        if (match != null) {
          _nodeServiceUrl = match.group(1);
          completer.complete(_nodeServiceUrl);
        }
      }
      debugPrint("node service: stdout:$event");
    });

    _nodeProcess!.stderr.transform(utf8.decoder).listen((event) {
      debugPrint("node service: stderr:$event");
    });

    _nodeProcess!.exitCode.then((code) {
      debugPrint("node service: exitCode:$code");
    });
    return completer.future;
  }

  /// 停止node服务
  Future<void> stopNodeService() async {
    if (_nodeProcess == null) return;
    debugPrint("node service: stopping...");
    _nodeProcess!.kill();
    _nodeProcess = null;
    _nodeServiceUrl = null;
    debugPrint("node service: stopped");
  }

  /// 获取node服务地址
  String get nodeServiceUrl {
    if (_nodeServiceUrl == null) {
      throw Exception("node service not started");
    }
    return _nodeServiceUrl!;
  }

  /// 获取node服务认证token
  Map<String, String> get nodeServiceAuthToken {
    if (_authToken == null) {
      throw Exception("node service not started");
    }
    return {'Content-Type': 'application/json', 'x-auth-token': _authToken!};
  }
}
