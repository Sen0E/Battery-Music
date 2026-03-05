import '../core/api_client.dart';

class Everyday {
  // 提取当前用户的 UserID
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;

  // ==========================================
  // 每日推荐核心功能
  // ==========================================

  /// 每日推荐歌曲 (everyday_recommend.js)
  /// 也就是首页的“每日30首”或“猜你喜欢”
  static Future<Map<String, dynamic>> everydayRecommend({
    String platform = 'ios',
  }) async {
    return ApiClient().createRequest(
      url: '/everyday_song_recommend',
      method: 'POST',
      params: {'platform': platform},
      encryptType: EncryptType.android,
      headers: {'x-router': 'everydayrec.service.kugou.com'},
    );
  }

  /// 获取每日推荐历史记录 (everyday_history.js)
  /// [mode] 'list' 或 'song'
  static Future<Map<String, dynamic>> everydayHistory({
    String mode = 'list',
    String platform = 'ios',
    String? historyName,
    String? date,
  }) async {
    final Map<String, dynamic> paramsMap = {'mode': mode, 'platform': platform};
    if (historyName != null) paramsMap['history_name'] = historyName;
    if (date != null) paramsMap['date'] = date;

    return ApiClient().createRequest(
      url: '/everyday/api/v1/get_history',
      method: 'POST',
      params: paramsMap,
      encryptType: EncryptType.android,
      headers: {'x-router': 'everydayrec.service.kugou.com'},
    );
  }

  /// 每日风格推荐 (everyday_style_recommend.js)
  static Future<Map<String, dynamic>> everydayStyleRecommend({
    String tagids = '',
    String platform = 'ios',
  }) async {
    return ApiClient().createRequest(
      url: '/everydayrec.service/everyday_style_recommend',
      method: 'POST',
      data: {}, // 遵循原 JS 的设定
      params: {
        'tagids': tagids,
        'platform': platform, // 修复了原 JS 丢失 platform 的 Bug
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 社交与互动推荐
  // ==========================================

  /// 歌友推荐 / 基于听歌列表推荐好友 (everyday_friend.js)
  /// [mixsongIds] 传入一组混音歌曲 ID，服务器据此推荐品味相似的好友
  static Future<Map<String, dynamic>> everydayFriend({
    int? userId,
    List<int>? mixsongIds,
  }) async {
    // 优先使用传入的 userId，其次使用当前登录的 userId，最后兜底使用原 JS 的测试 ID
    final int finalUserId = userId ?? (_userid != 0 ? _userid : 853927886);

    // 如果没有传入歌曲列表，则使用原 JS 提取的超长流行歌曲测试列表
    final List<int> finalSongIds =
        mixsongIds ??
        [
          290083753,
          251724346,
          571554587,
          250126644,
          208831644,
          40328518,
          250504076,
          581706850,
          318347675,
          585258401,
          288481998,
          407414475,
          28239430,
          280584633,
          291957521,
          64556644,
          243149863,
          488725103,
          32114153,
          39951172,
          29019580,
          40397606,
          327507651,
          32029382,
          32218359,
          340353127,
          276448762,
          177071956,
          100031397,
          249251602,
        ];

    return ApiClient().createRequest(
      baseURL: 'https://acsing.service.kugou.com',
      url: '/sing7/relation/json/v3/friend_rec_by_using_song_list',
      method: 'POST',
      data: {
        'list': [
          {'user_id': finalUserId, 'mixsong_ids': finalSongIds},
        ],
      },
      params: {'channel': 130, 'isteen': 0, 'platform': 2, 'usemkv': 1},
      encryptType: EncryptType.android,
      // ⚠️ 这里有一个特殊的 pid 头部鉴权，保留原 JS 的逻辑
      headers: {'pid': 126556797},
    );
  }
}
