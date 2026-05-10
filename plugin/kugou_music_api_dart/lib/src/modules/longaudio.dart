import '../core/api_client.dart';

class LongAudio {
  /// 听书 - 每日推荐 (longaudio_daily_recommend.js)
  static Future<Map<String, dynamic>> longAudioDailyRecommend({
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/longaudio/v1/home_new/daily_recommend',
      method: 'POST',
      params: {'module_id': 1, 'size': pagesize, 'page': page},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 听书 - 排行榜推荐 (longaudio_rank_recommend.js)
  static Future<Map<String, dynamic>> longAudioRankRecommend({
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/longaudio/v1/home_new/rank_card_recommend',
      method: 'GET',
      params: {'platform': 'ios'},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 听书 - VIP 推荐 (longaudio_vip_recommend.js)
  static Future<Map<String, dynamic>> longAudioVipRecommend({
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/longaudio/v1/home_new/vip_select_recommend',
      method: 'POST',
      data: {'album_playlist': []},
      params: {'position': '2', 'clientver': 12329},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 听书 - 每周推荐 (longaudio_week_recommend.js)
  static Future<Map<String, dynamic>> longAudioWeekRecommend({
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/longaudio/v1/home_new/week_new_albums_recommend',
      method: 'POST',
      data: {'album_playlist': []},
      params: {'clientver': 12329},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 听书 - 专辑详情 (longaudio_album_detail.js)
  static Future<Map<String, dynamic>> longAudioAlbumDetail(
    String albumIds, {
    Map<String, String>? cookie,
  }) async {
    final List<Map<String, dynamic>> data = albumIds
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'album_id': s.trim()})
        .toList();

    return ApiClient().createRequest(
      url: '/openapi/v2/broadcast',
      method: 'POST',
      data: {
        'data': data,
        'show_album_tag': 1,
        'fields':
            'album_name,album_id,category,authors,sizable_cover,intro,author_name,trans_param,album_tag,mix_intro,full_intro,is_publish',
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'KG-TID': '78'},
    );
  }

  /// 听书 - 专辑音乐列表 (longaudio_album_audios.js)
  static Future<Map<String, dynamic>> longAudioAlbumAudios(
    String albumIds, {
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/longaudio/v2/album_audios',
      method: 'POST',
      data: {
        'album_id': albumIds,
        'area_code': 1,
        'tagid': 0,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
      headers: {'x-router': 'openapi.kugou.com', 'KG-TID': '78'},
    );
  }
}
