import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../utils/config.dart';
import '../utils/helper_util.dart';
import '../utils/crypto_util.dart';

/// 签名加密方式枚举
enum EncryptType { android, web, register }

class ApiClient {
  final Dio _dio;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// 是否为概念版
  bool isLite = false;

  /// 内存中常驻的全局 Cookie
  final Map<String, String> _globalCookies = {};

  /// Cookie 变化时的回调，供 Flutter 层的 UserService 监听落盘
  void Function(Map<String, String> currentCookies)? onCookieUpdated;

  void init({bool isLiteVersion = false, Map<String, String>? savedCookies}) {
    isLite = isLiteVersion;

    if (savedCookies != null) {
      _globalCookies.clear();
      _globalCookies.addAll(savedCookies);
    }

    log(
      'ApiClient 初始化完成 | isLite: $isLite | 注入 Cookie 数量: ${_globalCookies.length}',
    );
  }

  /// 供 UserService 退出登录时调用
  void clearCookies() {
    _globalCookies.clear();
    // 触发回调，通知外部清空本地缓存
    if (onCookieUpdated != null) {
      onCookieUpdated!(_globalCookies);
    }
  }

  /// 增量更新全局 Cookie（供底层特殊接口手动调用）
  void updateCookies(Map<String, String> newCookies) {
    bool hasChanged = false;
    newCookies.forEach((key, value) {
      if (_globalCookies[key] != value) {
        _globalCookies[key] = value;
        hasChanged = true;
      }
    });
    log(
      'ApiClient 更新 Cookie | 新 Cookie 数量: ${newCookies.length} | 合并后 Cookie 数量: ${_globalCookies.length}',
    );

    // 只有当 Cookie 真的发生改变时，才触发回调通知外部落盘
    if (hasChanged && onCookieUpdated != null) {
      onCookieUpdated!(_globalCookies);
    }
  }

  /// 获取当前所有的 Cookie (对外只读，防止被外部意外修改)
  Map<String, String> get currentCookies => Map.unmodifiable(_globalCookies);

