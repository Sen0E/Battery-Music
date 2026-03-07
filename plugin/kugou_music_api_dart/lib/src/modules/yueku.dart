import '../core/api_client.dart';

class Yueku {
  // 从底层引擎快速提取用户状态
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static int get _vipType =>
      int.tryParse(ApiClient().currentCookies['vip_type'] ?? '0') ?? 0;

  // ==========================================
  // 乐库大盘信息 (Music Library)
  // ==========================================

  /// 获取安卓乐库首页综合推荐内容 (yueku.js)
  /// 包含各种区块的配置，比如最新专辑、推荐歌单等混合大盘数据
  static Future<Map<String, dynamic>> yuekuRecommend() async {
    return ApiClient().createRequest(
      url: '/v1/yueku/recommend_v2',
      method: 'GET',
      params: {
        'operator': 7,
        'plat': 0,
        'type': 11,
        'area_code': 1,
        'req_multi': 1,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'service.mobile.kugou.com'},
    );
  }

  /// 获取乐库顶部的 Banner 滚动横幅 (yueku_banner.js)
  static Future<Map<String, dynamic>> yuekuBanner() async {
    final Map<String, dynamic> dataMap = {
      'plat': 0,
      'channel': 201,
      'operator': 7,
      'networktype': 2,
      'userid': _userid,
      'vip_type': _vipType, // 自动注入 VIP 状态获取高级 Banner
      'm_type': 0,
      'tags': [],
      'apiver': 5,
      'ability': 2,
      'mode': 'normal',
    };

    return ApiClient().createRequest(
      url: '/ads.gateway/v3/listen_banner',
      method: 'POST',
      data: dataMap,
      encryptType: EncryptType.android,
    );
  }

  /// 获取乐库下的情景 FM 推荐 (yueku_fm.js)
  /// 例如“睡前”、“跑步”、“学习”等不同场景的电台
  static Future<Map<String, dynamic>> yuekuFm() async {
    return ApiClient().createRequest(
      url: '/v1/time_fm_info',
      method: 'GET',
      params: {
        'operator': 7,
        'plat': 0,
        'type': 11,
        'area_code': 1,
        'req_multi': 1,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'fm.service.kugou.com'},
    );
  }
}
