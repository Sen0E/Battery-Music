import 'dart:convert';

import '../core/api_client.dart';
import '../utils/config.dart';
import '../utils/helper_util.dart';

class Images {
  /// 获取歌手和专辑图片 (images.js)
  static Future<Map<String, dynamic>> images({
    String hash = '',
    String albumId = '',
    String albumAudioId = '',
    int count = 5,
    Map<String, String>? cookie,
  }) async {
    final List<Map<String, dynamic>> data = hash
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'album_id': 0, 'hash': s.trim(), 'album_audio_id': 0})
        .toList();

    final List<String> albumIds = albumId.split(',');
    for (
      var index = 0;
      index < albumIds.length && index < data.length;
      index++
    ) {
      data[index]['album_id'] = albumIds[index].trim().isEmpty
          ? 0
          : albumIds[index].trim();
    }

    final List<String> audioIds = albumAudioId.split(',');
    for (
      var index = 0;
      index < audioIds.length && index < data.length;
      index++
    ) {
      data[index]['album_audio_id'] = audioIds[index].trim().isEmpty
          ? 0
          : audioIds[index].trim();
    }

    final Map<String, dynamic> paramsMap = {
      'album_image_type': '-3',
      'appid': Config.appid,
      'clientver': Config.clientver,
      'author_image_type': '3,4,5',
      'count': count,
      'data': data,
      'isCdn': 1,
      'publish_time': 1,
    };

    final List<String> query = paramsMap.keys.toList()..sort();
    final String queryString = query
        .map((key) {
          final value = paramsMap[key];
          final String encodedValue = Uri.encodeComponent(
            value is Map || value is List
                ? jsonEncode(value)
                : value.toString(),
          );
          return '$key=$encodedValue';
        })
        .join('&');

    final String signature = HelperUtil.signatureAndroidParams(paramsMap);

    return ApiClient().createRequest(
      baseURL: 'https://expendablekmr.kugou.com',
      url: '/container/v2/image?$queryString',
      method: 'GET',
      params: {'signature': signature},
      encryptType: EncryptType.android,
      cookie: cookie,
      clearDefaultParams: true,
      notSignature: true,
    );
  }

  /// 获取音乐相关图片 (images_audio.js)
  static Future<Map<String, dynamic>> imagesAudio({
    String hash = '',
    String audioId = '',
    String albumAudioId = '',
    String filename = '',
    int count = 5,
    Map<String, String>? cookie,
  }) async {
    final List<Map<String, dynamic>> data = hash
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map(
          (s) => {
            'audio_id': 0,
            'hash': s.trim(),
            'album_audio_id': 0,
            'filename': '',
          },
        )
        .toList();

    final List<String> audioIds = audioId.split(',');
    for (
      var index = 0;
      index < audioIds.length && index < data.length;
      index++
    ) {
      data[index]['audio_id'] = audioIds[index].trim().isEmpty
          ? 0
          : audioIds[index].trim();
    }

    final List<String> albumIds = albumAudioId.split(',');
    for (
      var index = 0;
      index < albumIds.length && index < data.length;
      index++
    ) {
      data[index]['album_audio_id'] = albumIds[index].trim().isEmpty
          ? 0
          : albumIds[index].trim();
    }

    final List<String> filenames = filename.split(',');
    for (
      var index = 0;
      index < filenames.length && index < data.length;
      index++
    ) {
      data[index]['filename'] = filenames[index];
    }

    final Map<String, dynamic> paramsMap = {
      'appid': Config.appid,
      'clientver': Config.clientver,
      'count': count,
      'data': data,
      'isCdn': 1,
      'publish_time': 1,
      'show_authors': 1,
    };

    final List<String> query = paramsMap.keys.toList()..sort();
    final String queryString = query
        .map((key) {
          final value = paramsMap[key];
          final String encodedValue = Uri.encodeComponent(
            value is Map || value is List
                ? jsonEncode(value)
                : value.toString(),
          );
          return '$key=$encodedValue';
        })
        .join('&');

    final String signature = HelperUtil.signatureAndroidParams(paramsMap);

    return ApiClient().createRequest(
      baseURL: 'https://expendablekmr.kugou.com',
      url: '/v2/author_image/audio?$queryString',
      method: 'GET',
      params: {'signature': signature},
      encryptType: EncryptType.android,
      cookie: cookie,
      clearDefaultParams: true,
      notSignature: true,
    );
  }
}
