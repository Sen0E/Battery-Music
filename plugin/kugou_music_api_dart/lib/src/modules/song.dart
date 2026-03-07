import 'dart:convert';

import '../core/api_client.dart';
import '../utils/encrypt_util.dart';
import '../utils/config.dart';

class Song {
  // 从底层引擎快速提取用户状态
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _vipToken => ApiClient().currentCookies['vip_token'] ?? '';
  static int get _vipType =>
      int.tryParse(ApiClient().currentCookies['vip_type'] ?? '0') ?? 0;
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';

  // ==========================================
  // 获取核心音频播放链接 (全网最硬核部分)
  // ==========================================

  /// 获取音乐播放链接 (高级版 v6 - 支持高品质与 VIP 鉴权)
  /// 对应 song_url_new.js
  static Future<Map<String, dynamic>> songUrlNew({
    required String hash,
    String albumAudioId = '',
    bool freePart = false, // 是否仅试听片段
  }) async {
    final int clienttimeMs = DateTime.now().millisecondsSinceEpoch;

    // 原 JS 中写死的用于拼接 tracker_param.key 的盐值
    const String salt = '185672dd44712f60bb1736df5a377e82';
    // 核心 MD5 防盗链签名
    final String trackerKey = EncryptUtil.cryptoMd5(
      '$hash$salt${Config.appid}$_mid$_userid',
    );

    return ApiClient().createRequest(
      baseURL: 'http://tracker.kugou.com',
      url: '/v6/priv_url',
      method: 'POST',
      data: {
        'area_code': '1',
        'behavior': 'play',
        // 一次性请求所有能给的高级音质
        'qualities': [
          '128',
          '320',
          'flac',
          'high',
          'multitrack',
          'viper_atmos',
          'viper_tape',
          'viper_clear',
        ],
        'resource': {
          'album_audio_id': albumAudioId,
          'collect_list_id': '3',
          'collect_time': clienttimeMs,
          'hash': hash,
          'id': 0,
          'page_id': 1,
          'type': 'audio',
        },
        'token': _token,
        'tracker_param': {
          'all_m': 1,
          'auth': '',
          'is_free_part': freePart ? 1 : 0,
          'key': trackerKey,
          'module_id': 0,
          'need_climax': 1,
          'need_xcdn': 1,
          'open_time': '',
          'pid': '411',
          'pidversion': '3001',
          'priv_vip_type': '6',
          'viptoken': _vipToken,
        },
        'userid': '$_userid',
        'vip': _vipType,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取音乐播放链接 (经典版 v5 - 支持魔法音效)
  /// 对应 song_url.js
  /// [quality] 可选：128, 320, flac 或 魔法音效(piano, acappella, subwoofer, ancient, dj, surnay)
  static Future<Map<String, dynamic>> songUrl({
    required String hash,
    dynamic albumId = 0,
    dynamic albumAudioId = 0,
    String quality = '128',
    bool freePart = false,
  }) async {
    // 魔法音效映射
    final magicQualities = [
      'piano',
      'acappella',
      'subwoofer',
      'ancient',
      'dj',
      'surnay',
    ];
    final String finalQuality = magicQualities.contains(quality)
        ? 'magic_$quality'
        : quality;

    final int pageId = ApiClient().isLite ? 967177915 : 151369488;
    final String ppageId = ApiClient().isLite
        ? '356753938,823673182,967485191'
        : '463467626,350369493,788954147';

    return ApiClient().createRequest(
      url: '/v5/url',
      method: 'GET',
      params: {
        'album_id': int.tryParse(albumId.toString()) ?? 0,
        'area_code': 1,
        'hash': hash.toLowerCase(),
        'ssa_flag': 'is_fromtrack',
        'version': 11436,
        'page_id': pageId,
        'quality': finalQuality,
        'album_audio_id': int.tryParse(albumAudioId.toString()) ?? 0,
        'behavior': 'play',
        'pid': ApiClient().isLite ? 411 : 2,
        'cmd': 26,
        'pidversion': 3001,
        'IsFreePart': freePart ? 1 : 0,
        'ppage_id': ppageId,
        'cdnBackup': 1,
        'kcard': 0,
        'module': '',
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'trackercdn.kugou.com'},
      // ⚠️ 核心参数：启用底层的 Key 签名，但不做整体 URL 的 Signature 签名
      encryptKey: true,
      // notSignature: true,
    );
  }

  // ==========================================
  // 歌曲附加信息 (高潮、榜单成绩)
  // ==========================================

  /// 获取歌曲高潮片段信息 (song_climax.js)
  /// [hashes] 支持逗号分隔的多个 hash
  static Future<Map<String, dynamic>> songClimax(String hashes) async {
    final List<Map<String, String>> data = hashes
        .split(',')
        .map((s) => {'hash': s.trim()})
        .toList();

    return ApiClient().createRequest(
      baseURL: 'https://expendablekmrcdn.kugou.com',
      url: '/v1/audio_climax/audio',
      method: 'GET',
      params: {'data': jsonEncode(data)},
      encryptType: EncryptType.android,
    );
  }

  /// 获取歌曲成绩单 (song_ranking.js)
  static Future<Map<String, dynamic>> songRanking(dynamic albumAudioId) async {
    return ApiClient().createRequest(
      url: '/grow/v1/song_ranking/play_page/ranking_info',
      method: 'GET',
      params: {'album_audio_id': albumAudioId},
      encryptType: EncryptType.android,
    );
  }

  /// 获取歌曲成绩单滤镜版本 (song_ranking_filter.js)
  static Future<Map<String, dynamic>> songRankingFilter({
    required dynamic albumAudioId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/grow/v1/song_ranking/unlock/v2/ranking_filter',
      method: 'GET',
      params: {
        'album_audio_id': albumAudioId,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
    );
  }
}
