import '../core/api_client.dart';
import '../utils/encrypt_util.dart';
import '../utils/config.dart';

class Search {
  // ==========================================
  // 核心搜索功能
  // ==========================================

  /// 通用搜索 (search.js)
  /// [type] 支持: special, lyric, song, album, author, mv
  static Future<Map<String, dynamic>> search(
    String keywords, {
    int page = 1,
    int pagesize = 30,
    String type = 'song',
    Map<String, String>? cookie,
  }) async {
    final validTypes = ['special', 'lyric', 'song', 'album', 'author', 'mv'];
    final safeType = validTypes.contains(type) ? type : 'song';

    return ApiClient().createRequest(
      url: '/${safeType == 'song' ? 'v3' : 'v1'}/search/$safeType',
      method: 'GET',
      params: {
        'albumhide': 0,
        'iscorrection': 1,
        'keyword': keywords,
        'nocollect': 0,
        'page': page,
        'pagesize': pagesize,
        'platform': 'AndroidFilter',
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'complexsearch.kugou.com'},
      cookie: cookie,
    );
  }

  /// 综合搜索 (search_complex.js)
  static Future<Map<String, dynamic>> searchComplex(
    String keywords, {
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      baseURL: 'https://complexsearch.kugou.com',
      url: '/v6/search/complex',
      method: 'GET',
      params: {
        'platform': 'AndroidFilter',
        'keyword': keywords,
        'page': page,
        'pagesize': pagesize,
        'cursor': 0,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 综合搜索高级版 (search_mixed.js)
  /// 这个接口携带了大量特征参数，通常用于返回更丰富的聚合数据
  static Future<Map<String, dynamic>> searchMixed(
    String keyword, {
    Map<String, String>? cookie,
  }) async {
    final int time = DateTime.now().millisecondsSinceEpoch;
    // 原代码中写死了一个神秘字符串生成 requestid
    final String md5Str = EncryptUtil.cryptoMd5(
      'bdaa53d04e7475feb9024164a47032f9$time',
    );

    return ApiClient().createRequest(
      url: '/v3/search/mixed',
      method: 'GET',
      params: {
        'ab_tag': 0,
        'ability': 511,
        'albumhide': 0,
        'apiver': 22,
        'area_code': 1,
        'clientver': 20125,
        'cursor': 0,
        'is_gpay': 0,
        'iscorrection': 1,
        'keyword': keyword,
        'nocollect': 0,
        'osversion': 16.5,
        'platform': 'IOSFilter',
        'recver': 2,
        'req_ai': 1,
        'requestid': '${md5Str}_0',
        'search_ability': 3,
        'sec_aggre': 1,
        'sec_aggre_bitmap': 0,
        'style_type': 3,
        'tag': 'em',
      },
      encryptType: EncryptType.android,
      headers: {
        'x-router': 'complexsearch.kugou.com',
        'kg-clienttimems': time.toString(),
      },
      cookie: cookie,
    );
  }

  // ==========================================
  // 搜索辅助功能
  // ==========================================

  /// 热搜词汇 (search_hot.js)
  static Future<Map<String, dynamic>> searchHot({
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/api/v3/search/hot_tab',
      method: 'GET',
      params: {'navid': 1, 'plat': 2},
      encryptType: EncryptType.android,
      headers: {'x-router': 'msearch.kugou.com'},
      cookie: cookie,
    );
  }

  /// 搜索词联想建议 (search_suggest.js)
  static Future<Map<String, dynamic>> searchSuggest(
    String keywords, {
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/v2/getSearchTip',
      method: 'GET',
      params: {
        'keyword': keywords,
        'AlbumTipCount': 10,
        'CorrectTipCount': 10,
        'MVTipCount': 10,
        'MusicTipCount': 10,
        'radiotip': 1,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'searchtip.kugou.com'},
      cookie: cookie,
    );
  }

  /// 默认无焦点搜索词 (search_default.js)
  /// 也就是搜索框里默认占位的那行灰字（大家都在搜：xxx）
  static Future<Map<String, dynamic>> searchDefault({
    Map<String, String>? cookie,
  }) async {
    final int userid = int.tryParse(cookie?['userid'] ?? '0') ?? 0;
    final int vipType = int.tryParse(cookie?['vip_type'] ?? '65530') ?? 65530;

    return ApiClient().createRequest(
      url: '/searchnofocus/v1/search_no_focus_word',
      method: 'POST',
      params: {'clientver': 12329}, // 放在 URL 上的 query
      data: {
        // 放在 Body 里的 json
        'plat': 0,
        'userid': userid,
        'tags': '{}',
        'vip_type': vipType,
        'm_type': 0,
        'own_ads': {},
        'ability': '3',
        'sources': [],
        'bitmap': 2,
        'mode': 'normal',
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 歌词精确搜索 (search_lyric.js)
  static Future<Map<String, dynamic>> searchLyric({
    String keywords = '',
    String hash = '',
    int albumAudioId = 0,
    String man = 'no',
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      baseURL: 'https://lyrics.kugou.com',
      url: '/v1/search',
      method: 'GET',
      params: {
        'album_audio_id': albumAudioId,
        'appid': Config.appid,
        'clientver': Config.clientver,
        'duration': 0,
        'hash': hash,
        'keyword': keywords,
        'lrctxt': 1,
        'man': man,
      },
      cookie: cookie,
      // ⚠️ 特殊设定：清空默认参数，并且跳过签名
      clearDefaultParams: true,
      notSignature: true,
    );
  }
}
