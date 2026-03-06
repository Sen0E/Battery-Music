import 'dart:developer';

import 'package:battery_music/models/response/base_api.dart';
import 'package:battery_music/models/response/login_qr_check.dart';
import 'package:battery_music/models/response/login_qr_key.dart';
import 'package:battery_music/models/response/register_dev.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:battery_music/models/response/user_info_detail.dart';
import 'package:flutter/material.dart';
import 'package:kugou_music_api_dart/kugou_music_api_dart.dart';

class MusicApiService {
  static final MusicApiService _musicApiService = MusicApiService._internal();
  factory MusicApiService() => _musicApiService;
  MusicApiService._internal();

  /// 手机号登录
  /// [cellPhone] 手机号
  /// [code] 验证码
  Future<BaseApi<UserInfo>> loginForCellPhone(
    String cellPhone,
    String code,
  ) async {
    final res = await Login.loginByVerifyCode(cellPhone, code);
    debugPrint("loginForCellPhone response: ${res['body']}");
    return BaseApi<UserInfo>.fromMap(
      res['body'],
      (map) => UserInfo.fromMap(map),
    );
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<BaseApi> captchaSent(String cellPhone) async {
    final res = await Login.sendMobileCode(cellPhone);
    debugPrint("captchaSent response: ${res['body']}");
    return BaseApi.fromMap(res['body'], (map) => null);
  }

  /// 获取酷狗登录二维码和Key
  Future<BaseApi<LoginQrKey>> loginQrKey() async {
    final res = await Login.loginQrKey();
    debugPrint("loginQrKey response: ${res['body']}");
    return BaseApi<LoginQrKey>.fromMap(
      res['body'],
      (map) => LoginQrKey.fromMap(map),
    );
  }

  /// 获取酷狗登录二维码扫码状态
  /// [key] 二维码 Key
  Future<BaseApi<LoginQrCheck>> loginQrCheck(String key) async {
    final res = await Login.loginQrCheck(key);
    debugPrint("loginQrCode response: ${res['body']}");
    return BaseApi<LoginQrCheck>.fromMap(
      res['body'],
      (map) => LoginQrCheck.fromMap(map),
    );
  }

  /// 刷新登录
  /// [token] 用户 Token
  /// [userid] 用户 ID
  Future<BaseApi<UserInfo>> loginToken({String? token, String? userid}) async {
    final res = await Login.loginToken(token: token, userid: userid);
    debugPrint("refreshLogin response: ${res['body']}");
    return BaseApi<UserInfo>.fromMap(
      res['body'],
      (map) => UserInfo.fromMap(map),
    );
  }

  /// dfid获取
  Future<BaseApi<RegisterDev>> registerDev() async {
    final res = await Device.registerDev();
    debugPrint("registerDev response: ${res['body']}");
    return BaseApi<RegisterDev>.fromMap(res, (map) => RegisterDev.fromMap(map));
  }

  /// 获取用户详细信息
  Future<BaseApi<UserInfoDetail>> userDetail() async {
    final res = await User.userDetail();
    debugPrint("userDetail response: ${res['body']}");
    return BaseApi<UserInfoDetail>.fromMap(
      res['body'],
      (map) => UserInfoDetail.fromMap(map),
    );
  }
}
