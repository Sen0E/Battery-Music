import '../core/api_client.dart';
import '../utils/config.dart';
import '../utils/helper_util.dart';

class Album {
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';

  /// 专辑合集查询 (album.js)
  /// [albumIds] 支持用逗号分隔的多个专辑 ID
  static Future<Map<String, dynamic>> album(
    String albumIds, {
    String fields = '',
    Map<String, String>? cookie,
  }) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch;
    final String dfid =
        cookie?['dfid'] ?? ApiClient().currentCookies['dfid'] ?? '-';

    final List<Map<String, String>> data = albumIds
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'album_id': s.trim(), 'album_name': '', 'author_name': ''})
        .toList();

    final Map<String, dynamic> dataMap = {
      'appid': Config.appid,
      'clienttime': clienttime,
      'clientver': Config.clientver,
      'data': data,
      'dfid': dfid,
      'fields': fields,
      'key': HelperUtil.signParamsKey(clienttime, appid: Config.appid),
      'mid': _mid,
    };

    if (_token.isNotEmpty) dataMap['token'] = _token;
    if (_userid != 0) dataMap['userid'] = _userid;

    return ApiClient().createRequest(
      baseURL: 'http://kmr.service.kugou.com',
      url: '/v1/album',
      method: 'POST',
      data: dataMap,
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {
        'x-router': 'kmr.service.kugou.com',
        'Content-Type': 'application/json',
      },
    );
  }

  /// 专辑详情 (album_detail.js)
  static Future<Map<String, dynamic>> albumDetail(
    dynamic id, {
    bool isBuy = false,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/kmr/v2/albums',
      method: 'POST',
      data: {
        'data': [
          {'album_id': id},
        ],
        'is_buy': isBuy ? 1 : 0,
        'fields':
            'album_id,album_name,publish_date,sizable_cover,intro,language,is_publish,heat,type,quality,authors,exclusive,author_name,trans_param',
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'openapi.kugou.com', 'kg-tid': '255'},
    );
  }

  /// 专辑音乐列表 (album_songs.js)
  static Future<Map<String, dynamic>> albumSongs(
    dynamic id, {
    int page = 1,
    int pagesize = 30,
    bool isBuy = false,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/v1/album_audio/lite',
      method: 'POST',
      data: {
        'album_id': id,
        'is_buy': isBuy ? 1 : '',
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'openapi.kugou.com', 'kg-tid': '255'},
    );
  }
}
