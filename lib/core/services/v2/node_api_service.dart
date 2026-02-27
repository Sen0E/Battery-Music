import 'package:battery_music/core/services/v2/node_api_client.dart';
import 'package:battery_music/models/search_hot_response.dart';
import 'package:battery_music/models/v2/base_api.dart';
import 'package:battery_music/models/v2/daily_recommend.dart';
import 'package:battery_music/models/v2/login_qr_check.dart';
import 'package:battery_music/models/v2/login_qr_key.dart';
import 'package:battery_music/models/v2/playlist_track.dart';
import 'package:battery_music/models/v2/register_dev.dart';
import 'package:battery_music/models/v2/search_hot.dart';
import 'package:battery_music/models/v2/search_keywords.dart';
import 'package:battery_music/models/v2/song_data.dart';
import 'package:battery_music/models/v2/top_card.dart';
import 'package:battery_music/models/v2/user_info.dart';
import 'package:battery_music/models/v2/user_info_detail.dart';
import 'package:battery_music/models/v2/user_playlist.dart';
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
      (map) => UserInfo.fromMap(map),
    );
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<BaseApi> captchaSent(String cellPhone) async {
    Response response = await _nodeApiClient.post(
      '/captcha/sent',
      queryParameters: {'mobile': cellPhone},
    );
    debugPrint("Captcha response: ${response.data}");
    return BaseApi.fromMap(response.data, (json) => null);
  }

  /// 获取酷狗登录二维码和Key
  Future<BaseApi<LoginQrKey>> loginQrKey() async {
    Response response = await _nodeApiClient.post(
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
    Response response = await _nodeApiClient.post(
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
  Future<BaseApi<UserInfo>> loginToken({String? token, String? userid}) async {
    Response response = await _nodeApiClient.post(
      '/login/token',
      queryParameters: (token == null || userid == null)
          ? null
          : {'token': token, 'userid': userid},
    );
    debugPrint("loginToken response: ${response.data}");
    return BaseApi<UserInfo>.fromMap(
      response.data,
      (map) => UserInfo.fromMap(map),
    );
  }

  /// dfid获取
  Future<BaseApi<RegisterDev>> registerDev() async {
    Response response = await _nodeApiClient.post('/register/dev');
    debugPrint("registerDev response: ${response.data}");
    return BaseApi<RegisterDev>.fromMap(
      response.data,
      (map) => RegisterDev.fromMap(map),
    );
  }

  /// 获取用户详细信息
  Future<BaseApi<UserInfoDetail>> userDetail() async {
    Response response = await _nodeApiClient.post('/user/detail');
    debugPrint("User detail response: ${response.data}");
    return BaseApi<UserInfoDetail>.fromMap(
      response.data,
      (map) => UserInfoDetail.fromMap(map),
    );
  }

  /// 获取用户歌单
  Future<BaseApi<UserPlaylist>> userPlaylist({int? page, int? pageSize}) async {
    Response response = await _nodeApiClient.post(
      '/user/playlist',
      queryParameters: (page == null || pageSize == null)
          ? null
          : {'page': page, 'pagesize': pageSize},
    );
    debugPrint("User playlist response: ${response.data}");
    return BaseApi<UserPlaylist>.fromMap(
      response.data,
      (map) => UserPlaylist.fromMap(map),
    );
  }

  /// 获取歌单内音乐(所有的歌单)
  /// [id] 歌单 全局id
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<BaseApi<PlaylistTrack>> playlistTrack(
    String id, {
    int? page,
    int? pageSize = 30,
  }) async {
    Response response = await _nodeApiClient.get(
      '/playlist/track/all',
      queryParameters: {'id': id, 'page': page, 'pagesize': pageSize},
    );
    debugPrint("Playlist track response: ${response.data}");
    return BaseApi<PlaylistTrack>.fromMap(
      response.data,
      (map) => PlaylistTrack.fromMap(map),
    );
  }

  /// 获取热搜列表(实际并非热搜，太扯了这个API)
  Future<BaseApi<SearchHot>> searchHot() async {
    Response response = await _nodeApiClient.post('/search/hot');
    debugPrint("Search hot response: ${response.data}");
    return BaseApi<SearchHot>.fromMap(
      response.data,
      (map) => SearchHot.fromMap(map),
    );
  }

  /// 每日推荐
  Future<BaseApi<DailyRecommend>> everydayRecommend() async {
    Response response = await _nodeApiClient.post('/everyday/recommend');
    debugPrint("Everyday recommend response: ${response.data}");
    return BaseApi<DailyRecommend>.fromMap(
      response.data,
      (map) => DailyRecommend.fromMap(map),
    );
  }

  /// 歌曲推荐
  /// [cardId] 1：对应安卓 精选好歌随心听 || 私人专属好歌，2：对应安卓 经典怀旧金曲，
  /// 3：对应安卓 热门好歌精选，4：对应安卓 小众宝藏佳作，5：未知，6：对应 vip 专属推荐
  Future<BaseApi<TopCard>> topCard(int cardId) async {
    Response response = await _nodeApiClient.post(
      '/top/card',
      queryParameters: {'card_id': cardId},
    );
    debugPrint("Top card response: ${response.data}");
    return BaseApi<TopCard>.fromMap(
      response.data,
      (map) => TopCard.fromMap(map),
    );
  }

  ///获取音乐URL
  ///[hash] 歌曲hash
  ///[freePart] 是否返回试听部分（仅部分歌曲）(0：否, 1：是)
  ///[quality] 音质(128,320,flac,high)
  Future<SongData> songUrl(
    String hash, {
    int? freePart,
    String? quality,
  }) async {
    Response response = await _nodeApiClient.post(
      '/song/url',
      queryParameters: {
        'hash': hash,
        if (freePart != null) 'free_part': freePart,
        if (quality != null) 'quality': quality,
      },
    );
    debugPrint(response.data.toString());
    return SongData.fromMap(response.data);
  }

  /// 搜索
  /// [keywords] 关键字
  /// [type] 搜索类型(默认为单曲，special：歌单，lyric：歌词，song：单曲，album：专辑，author：歌手，mv：mv)
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<BaseApi<SearchKeywords>> searchKeywords(
    String keywords, {
    String? type,
    int? page,
    int? pageSize,
  }) async {
    Response response = await _nodeApiClient.post(
      '/search',
      queryParameters: {
        'keywords': keywords,
        if (type != null) 'type': type,
        if (page != null) 'page': page,
        if (pageSize != null) 'pagesize': pageSize,
      },
    );
    return BaseApi<SearchKeywords>.fromMap(
      response.data,
      (map) => SearchKeywords.fromMap(map),
    );
  }

  /// 搜索建议
  /// [keywords] 关键词
  /// [albumTipCount] 专辑提示数量
  /// [correctTipCount] 不知道
  /// [mvTipCount] MV提示数量
  /// [musicTipCount] 音乐提示数量
  Future<Response> searchSuggest(
    String keywords, {
    int? albumTipCount,
    int? correctTipCount,
    int? mvTipCount,
    int? musicTipCount,
  }) async {
    final response = await _nodeApiClient.post(
      '/search/suggest',
      queryParameters: {
        'keywords': keywords,
        if (albumTipCount != null) 'albumTipCount': albumTipCount,
        if (correctTipCount != null) 'correctTipCount': correctTipCount,
        if (mvTipCount != null) 'mvTipCount': mvTipCount,
        if (musicTipCount != null) 'musicTipCount': musicTipCount,
      },
    );
    debugPrint(response.data.toString());
    return response;
  }
}
