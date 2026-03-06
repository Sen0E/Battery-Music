import '../core/api_client.dart';
import '../utils/helper_util.dart';
import '../utils/config.dart';

class Top {
  // 从底层引擎快速提取用户状态
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';
  static String get _dfid => ApiClient().currentCookies['dfid'] ?? '-';

  // ==========================================
  // 卡片流推荐 (首页/发现页信息流)
  // ==========================================

  /// 热门好歌精选 (经典版推荐卡片 - top_card.js)
  /// [cardId] 1: 精选好歌随心听/私人专属, 2: 经典怀旧, 3: 热门好歌, 4: 小众宝藏, 6: vip专属
  static Future<Map<String, dynamic>> topCard({int? cardId = 1}) async {
    const String fakem = '60f7ebf1f812edbac3c63a7310001701760f';
    final int dateTime = DateTime.now().millisecondsSinceEpoch;

    return ApiClient().createRequest(
      url: '/singlecardrec.service/v1/single_card_recommend',
      method: 'POST',
      params: {
        'card_id': cardId,
        'fakem': fakem,
        'area_code': 1,
        'platform': 'ios',
      },
      data: {
        'appid': KugouConfig.appid,
        'clientver': KugouConfig.clientver,
        'platform': 'android',
        'clienttime': dateTime,
        'userid': _userid,
        'key': HelperUtil.signParamsKey(dateTime, appid: KugouConfig.appid),
        'fakem': fakem,
        'area_code': 1,
        'mid': _mid,
        'uuid': '-',
        'client_playlist': [],
        'u_info': 'a0c35cd40af564444b5584c2754dedec', // 固定的特征追踪码
      },
      encryptType: EncryptType.android,
    );
  }

  /// 热门好歌精选 (青春版/新版推荐卡片 - top_card_youth.js)
  /// [cardId] 3001:私人专属, 3004:小众宝藏, 3005:潮流尝鲜, 3006:VIP专属, 3101:概念er新推 等
  static Future<Map<String, dynamic>> topCardYouth({
    int cardId = 3005,
    int pagesize = 30,
    String tagid = '',
  }) async {
    return ApiClient().createRequest(
      url: 'youth/v1/song/single_card_recommend',
      method: 'POST',
      params: {
        'card_id': cardId,
        'area_code': 1,
        'platform': 'ops',
        'module_id': 1,
        'ver': 'v2',
        'pagesize': pagesize,
      },
      data: {'tagid': tagid, 'u_info': '', 'source_mixsong': ''},
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 核心资源推荐 (歌单、歌曲、专辑)
  // ==========================================

  /// 推荐歌单 (top_playlist.js)
  /// [categoryId] 0: 推荐, 11292: HI-RES
  static Future<Map<String, dynamic>> topPlaylist({
    int categoryId = 0,
    int page = 1,
    int pagesize = 30,
    int moduleId = 1,
    int withtag = 1,
    int withsong = 1,
    int sort = 1,
  }) async {
    final int dateTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return ApiClient().createRequest(
      url: '/v2/special_recommend',
      method: 'POST',
      data: {
        'appid': KugouConfig.appid,
        'mid': _mid,
        'clientver': KugouConfig.clientver,
        'platform': 'android',
        'clienttime': dateTime,
        'userid': _userid,
        'module_id': moduleId,
        'page': page,
        'pagesize': pagesize,
        'key': HelperUtil.signParamsKey(
          dateTime.toString(),
          appid: KugouConfig.appid,
        ),
        'special_recommend': {
          'withtag': withtag,
          'withsong': withsong,
          'sort': sort,
          'ugc': 1,
          'is_selected': 0,
          'withrecommend': 1,
          'area_code': 1,
          'categoryid': categoryId,
        },
        'req_multi': 1,
        'retrun_min': 5,
        'return_special_falg': 1,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'specialrec.service.kugou.com'},
    );
  }

  /// 新歌速递 / 新歌推荐 (top_song.js)
  /// [type] 默认 21608 代表新歌推荐排行
  static Future<Map<String, dynamic>> topSong({
    int type = 21608,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/musicadservice/container/v1/newsong_publish',
      method: 'POST',
      data: {
        'rank_id': type,
        'userid': _userid,
        'page': page,
        'pagesize': pagesize,
        'tags': [],
      },
      encryptType: EncryptType.android,
    );
  }

  /// 推荐新专辑 (top_album.js)
  static Future<Map<String, dynamic>> topAlbum({
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/musicadservice/v1/mobile_newalbum_sp',
      method: 'POST',
      data: {
        'apiver': KugouConfig.apiver,
        'token': _token,
        'page': page,
        'pagesize': pagesize,
        'withpriv': 1,
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 专题与 IP 推荐
  // ==========================================

  /// 每日推荐 IP 专题 (top_ip.js)
  static Future<Map<String, dynamic>> topIp() async {
    final response = await ApiClient().createRequest(
      baseURL: 'http://musicadservice.kugou.com',
      url: '/v1/daily_recommend',
      method: 'POST',
      params: {'clientver': KugouConfig.clientver, 'area_code': 1},
      data: {'tags': {}},
      encryptType: EncryptType.android,
    );

    // 核心后处理：从 inner_url 中提取 ip_id
    if (response['status'] == 200) {
      final body = response['body'];
      if (body != null && body['status'] == 1 && body['data'] != null) {
        final List list = body['data']['list'] ?? [];

        for (var item in list) {
          if (item is Map && item['extra'] is Map) {
            final String? innerUrl = item['extra']['inner_url'];
            if (innerUrl != null) {
              final int findIndex = innerUrl.lastIndexOf('ip_id');
              if (findIndex != -1) {
                final String ipIdStr = innerUrl.substring(findIndex + 6);
                item['extra']['ip_id'] = int.tryParse(ipIdStr) ?? 0;
              }
            }
          }
        }
      }
    }

    return response;
  }
}
