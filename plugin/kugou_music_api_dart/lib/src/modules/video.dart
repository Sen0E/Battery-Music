import '../core/api_client.dart';
import '../utils/config.dart';
import '../utils/encrypt_util.dart';
import '../utils/helper_util.dart';

class Video {
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static int get _vipType =>
      int.tryParse(ApiClient().currentCookies['vip_type'] ?? '0') ?? 0;
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';
  static String get _dfid => ApiClient().currentCookies['dfid'] ?? '-';

  /// 获取视频播放地址 (video_url.js)
  static Future<Map<String, dynamic>> videoUrl(
    String hash, {
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      baseURL: 'https://trackermv.kugou.com',
      url: '/v2/interface/index',
      method: 'GET',
      params: {
        'backupdomain': 1,
        'cmd': 123,
        'ext': 'mp4',
        'ismp3': 0,
        'hash': hash,
        'pid': 1,
        'type': 1,
      },
      encryptType: EncryptType.android,
      encryptKey: true,
      cookie: cookie,
      headers: {'x-router': 'trackermv.kugou.com'},
    );
  }

  /// 获取视频特权信息 (video_privilege.js)
  static Future<Map<String, dynamic>> videoPrivilege({
    required String hash,
    Map<String, String>? cookie,
  }) async {
    final List<Map<String, dynamic>> resource = hash
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'hash': s.trim(), 'id': 0, 'name': ''})
        .toList();

    return ApiClient().createRequest(
      url: '/v1/get_video_privilege',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'area_code': 1,
        'behavior': 'play',
        'clientver': Config.clientver,
        'dfid': cookie?['dfid'] ?? _dfid,
        'mid': _mid,
        'resource': resource,
        'token': _token,
        'userid': _userid,
        'vip': _vipType,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'media.store.kugou.com'},
    );
  }

  /// 获取视频详情 (video_detail.js)
  static Future<Map<String, dynamic>> videoDetail({
    required dynamic id,
    Map<String, String>? cookie,
  }) async {
    final String dfid = cookie?['dfid'] ?? _dfid;
    final String mid = _mid;
    final String uuid = EncryptUtil.cryptoMd5('$dfid$mid');
    final String token = cookie?['token'] ?? _token;
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final List<Map<String, dynamic>> resource = id
        .toString()
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'video_id': s.trim()})
        .toList();

    return ApiClient().createRequest(
      url: '/v1/video',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'clienttime': clienttime,
        'mid': mid,
        'uuid': uuid,
        'dfid': dfid,
        'token': token,
        'key': HelperUtil.signParamsKey(clienttime.toString()),
        'show_resolution': 1,
        'data': resource,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      clearDefaultParams: true,
      notSignature: true,
      headers: {'x-router': 'kmr.service.kugou.com'},
    );
  }
}
