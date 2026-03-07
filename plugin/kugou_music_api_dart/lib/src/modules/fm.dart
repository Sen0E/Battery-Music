import '../core/api_client.dart';
import '../utils/helper_util.dart';
import '../utils/config.dart';

class Fm {
  // 从底层引擎快速提取用户状态
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _vipType =>
      int.tryParse(ApiClient().currentCookies['vip_type'] ?? '0') ?? 0;
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';

  // ==========================================
  // 核心功能：私人 FM 电台
  // ==========================================

  /// 获取私人 FM 推荐歌曲，同时上报播放行为 (personal_fm.js)
  ///
  /// [action] 行为参数，例如 'play' (播放), 'skip' (跳过/切歌)
  /// [songPoolId] 歌曲池 ID，默认 0
  /// [remainSongcnt] 播放列表剩余歌曲数
  /// [isOverplay] 是否播完了一整首歌
  /// [mode] 模式，默认为 'normal'
  /// [hash] 针对当前操作的歌曲 hash
  /// [songid] 针对当前操作的歌曲 ID
  /// [playtime] 针对当前操作歌曲的播放时长 (毫秒)
  static Future<Map<String, dynamic>> personalFm({
    String action = 'play',
    int songPoolId = 0,
    String platform = 'ios',
    int remainSongcnt = 0,
    bool isOverplay = false,
    String mode = 'normal',
    String? hash,
    dynamic songid,
    dynamic playtime,
  }) async {
    final int dateTime = DateTime.now().millisecondsSinceEpoch;

    // 拼装基础特征探针
    final Map<String, dynamic> dataMap = {
      'appid': Config.appid,
      'clienttime': dateTime,
      'mid': _mid,
      'action': action,
      'recommend_source_locked': 0,
      'song_pool_id': songPoolId,
      'callerid': 0,
      'm_type': 1,
      'platform': platform,
      'area_code': 1,
      'remain_songcnt': remainSongcnt,
      'clientver': Config.clientver,
      'is_overplay': isOverplay ? 1 : 0,
      'mode': mode,
      'fakem': 'ca981cfc583a4c37f28d2d49000013c16a0a',
      'key': HelperUtil.signParamsKey(dateTime, appid: Config.appid),
    };

    // 注入身份鉴权信息
    if (_userid != 0) {
      dataMap['userid'] = _userid;
      dataMap['kguid'] = _userid; // 酷狗 FM 接口的特殊别名映射
    }
    if (_token.isNotEmpty) {
      dataMap['token'] = _token;
    }
    if (_vipType != 0) {
      dataMap['vip_type'] = _vipType;
    }

    // 注入当前歌曲的操作上下文（用于算法纠偏）
    if (hash != null) dataMap['hash'] = hash;
    if (songid != null) dataMap['songid'] = songid;
    if (playtime != null) dataMap['playtime'] = playtime;

    return ApiClient().createRequest(
      url: '/v2/personal_recommend',
      method: 'POST',
      data: dataMap,
      encryptType: EncryptType.android,
      headers: {'x-router': 'persnfm.service.kugou.com'},
    );
  }
}
