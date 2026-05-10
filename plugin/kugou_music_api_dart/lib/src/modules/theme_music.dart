import '../core/api_client.dart';

class ThemeMusic {
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;

  /// 获取主题音乐 (theme_music.js)
  static Future<Map<String, dynamic>> themeMusic({
    String ids = '',
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/everydayrec.service/v1/mul_theme_category_recommend',
      method: 'POST',
      data: {
        'platform': 'android',
        'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'show_theme_category_ids': ids,
        'userid': _userid,
        'module_id': 508,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取主题音乐详情 (theme_music_detail.js)
  static Future<Map<String, dynamic>> themeMusicDetail({
    required dynamic id,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/everydayrec.service/v1/theme_category_recommend',
      method: 'POST',
      data: {
        'platform': 'android',
        'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'theme_category_id': id,
        'show_theme_category_id': 0,
        'userid': _userid,
        'module_id': 508,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }
}
