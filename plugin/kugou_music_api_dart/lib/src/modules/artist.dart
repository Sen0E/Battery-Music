import '../core/api_client.dart';
import '../utils/config.dart';
import '../utils/helper_util.dart';
import '../utils/encrypt_util.dart';

class KugouArtist {
  // 从底层引擎快速提取用户状态
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';

  // ==========================================
  // 歌手基础信息与列表
  // ==========================================

  /// 获取歌手分类列表 (artist_lists.js)
  static Future<Map<String, dynamic>> artistLists({
    int musician = 0,
    int sextype = 0,
    int type = 0,
    int hotsize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/ocean/v6/singer/list',
      method: 'GET',
      params: {
        'musician': musician,
        'sextype': sextype,
        'showtype': 2,
        'type': type,
        'hotsize': hotsize,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取歌手主页详情 (artist_detail.js)
  static Future<Map<String, dynamic>> artistDetail({
    required dynamic authorId,
  }) async {
    return ApiClient().createRequest(
      url: '/kmr/v3/author',
      method: 'POST',
      data: {'author_id': authorId},
      encryptType: EncryptType.android,
      headers: {'x-router': 'openapi.kugou.com', 'kg-tid': 36},
    );
  }

  /// 获取歌手荣誉详情 (artist_honour.js)
  static Future<Map<String, dynamic>> artistHonour({
    required dynamic singerId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      baseURL: 'http://h5activity.kugou.com',
      url: '/v1/query_singer_honour_detail',
      method: 'POST',
      params: {'singer_id': singerId, 'pagesize': pagesize, 'page': page},
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 歌手作品资源 (单曲、专辑、MV)
  // ==========================================

  /// 获取歌手单曲列表 (artist_audios.js)
  /// [sort] 排序方式: 'hot' 最热, 'new' 最新
  static Future<Map<String, dynamic>> artistAudios({
    required dynamic authorId,
    int page = 1,
    int pagesize = 30,
    String sort = 'hot',
  }) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return ApiClient().createRequest(
      baseURL: 'https://openapi.kugou.com',
      url: '/kmr/v1/audio_group/author',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'mid': _mid,
        'clienttime': clienttime,
        'key': HelperUtil.signParamsKey(clienttime, appid: Config.appid),
        'author_id': authorId,
        'pagesize': pagesize,
        'page': page,
        'sort': sort == 'hot' ? 1 : 2, // 1:最热, 2:最新
        'area_code': 'all',
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'openapi.kugou.com', 'kg-tid': 220},
    );
  }

  /// 获取歌手专辑列表 (artist_albums.js)
  /// [sort] 排序方式: 'hot' 最热, 'new' 最新
  static Future<Map<String, dynamic>> artistAlbums({
    required dynamic authorId,
    int page = 1,
    int pagesize = 30,
    String sort = 'new',
  }) async {
    return ApiClient().createRequest(
      url: '/kmr/v1/author/albums',
      method: 'POST',
      data: {
        'author_id': authorId,
        'pagesize': pagesize,
        'page': page,
        'sort': sort == 'hot' ? 3 : 1, // 3:最热, 1:最新
        'category': 1,
        'area_code': 'all',
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'openapi.kugou.com', 'kg-tid': 36},
    );
  }

  /// 获取歌手 MV 列表 (artist_videos.js)
  /// [tag] 类型标签: 'official' 官方, 'live' 现场, 'fan' 饭制, 'artist' 歌手发布, 'all' 全部
  static Future<Map<String, dynamic>> artistVideos({
    required dynamic authorId,
    int page = 1,
    int pagesize = 30,
    String tag = 'all',
  }) async {
    final Map<String, dynamic> tagIdxMap = {
      'official': 18,
      'live': 20,
      'fan': 23,
      'artist': 42419,
      'all': '',
    };

    return ApiClient().createRequest(
      baseURL: 'https://openapicdn.kugou.com',
      url: '/kmr/v1/author/videos',
      method: 'GET',
      params: {
        'author_id': authorId,
        'is_fanmade': '',
        'tag_idx': tagIdxMap[tag] ?? '',
        'pagesize': pagesize,
        'page': page,
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 用户互动 (关注、取关、动态)
  // ==========================================

  /// 获取已关注歌手的新歌动态 (artist_follow_newsongs.js)
  static Future<Map<String, dynamic>> artistFollowNewSongs({
    int lastAlbumId = 0,
    int pagesize = 30,
    int optSort = 1,
  }) async {
    return ApiClient().createRequest(
      url: '/feed/v1/follow/newsong_album_list',
      method: 'POST',
      data: {'last_album_id': lastAlbumId},
      params: {
        'last_album_id': lastAlbumId,
        'page_size': pagesize,
        'opt_sort': optSort == 2 ? 2 : 1,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 关注歌手 (artist_follow.js)
  /// 使用强风控 AES + RSA 混合加密
  static Future<Map<String, dynamic>> artistFollow({
    required dynamic singerId,
  }) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 1. 将 singerid 和 token 打包进行 AES 加密
    final Map<String, String> encrypt = EncryptUtil.cryptoAesEncrypt({
      'singerid': int.tryParse(singerId.toString()) ?? 0,
      'token': _token,
    });

    return ApiClient().createRequest(
      url: '/followservice/v3/follow_singer',
      method: 'POST',
      data: {
        'plat': 0,
        'userid': _userid,
        'singerid': int.tryParse(singerId.toString()) ?? 0,
        'source': 7,
        // 2. 将 AES 的随机 key 和 clienttime 用 RSA 再次加密
        'p': EncryptUtil.rsaEncrypt2({
          'clienttime': clienttime,
          'key': encrypt['key'],
        }),
        'params': encrypt['str'],
      },
      params: {'clienttime': clienttime},
      encryptType: EncryptType.android,
    );
  }

  /// 取消关注歌手 (artist_unfollow.js)
  static Future<Map<String, dynamic>> artistUnfollow({
    required dynamic singerId,
  }) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 逻辑与关注完全一致
    final Map<String, String> encrypt = EncryptUtil.cryptoAesEncrypt({
      'singerid': int.tryParse(singerId.toString()) ?? 0,
      'token': _token,
    });

    return ApiClient().createRequest(
      url: '/followservice/v3/unfollow_singer',
      method: 'POST',
      data: {
        'plat': 0,
        'userid': _userid,
        'singerid': singerId,
        'source': 7,
        'p': EncryptUtil.rsaEncrypt2({
          'clienttime': clienttime,
          'key': encrypt['key'],
        }),
        'params': encrypt['str'],
      },
      encryptType: EncryptType.android,
    );
  }
}
