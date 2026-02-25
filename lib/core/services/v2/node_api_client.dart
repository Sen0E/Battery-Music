import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:battery_music/core/services/v2/node_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class NodeApiClient {
  static final NodeApiClient _nodeApiClient = NodeApiClient._internal();
  factory NodeApiClient() => _nodeApiClient;

  final NodeManager _nodeManager = NodeManager();

  late Dio _dio;
  late PersistCookieJar _cookieJar;

  Future<void>? _initFuture;

  NodeApiClient._internal() {
    _initFuture = _initNodeClient();
  }

  Future<void> _ensureInitialized() async {
    await _initFuture;
  }

  Future<void> _initNodeClient() async {
    await _nodeManager.startNodeService();

    final baseUrl = _nodeManager.nodeServiceUrl;
    final authHeaders = _nodeManager.nodeServiceAuthToken;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: authHeaders,
      ),
    );

    // 设置 Cookie
    final appSupportDir = await getApplicationSupportDirectory();
    final cookiePath = path.join(appSupportDir.path, '.cookies');
    final cookieDir = Directory(cookiePath);
    if (!cookieDir.existsSync()) {
      cookieDir.createSync(recursive: true);
    }

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  /// 发送 get 请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    try {
      Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      log("node service error: ${e.response}");
      rethrow;
    }
  }

  /// 发送 post 请求
  Future<Response> post(
    String path, {
    dynamic data, // 修正类型声明
    Map<String, dynamic>? queryParameters,
  }) async {
    await _ensureInitialized();
    try {
      Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      log("node service error: ${e.response}");
      rethrow;
    }
  }

  /// 获取 cookies
  Future<List<Cookie>> getCookies() async {
    await _ensureInitialized();
    return _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
  }

  /// 获取 token
  Future<String?> getToken() async {
    final cookies = await getCookies();
    final tokenCookie = cookies
        .where((cookie) => cookie.name == 'token')
        .firstOrNull;
    return tokenCookie?.value;
  }

  /// 检查是否有本地 token
  Future<bool> checkTokenExists() async {
    final cookies = await getCookies();
    return cookies.any((cookie) => cookie.name == 'token');
  }

  /// 清除 cookies
  Future<void> clearCookies() async {
    await _ensureInitialized();
    await _cookieJar.delete(Uri.parse(_dio.options.baseUrl));
  }
}
