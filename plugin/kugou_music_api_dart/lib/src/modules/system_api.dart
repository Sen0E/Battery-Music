import '../core/api_client.dart';
import '../utils/config.dart';
import '../utils/helper_util.dart';

class SystemApi {
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _vipType =>
      int.tryParse(ApiClient().currentCookies['vip_type'] ?? '0') ?? 0;

  /// 获取服务器时间 (server_now.js)
  static Future<Map<String, dynamic>> serverNow({
    String? token,
    String? userid,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/v1/server_now',
      method: 'POST',
      params: {'plat': 3},
      data: {
        'token': token ?? cookie?['token'] ?? _token,
        'userid':
            int.tryParse(userid ?? cookie?['userid'] ?? _userid.toString()) ??
            _userid,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'usercenter.kugou.com'},
    );
  }

  /// 刷刷 (brush.js)
  static Future<Map<String, dynamic>> brush({
    Map<String, String>? cookie,
  }) async {
    final int dateTime = DateTime.now().millisecondsSinceEpoch;

    return ApiClient().createRequest(
      url: '/genesisapi/v1/newepoch_song_rec/feed',
      method: 'POST',
      params: {
        'sort_type': 1,
        'platform': 'ios',
        'page': 1,
        'content_ver': 4,
        'clientver': 11850,
      },
      data: {
        'behaviors': [],
        'abtest': {
          'abtest': {
            'shuashua': {'commentcard': 2},
          },
        },
        'personal_recommend_params': {
          'userid': _userid,
          'appid': Config.appid,
          'playlist_ver': 2,
          'clienttime': dateTime,
          'mid': _mid,
          'new_sync_point': dateTime,
          'module_id': 1,
          'action': 'login',
          'vip_type': _vipType,
          'vip_flags': 3,
          'recommend_source_locked': 0,
          'song_pool_id': 0,
          'callerid': 0,
          'm_type': 1,
          'kguid': _userid,
          'platform': 'ios',
          'area_code': 1,
          'fakem': 'ca981cfc583a4c37f28d2d49000013c16a0a',
          'clientver': 11850,
          'mode': 'normal',
          'active_swtich': 'on',
          'key': HelperUtil.signParamsKey(dateTime),
        },
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// AI 推荐 (ai_recommend.js)
  static Future<Map<String, dynamic>> aiRecommend({
    required dynamic albumAudioId,
    Map<String, String>? cookie,
  }) async {
    final int dateTime = DateTime.now().millisecondsSinceEpoch;

    final List<Map<String, dynamic>> recommendSource = albumAudioId
        .toString()
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'ID': int.tryParse(s.trim()) ?? 0})
        .toList();

    return ApiClient().createRequest(
      url: '/recommend',
      method: 'POST',
      data: {
        'platform': 'ios',
        'clientver': Config.clientver,
        'clienttime': dateTime,
        'userid': _userid,
        'client_playlist': [],
        'source_type': 2,
        'playlist_ver': 2,
        'area_code': 1,
        'appid': Config.appid,
        'key': HelperUtil.signParamsKey(dateTime.toString()),
        'mid': _mid,
        'recommend_source': recommendSource,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'songlistairec.kugou.com'},
      clearDefaultParams: true,
    );
  }
}
