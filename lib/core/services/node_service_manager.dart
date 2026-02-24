import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Node 服务管理器
/// 负责启动、停止本地 Node 服务进程，并管理服务地址和认证 Token
class NodeServiceManager {
  Process? _nodeProcess;
  String? _nodeExecPath;
  String? _nodeApiUrl;
  String? _authToken;

  NodeServiceManager._();
  static final NodeServiceManager instance = NodeServiceManager._();
  factory NodeServiceManager() => instance;

  /// 初始化 Node 服务
  /// 检查并复制 Node 服务可执行文件到应用支持目录
  Future<void> initNodeService() async {
    String assetName, execName;
    if (Platform.isLinux) {
      assetName = "assets/node_service/app_linux";
      execName = "app_linux";
    } else if (Platform.isMacOS) {
      assetName = "assets/node_service/app_macos";
      execName = "app_macos";
    } else if (Platform.isWindows) {
      assetName = "assets/node_service/app_win.exe";
      execName = "app_win.exe";
    } else {
      throw UnimplementedError(
        "Unsupported platform:${Platform.operatingSystem}",
      );
    }

    final appSupportDir = await getApplicationSupportDirectory();
    final execDir = Directory("${appSupportDir.path}/NodeService");
    if (!execDir.existsSync()) {
      execDir.createSync(recursive: true);
    }
    _nodeExecPath = "${execDir.path}/$execName";
    final execFile = File(_nodeExecPath!);

    if (!execFile.existsSync()) {
      final assetBytes = await rootBundle.load(assetName);
      await execFile.writeAsBytes(
        assetBytes.buffer.asUint8List(
          assetBytes.offsetInBytes,
          assetBytes.lengthInBytes,
        ),
      );

      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run("chmod", ["+x", _nodeExecPath!]);
      }
    }
  }

  /// 启动 Node 服务
  /// 返回服务 API 地址
  Future<String> startNodeService() async {
    if (_nodeProcess != null) return _nodeApiUrl!;
    if (_nodeExecPath == null) await initNodeService();

    final Completer<String> completer = Completer();

    _authToken = Uuid().v4();

    _nodeProcess = await Process.start(
      _nodeExecPath!,
      [],
      environment: {'API_TOKEN': _authToken!, 'PORT': '0', 'HOST': '127.0.0.1'},
    );
    log("Node Server: Started PID:${_nodeProcess!.pid}");

    _nodeProcess!.stdout.transform(utf8.decoder).listen((event) {
      if (!completer.isCompleted && event.contains('server running @')) {
        final match = RegExp(r'(http://127\.0\.0\.1:\d+)').firstMatch(event);
        if (match != null) {
          _nodeApiUrl = match.group(1);
          completer.complete(_nodeApiUrl);
        }
      }
      log("Node Server: $event");
    });
    _nodeProcess!.stderr.transform(utf8.decoder).listen((event) {
      log("Node Server: $event");
    });
    _nodeProcess!.exitCode.then((exitCode) {
      log("Node Server: Exited with code: $exitCode");
    });
    return completer.future;
  }

  /// 停止 Node 服务
  Future<void> stopNodeService() async {
    if (_nodeProcess == null) return;
    log("Node Server: Stopping PID:${_nodeProcess!.pid}");
    _nodeProcess!.kill();
    _nodeProcess = null;
    _nodeApiUrl = null;
    _authToken = null;
  }

  /// 获取 Node 服务 API 地址
  String get nodeApiUrl => _nodeApiUrl!;

  /// 获取认证 Token Header
  Map<String, String> get authToken => {
    'Content-Type': 'application/json',
    'x-auth-token': _authToken!,
  };
}