  /// 核心请求创建方法
  Future<Map<String, dynamic>> createRequest({
    required String method,
    required String url,
    String? baseURL,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
    EncryptType encryptType = EncryptType.android,
    Map<String, String>? cookie, // 局部特供 Cookie
    bool encryptKey = false,
    bool clearDefaultParams = false,
    bool notSignature = false,
    String? ip,
  }) async {
    final Map<String, String> mergedCookie = {
      ..._globalCookies,
      if (cookie != null) ...cookie,
    };
    // 1. 提取基础信息
    final String dfid = mergedCookie['dfid'] ?? '-';
    final String mid = mergedCookie['KUGOU_API_MID'] ?? '-';
    final String uuid = '-';
    final String token = mergedCookie['token'] ?? '';
    final int userid = int.tryParse(mergedCookie['userid'] ?? '0') ?? 0;

    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 2. 组装请求头 Headers
    final Map<String, dynamic> reqHeaders = {
      'dfid': dfid,
      'clienttime': clienttime,
      'mid': mid,
      'kg-rc': '1',
      'kg-thash': '5d816a0',
      'kg-rec': 1,
      'kg-rf': 'B9EDA08A64250DEFFBCADDEE00F8F25F',
      'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
    };

    if (ip != null && ip.isNotEmpty) {
      reqHeaders['X-Real-IP'] = ip;
      reqHeaders['X-Forwarded-For'] = ip;
    }

    // 合并传入的 custom headers
    if (headers != null) {
      reqHeaders.addAll(headers);
    }

    // 3. 组装请求参数 Params
    final Map<String, dynamic> defaultParams = {
      'dfid': dfid,
      'mid': mid,
      'uuid': uuid,
      'appid': isLite ? Config.liteAppid : Config.appid,
      'clientver': isLite ? Config.liteClientver : Config.clientver,
      'clienttime': clienttime,
    };

    if (token.isNotEmpty) defaultParams['token'] = token;
    if (userid != 0) defaultParams['userid'] = userid;

    // 决定最终的 params
    Map<String, dynamic> finalParams = {};
    if (clearDefaultParams) {
      finalParams = Map.from(params ?? {});
    } else {
      finalParams = Map.from(defaultParams);
      if (params != null) finalParams.addAll(params);
    }

    reqHeaders['clienttime'] = finalParams['clienttime'];

    // 4. 特殊加密 Key 处理 (encryptKey)
    if (encryptKey) {
      finalParams['key'] = HelperUtil.signKey(
        finalParams['hash']?.toString() ?? '',
        finalParams['mid']?.toString() ?? '',
        userid: finalParams['userid'],
        appid: finalParams['appid'],
        isLite: isLite,
      );
    }

    // 5. 格式化 Body 数据
    final String dataString = (data is Map || data is List)
        ? jsonEncode(data)
        : (data?.toString() ?? '');

    // 6. 核心：全自动防伪签名 (Signature)
    if (!finalParams.containsKey('signature') && !notSignature) {
      switch (encryptType) {
        case EncryptType.register:
          finalParams['signature'] = HelperUtil.signatureRegisterParams(
            finalParams,
          );
          break;
        case EncryptType.web:
          finalParams['signature'] = HelperUtil.signatureWebParams(finalParams);
          break;
        case EncryptType.android:
          finalParams['signature'] = HelperUtil.signatureAndroidParams(
            finalParams,
            data: dataString,
            isLite: isLite,
          );
          break;
      }
    }

    // 7. 特殊 baseURL 处理 (openapicdn 走 URL params 拼接)
    String reqUrl = url;
    String finalBaseUrl = baseURL ?? 'https://gateway.kugou.com';

    if (finalBaseUrl.contains('openapicdn')) {
      final String queryStr = finalParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      reqUrl = '$url?$queryStr';
      finalParams = {}; // 清空，因为已经拼到 URL 上了
    }

    // 8. 拼装 Dio RequestOptions
    final options = Options(
      method: method.toUpperCase(),
      headers: reqHeaders,
      // 如果需要在 Dio 中携带 Cookie 字符串，可以放在 headers 里，但最好依靠 DioCookieManager
      // 这里如果外部传了手动 cookie，可以拼成字符串
      extra: {'custom_cookie': cookie},
    );
    if (cookie != null && cookie.isNotEmpty) {
      final cookieStr = cookie.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
      options.headers?['Cookie'] = cookieStr;
    }

    final Map<String, dynamic> answer = {
      'status': 500,
      'body': {},
      'cookie': <String>[],
      'headers': <String, String>{},
    };

    // 9. 发送真实请求并处理响应
    try {
      // print("🚀 发起请求: $method $url");
      // print("请求参数: $finalParams");
      // print("请求数据: $dataString");
      // print("请求头: ${options.headers}");
      final response = await _dio.request(
        finalBaseUrl + reqUrl,
        queryParameters: finalParams.isNotEmpty ? finalParams : null,
        data: dataString.isNotEmpty ? dataString : null,
        options: options,
      );
      final List<String> setCookies = response.headers['set-cookie'] ?? [];
      bool hasCookieChanged = false;

      for (var c in setCookies) {
        // 使用你的 CryptoUtil 解析单条 cookie 字符串为键值对
        final Map<String, String> parsed = CryptoUtil.cookieToJson(
          CryptoUtil.parseCookieString(c),
        );
        parsed.forEach((k, v) {
          if (_globalCookies[k] != v) {
            _globalCookies[k] = v;
            hasCookieChanged = true;
          }
        });
        answer['cookie'].add(c); // 保留旧的返回格式兼容历史逻辑
      }

      // 触发回调，通知 UserService 保存新 Cookie
      if (hasCookieChanged && onCookieUpdated != null) {
        onCookieUpdated!(_globalCookies);
      }

      if (response.headers.value('ssa-code') != null) {
        answer['headers']['ssa-code'] = response.headers.value('ssa-code');
      }

      dynamic responseData = response.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
          // 如果不是合法的 JSON 字符串，保持原样
        }
      }

      answer['body'] = responseData;

      // 判断业务逻辑错误
      if (responseData is Map) {
        if (responseData['status'] == 0 ||
            (responseData['error_code'] != null &&
                responseData['error_code'] != 0)) {
          answer['status'] = 502;
          return answer; // 相当于 JS 的 reject
        }
      }

      answer['status'] = 200;
      return answer; // 相当于 JS 的 resolve
    } on DioException catch (e) {
      answer['status'] = 502;
      answer['body'] = {'status': 0, 'msg': e.message};
      return answer;
    } catch (e) {
      answer['status'] = 502;
      answer['body'] = {'status': 0, 'msg': e.toString()};
      return answer;
    }
  }
}
