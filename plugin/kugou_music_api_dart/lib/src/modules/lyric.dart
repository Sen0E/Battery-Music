import 'dart:convert';
import 'package:kugou_music_api_dart/src/utils/crypto_util.dart';

import '../core/api_client.dart';

class Lyric {
  // ==========================================
  // 歌词获取与解析核心
  // ==========================================

  /// 获取并解析歌曲歌词 (lyric.js)
  ///
  /// [id] 歌词的唯一 ID (通常从搜索结果或歌曲详情中获取)
  /// [accesskey] 歌词的访问秘钥 (与 id 配对使用)
  /// [fmt] 歌词格式，可选 'krc' (逐字高亮) 或 'lrc' (标准逐句)
  /// [decode] 是否在底层直接将加密的乱码解密为明文文本 (极其推荐保持 true)
  static Future<Map<String, dynamic>> getLyric({
    required String id,
    required String accesskey,
    String fmt = 'krc',
    String client = 'android',
    bool decode = true,
  }) async {
    final response = await ApiClient().createRequest(
      baseURL: 'https://lyrics.kugou.com',
      url: '/download',
      method: 'GET',
      params: {
        'ver': 1,
        'client': client,
        'id': id,
        'accesskey': accesskey,
        'fmt': fmt,
        'charset': 'utf8',
      },
      encryptType: EncryptType.android,
    );

    // ==========================================
    // 核心后处理：智能解密歌词内容
    // ==========================================
    if (decode && response['status'] == 200) {
      final body = response['body'];
      if (body != null && body['content'] != null) {
        final String rawContent = body['content'];
        // contenttype 为 0 时通常代表是经过 KRC 专有加密的，非 0 通常是普通 Base64
        final int contentType =
            int.tryParse(body['contenttype']?.toString() ?? '0') ?? 0;

        try {
          if (fmt == 'lrc' || contentType != 0) {
            // 1. 标准 Base64 解码 (通常用于 lrc 格式)
            final List<int> decodedBytes = base64Decode(rawContent);
            body['decodeContent'] = utf8.decode(decodedBytes);
          } else {
            // 2. 酷狗专有 KRC 解密 (依赖你的 EncryptUtil 中翻译的 decodeLyrics 方法)
            body['decodeContent'] = CryptoUtil.decodeLyrics(rawContent);
          }
        } catch (e) {
          print('❌ 歌词解码失败: $e');
          body['decodeContent'] = '[00:00.00] 歌词解析失败，请稍后重试\n';
        }
      }
    }

    return response;
  }
}
