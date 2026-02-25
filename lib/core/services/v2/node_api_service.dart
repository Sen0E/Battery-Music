import 'package:battery_music/core/services/v2/node_api_client.dart';
import 'package:battery_music/models/v2/base_api.dart';
import 'package:battery_music/models/v2/login_qr_check.dart';
import 'package:battery_music/models/v2/login_qr_key.dart';
import 'package:battery_music/models/v2/user_info.dart';
import 'package:battery_music/models/v2/user_info_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NodeApiService {
  // 单例
  static final NodeApiService _nodeApiService = NodeApiService._internal();
  factory NodeApiService() => _nodeApiService;

  final NodeApiClient _nodeApiClient = NodeApiClient();

  NodeApiService._internal();

  /// 手机号登录
  /// [cellPhone] 手机号
  /// [code] 验证码
  Future<BaseApi<UserInfo>> loginForCellPhone(
    String cellPhone,
    String code,
  ) async {
    Response response = await _nodeApiClient.post(
      '/login/cellphone',
      queryParameters: {'mobile': cellPhone, 'code': code},
    );
    debugPrint("Login response: ${response.data}");
    return BaseApi<UserInfo>.fromMap(
      response.data,
      (json) => UserInfo.fromMap(json as Map<String, dynamic>),
    );
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<BaseApi> captchaSent(String cellPhone) async {
    Response response = await _nodeApiClient.get(
      '/captcha/sent',
      queryParameters: {'mobile': cellPhone},
    );
    debugPrint("Captcha response: ${response.data}");
    return BaseApi.fromMap(response.data, (json) => null);
  }

  /// 获取酷狗登录二维码和Key
  Future<BaseApi<LoginQrKey>> loginQrKey() async {
    Response response = await _nodeApiClient.get(
      '/login/qr/key',
      queryParameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    debugPrint("LoginQrKey response: ${response.data}");
    return BaseApi<LoginQrKey>.fromMap(
      response.data,
      (map) => LoginQrKey.fromMap(map),
    );
  }

  /// 获取酷狗登录二维码扫码状态
  /// [key] 二维码 Key
  Future<BaseApi<LoginQrCheck>> loginQrCheck(String key) async {
    Response response = await _nodeApiClient.get(
      '/login/qr/check',
      queryParameters: {
        'key': key,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    debugPrint("loginQrCheck response: ${response.data}");
    return BaseApi<LoginQrCheck>.fromMap(
      response.data,
      (map) => LoginQrCheck.fromMap(map),
    );
  }

  /// 刷新登录
  /// [token] 用户 Token
  /// [userid] 用户 ID
  Future<BaseApi<UserInfo>> loginToken(String token, String userid) async {
    Response response = await _nodeApiClient.get(
      '/login/token',
      queryParameters: {'token': token, 'userid': userid},
    );
    debugPrint("loginToken response: ${response.data}");
    return BaseApi<UserInfo>.fromMap(
      response.data,
      (map) => UserInfo.fromMap(map),
    );
  }

  /// 获取用户详细信息
  Future<BaseApi<UserInfoDetail>> userDetail() async {
    Response response = await _nodeApiClient.get('/user/detail');
    debugPrint("User detail response: ${response.data}");
    return BaseApi<UserInfoDetail>.fromMap(
      response.data,
      (map) => UserInfoDetail.fromMap(map),
    );
  }
}
