import '../core/api_client.dart';

class KugouComment {
  // ==========================================
  // 核心主干：歌曲相关评论
  // ==========================================

  /// 获取歌曲评论列表 (comment_music.js)
  static Future<Map<String, dynamic>> commentMusic({
    required dynamic mixsongid,
    int page = 1,
    int pagesize = 30,
    int showClassify = 1,
    int showHotwordList = 1,
  }) async {
    return ApiClient().createRequest(
      url: '/mcomment/v1/cmtlist',
      method: 'POST',
      params: {
        'mixsongid': mixsongid,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': showClassify,
        'show_hotword_list': showHotwordList,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a', // 歌曲专属标识
      },
      encryptType: EncryptType.android,
    );
  }

  /// 歌曲评论数总计查询 (comment_count.js)
  /// [hash] 歌曲 hash，[specialId] 特殊标识（如歌单ID或专辑ID）
  static Future<Map<String, dynamic>> commentCount({
    String? hash,
    dynamic specialId,
  }) async {
    final Map<String, dynamic> paramsMap = {
      'r': 'comments/getcommentsnum',
      'code': 'fc4be23b4e972707f36b8a828a93ba8a',
    };

    if (hash != null && hash.isNotEmpty) {
      paramsMap['hash'] = hash;
    } else if (specialId != null) {
      paramsMap['childrenid'] = specialId;
    }

    return ApiClient().createRequest(
      url: '/index.php',
      method: 'GET',
      params: paramsMap,
      encryptType: EncryptType.web, // 注意：这个接口用的是 Web 签名算法
      headers: {'x-router': 'sum.comment.service.kugou.com'},
    );
  }

  /// 获取楼中楼（回复）评论 (comment_floor.js)
  /// [tid] 主评论的 ID (Thread ID)
  static Future<Map<String, dynamic>> commentFloor({
    required dynamic specialId, // 通常是主体的 ID
    required dynamic mixsongid,
    required dynamic tid,
    int page = 1,
    int pagesize = 30,
    int showClassify = 1,
    int showHotwordList = 1,
  }) async {
    return ApiClient().createRequest(
      url: '/mcomment/v1/hot_replylist',
      method: 'POST',
      params: {
        'childrenid': specialId,
        'mixsongid': mixsongid,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': showClassify,
        'show_hotword_list': showHotwordList,
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
        'tid': tid,
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 评论内容过滤与筛选
  // ==========================================

  /// 根据分类获取评论 (comment_music_classify.js)
  /// [typeId] 从评论列表中拿到的分类标签ID
  /// [sort] 1: 热度, 2: 最新
  static Future<Map<String, dynamic>> commentMusicClassify({
    required dynamic mixsongid,
    required dynamic typeId,
    int sort = 1,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/mcomment/v1/cmt_classify_list',
      method: 'POST',
      params: {
        'mixsongid': mixsongid,
        'need_show_image': 1,
        'page': page,
        'pagesize': pagesize,
        'type_id': typeId,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
        'sort_method': sort == 2 ? 2 : 1,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 根据热词获取评论 (comment_music_hotword.js)
  /// [hotWord] 从评论列表头部拿到的热词
  static Future<Map<String, dynamic>> commentMusicHotword({
    required dynamic mixsongid,
    required String hotWord,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/mcomment/v1/get_hot_word',
      method: 'POST',
      params: {
        'mixsongid': mixsongid,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'hot_word': hotWord,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 其他资源的评论 (专辑与歌单)
  // ==========================================

  /// 获取专辑评论 (comment_album.js)
  static Future<Map<String, dynamic>> commentAlbum({
    required dynamic id, // 专辑ID
    int page = 1,
    int pagesize = 30,
    int showClassify = 1,
    int showHotwordList = 1,
  }) async {
    return ApiClient().createRequest(
      url: '/m.comment.service/v1/cmtlist',
      method: 'POST',
      params: {
        'childrenid': id,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': showClassify,
        'show_hotword_list': showHotwordList,
        'code': '94f1792ced1df89aa68a7939eaf2efca', // 专辑专属标识
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取歌单评论 (comment_playlist.js)
  static Future<Map<String, dynamic>> commentPlaylist({
    required dynamic id, // 歌单ID
    int page = 1,
    int pagesize = 30,
    int showClassify = 1,
    int showHotwordList = 1,
  }) async {
    return ApiClient().createRequest(
      url: '/m.comment.service/v1/cmtlist',
      method: 'POST',
      params: {
        'childrenid': id,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': showClassify,
        'show_hotword_list': showHotwordList,
        'code': 'ca53b96fe5a1d9c22d71c8f522ef7c4f', // 歌单专属标识
        'content_type': 0,
        'tag': 5,
      },
      encryptType: EncryptType.android,
    );
  }
}
