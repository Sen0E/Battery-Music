import '../core/api_client.dart';

class Rank {
  // ==========================================
  // 排行榜总览与分类
  // ==========================================

  /// 获取排行榜推荐列表 (rank_top.js)
  /// 通常用于展示在排行榜首页最顶部的几张大卡片
  static Future<Map<String, dynamic>> rankTop() async {
    return ApiClient().createRequest(
      url: '/mobileservice/api/v5/rank/rec_rank_list',
      method: 'GET',
      encryptType: EncryptType.android,
    );
  }

  /// 获取完整的排行榜分类列表 (rank_list.js)
  /// [withsong] 是否在返回的榜单信息中顺带附上排名前 3 的歌曲名（用于 UI 预览）
  static Future<Map<String, dynamic>> rankList({int withsong = 1}) async {
    return ApiClient().createRequest(
      url: '/ocean/v6/rank/list',
      method: 'GET',
      params: {'plat': 2, 'withsong': withsong, 'parentid': 0},
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 单个排行榜数据
  // ==========================================

  /// 获取具体某个排行榜的详情/介绍 (rank_info.js)
  /// [rankid] 排行榜的唯一 ID (从 rankList 接口中获取)
  static Future<Map<String, dynamic>> rankInfo({
    required dynamic rankid,
    dynamic rankCid = 0,
    int albumImg = 1,
    String zone = '',
  }) async {
    return ApiClient().createRequest(
      url: '/ocean/v6/rank/info',
      method: 'GET',
      params: {
        'rank_cid': rankCid,
        'rankid': rankid,
        'with_album_img': albumImg,
        'zone': zone,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取排行榜内的音乐列表 (rank_audio.js)
  /// [rankid] 排行榜的唯一 ID
  static Future<Map<String, dynamic>> rankAudio({
    required dynamic rankid,
    dynamic rankCid = 0,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/openapi/kmr/v2/rank/audio',
      method: 'POST',
      data: {
        'show_portrait_mv': 1,
        'show_type_total': 1,
        'filter_original_remarks': 1,
        'area_code': 1,
        'pagesize': pagesize,
        'rank_cid': rankCid,
        'type': 1,
        'page': page,
        'rank_id': rankid,
      },
      encryptType: EncryptType.android,
      headers: {'kg-tid': '369'}, // 必须携带的原 JS 指定 Header
    );
  }

  /// 获取排行榜往期列表 (rank_vol.js)
  /// 用于查询如“酷狗飙升榜 - 往期回顾”
  static Future<Map<String, dynamic>> rankVol({
    required dynamic rankid,
    dynamic rankCid = 0,
  }) async {
    return ApiClient().createRequest(
      url: '/ocean/v6/rank/vol',
      method: 'GET',
      params: {
        'rank_cid': rankCid,
        'rankid': rankid,
        'ranktype': 1,
        'type': 0,
        'plat': 2,
      },
      encryptType: EncryptType.android,
    );
  }
}
