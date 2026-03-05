import 'package:flutter/material.dart';
import 'package:kugou_music_api_dart/kugou_music_api_dart.dart';

class MusicApiService {
  static final MusicApiService _musicApiService = MusicApiService._internal();
  factory MusicApiService() => _musicApiService;
  final ApiClient _apiClient = ApiClient();
  MusicApiService._internal();

  /// 手机号登录
  /// [cellPhone] 手机号
  /// [code] 验证码
  Future<Map<String, dynamic>> loginForCellPhone(
    String cellPhone,
    String code,
  ) async {
    final res = await Login.loginByVerifyCode(cellPhone, code);
    debugPrint("loginForCellPhone response: ${res['body']}");
    return res['body'];
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<Map<String, dynamic>> captchaSent(String cellPhone) async {
    final res = await Login.sendMobileCode(cellPhone);
    debugPrint("captchaSent response: ${res['body']}");
    return res['body'];
  }

  /// 获取酷狗登录二维码和Key
  Future<Map<String, dynamic>> loginQrKey() async {
    final res = await Login.loginQrKey();
    debugPrint("loginQrKey response: ${res['body']}");
    return res['body'];
  }

  /// 获取酷狗登录二维码扫码状态
  /// [key] 二维码 Key
  Future<Map<String, dynamic>> loginQrCheck(String key) async {
    final res = await Login.loginQrCheck(key);
    debugPrint("loginQrCode response: ${res['body']}");
    return res['body'];
  }

  /// 刷新登录
  /// [token] 用户 Token
  /// [userid] 用户 ID
  Future<Map<String, dynamic>> loginToken({
    String? token,
    String? userid,
  }) async {
    final res = await Login.loginToken(token: token, userid: userid);
    debugPrint("refreshLogin response: ${res['body']}");
    return res['body'];
  }
  // Future<Map<String, dynamic>> searchSongs(
  //   String keywords, {
  //   int page = 1,
  //   int pageSize = 30,
  // }) async {
  //   return await search.search(keywords, page, pageSize);
  // }

  // /// Get song details by ID
  // Future<Map<String, dynamic>> getSongDetails(
  //   String hash, {
  //   String? albumId,
  // }) async {
  //   return await song.getSongInfo(hash, albumId: albumId);
  // }

  // /// Get playlist details
  // Future<Map<String, dynamic>> getPlaylistDetails(String playlistId) async {
  //   return await playlist.getPlaylistDetail(playlistId);
  // }

  // /// Get user playlists
  // Future<Map<String, dynamic>> getUserPlaylists(String userId) async {
  //   return await user.getUserPlaylists(userId);
  // }

  // /// Get login QR code key
  // Future<String> getQRCodeKey() async {
  //   return await login.getQRCodeKey();
  // }

  // /// Check login status with QR code
  // Future<Map<String, dynamic>> checkLoginStatus(String key) async {
  //   return await login.checkLogin(key);
  // }
}
