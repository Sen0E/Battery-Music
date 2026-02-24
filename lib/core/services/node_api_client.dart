import 'dart:io';
import 'package:battery_music/core/services/node_service_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Node API 客户端
/// 封装 Dio 实例，处理请求拦截、Cookie 管理等
class NodeApiClient {
  static final NodeApiClient instance = NodeApiClient._();
  factory NodeApiClient() => instance;

  late Dio _dio;
  // 将 _cookieJar 设为可空，因为它是异步初始化的
  PersistCookieJar? _cookieJar;

  NodeApiClient._() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    // 添加原本的 Auth 和 BaseUrl 拦截器
    // 注意：这个拦截器必须在 CookieManager 之前添加！
    // 这样 Dio 才能先确定最终的 URL，CookieManager 才能根据 URL 匹配 Cookie。
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final nodeServiceManager = NodeServiceManager();

          // 动态设置 BaseUrl
          options.baseUrl = nodeServiceManager.nodeApiUrl;
          options.headers.addAll(nodeServiceManager.authToken);

          return handler.next(options);
        },
      ),
    );
  }

  /// 初始化 Cookie 管理
  /// 必须在 main.dart 或 App 启动早期调用
  Future<void> init() async {
    if (_cookieJar != null) return;

    // 获取存储路径
    Directory dir;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dir = await getApplicationSupportDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    // 拼接 Cookie 存储路径
    final cookiePath = p.join(dir.path, '.cookies');

    // 确保目录存在
    Directory(cookiePath).createSync(recursive: true);

    // 创建持久化 CookieJar
    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    // 将 CookieManager 拦截器添加到 Dio
    // 此时它会被追加到拦截器队列的末尾（在 Auth 拦截器之后执行，这是正确的顺序）
    _dio.interceptors.add(CookieManager(_cookieJar!));
  }

  /// 检查是否有本地 Cookie
  Future<bool> hasCookies() async {
    if (_cookieJar == null) return false;

    final cookies = await _cookieJar!.loadForRequest(
      Uri.parse(NodeServiceManager.instance.nodeApiUrl),
    );
    return cookies.any((cookie) => cookie.name == 'token');
  }

  /// 清除 Cookie
  Future<void> clearCookies() async {
    await _cookieJar?.deleteAll();
  }

  /// 获取所有 Cookie
  Future<List> getCookies() async {
    final cookies = await _cookieJar?.loadForRequest(
      Uri.parse(NodeServiceManager.instance.nodeApiUrl),
    );

    if (cookies == null) {
      return List.empty();
    }
    return cookies;
  }

  /// 发送 GET 请求
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return _dio.get(path, queryParameters: query);
  }

  /// 发送 POST 请求
  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  /// 发送 PUT 请求
  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  /// 发送 DELETE 请求
  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }
}
