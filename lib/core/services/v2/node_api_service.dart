import 'package:battery_music/core/services/v2/node_api_client.dart';
import 'package:battery_music/models/v2/base_api.dart';
import 'package:battery_music/models/v2/daily_recommend.dart';
import 'package:battery_music/models/v2/login_qr_check.dart';
import 'package:battery_music/models/v2/login_qr_key.dart';
import 'package:battery_music/models/v2/register_dev.dart';
import 'package:battery_music/models/v2/search_hot.dart';
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
  Future<Response> songUrl(String hash, String dfid) async {
    Response response = await _nodeApiClient.get(
      '/song/url',
      queryParameters: {'hash': hash, 'dfid': dfid},
    );
    debugPrint(response.data.toString());
    return response;
  }
}
