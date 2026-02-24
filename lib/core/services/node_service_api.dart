import 'package:battery_music/models/base_response.dart';
import 'package:battery_music/models/login_qr_check_response.dart';
import 'package:battery_music/models/login_qr_key_response.dart';
import 'package:battery_music/models/login_response.dart';
import 'package:battery_music/core/services/node_api_client.dart';
import 'package:battery_music/models/playlist_track_new_response.dart';
import 'package:battery_music/models/playlist_track_response.dart';
import 'package:battery_music/models/register_dev_response.dart';
import 'package:battery_music/models/search_hot_response.dart';
import 'package:battery_music/models/search_suggest_response.dart';
import 'package:battery_music/models/song_url_response.dart';
import 'package:battery_music/models/user_detial_response.dart';
import 'package:battery_music/models/user_playlist_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Node 服务 API 接口类
/// 封装了与后端 Node 服务交互的具体业务接口
class NodeServiceApi {
  static final NodeServiceApi instance = NodeServiceApi._();
  factory NodeServiceApi() => instance;
  NodeServiceApi._();

  final NodeApiClient _apiClient = NodeApiClient();

  /// 手机号登录
  /// [cellPhone] 手机号
  /// [code] 验证码
  Future<ApiResponse<LoginResponse>> loginForCellPhone(
    String cellPhone,
    String code,
  ) async {
    Response response = await _apiClient.get(
      '/login/cellphone',
      query: {'mobile': cellPhone, 'code': code},
    );
    debugPrint(response.data.toString());
    return ApiResponse<LoginResponse>.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<void> captchaSent(String cellPhone) async {
    Response response = await _apiClient.get(
      '/captcha/sent',
      query: {'mobile': cellPhone},
    );
    debugPrint(response.data.toString());
  }

  /// 获取酷狗登录二维码和Key
  Future<ApiResponse<LoginQrKey>> loginQrKey() async {
    Response response = await _apiClient.get(
      '/login/qr/key',
      query: {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()},
    );
    debugPrint(response.data.toString());
    return ApiResponse<LoginQrKey>.fromJson(
      response.data,
      (json) => LoginQrKey.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取酷狗登录二维码扫码状态
  /// [key] 二维码 Key
  Future<ApiResponse<LoginQrCheck>> loginQrCheck(String key) async {
    Response response = await _apiClient.get(
      '/login/qr/check',
      query: {
        'key': key,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    debugPrint(response.data.toString());
    return ApiResponse<LoginQrCheck>.fromJson(
      response.data,
      (json) => LoginQrCheck.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 刷新登录状态
  /// [token] 用户 Token
  /// [userid] 用户 ID
  Future<ApiResponse<LoginResponse>> loginToken(
    String token,
    String userid,
  ) async {
    Response response = await _apiClient.get(
      '/login/token',
      query: {'token': token, 'userid': userid},
    );
    debugPrint(response.data.toString());
    return ApiResponse<LoginResponse>.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  // 获取用户信息
  Future<ApiResponse<UserDetial>> userDetial() async {
    Response response = await _apiClient.get('/user/detail');
    debugPrint(response.data.toString());
    return ApiResponse<UserDetial>.fromJson(
      response.data,
      (json) => UserDetial.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取热搜榜
  Future<ApiResponse<SearchHotResponse>> searchHot() async {
    Response response = await _apiClient.get('/search/hot');
    debugPrint(response.data.toString());
    return ApiResponse<SearchHotResponse>.fromJson(
      response.data,
      (json) => SearchHotResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 搜索
  /// [keyword] 关键词
  /// [currentPage] 当前页码（未使用，保留参数）
  /// [page] 页码，默认为 1
  /// [pageSize] 每页数量，默认为 30
  /// [type] 搜索类型
  /// [fromJson] 响应数据解析函数
  Future<ApiResponse<T>> searchKeywords<T>(
    String keyword,
    int currentPage, {
    int page = 1,
    int pageSize = 30,
    String type = '',
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    Response response = await _apiClient.get(
      '/search', // 确认你的实际路径
      query: {
        'page': page,
        'pagesize': pageSize,
        'keywords': keyword,
        'type': type,
      },
    );
    debugPrint(response.data.toString());
    return ApiResponse<T>.fromJson(
      response.data,
      (json) => fromJson(json as Map<String, dynamic>),
    );
  }

  /// 搜索建议
  /// [keyword] 关键词
  Future<List<SearchSugges>> searchSuggest(String keyword) async {
    final response = await _apiClient.get(
      '/search/suggest',
      query: {'keywords': keyword}, // 注意：通常是 keyword 不是 keywords，请核对接口
    );
    debugPrint(response.data.toString());
    final apiResponse = ApiResponse<List<SearchSuggestResponse>>.fromJson(
      response.data,
      (json) {
        return (json as List<dynamic>)
            .map(
              (e) => SearchSuggestResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      },
    );

    if (apiResponse.data != null && apiResponse.data!.isNotEmpty) {
      return apiResponse.data!.first.recordDatas ?? [];
    }
    return [];
  }

  /// 获取用户歌单
  Future<ApiResponse<UserPlaylistData>> userPlayList() async {
    Response response = await _apiClient.get('/user/playlist');
    debugPrint(response.data.toString());
    return ApiResponse<UserPlaylistData>.fromJson(
      response.data,
      (json) => UserPlaylistData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取歌单内音乐 (旧版，未使用)
  /// [id] 歌单 ID
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<ApiResponse<PlaylistTrackData>> playlistTrack(
    String id,
    int page,
    int pageSize,
  ) async {
    Response response = await _apiClient.get(
      '/playlist/track/all',
      query: {'id': id, 'page': page, 'pagesize': pageSize},
    );
    debugPrint(response.data.toString());
    return ApiResponse<PlaylistTrackData>.fromJson(
      response.data,
      (json) => PlaylistTrackData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 获取歌单内音乐 (新版)
  /// [listId] 歌单 ID
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<ApiResponse<PlaylistTrackDataNew>> playlistTrackNew(
    int listId,
    int page,
    int pageSize,
  ) async {
    Response response = await _apiClient.get(
      '/playlist/track/all/new',
      query: {'listid': listId, 'page': page, 'pagesize': pageSize},
    );
    debugPrint(response.data.toString());
    return ApiResponse<PlaylistTrackDataNew>.fromJson(
      response.data,
      (json) => PlaylistTrackDataNew.fromJson(json as Map<String, dynamic>),
    );
  }

  //dfid 获取
  Future<RegisterDevResponse> registerDev() async {
    Response response = await _apiClient.get('/register/dev');
    debugPrint(response.data.toString());
    return RegisterDevResponse.fromJson(response.data);
  }

  ///获取音乐URL
  ///[hash] 歌曲hash
  Future<SongUrlResponse> songUrl(String hash) async {
    registerDev(); // 鉴权（必须调用）
    Response response = await _apiClient.get(
      '/song/url',
      query: {'hash': hash},
    );
    debugPrint(response.data.toString());
    return SongUrlResponse.fromJson(response.data);
  }
}
