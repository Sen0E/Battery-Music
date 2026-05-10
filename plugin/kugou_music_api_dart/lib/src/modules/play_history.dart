import '../core/api_client.dart';

class PlayHistory {
  /// 提交听歌历史 (playhistory_upload.js)
  static Future<Map<String, dynamic>> playHistoryUpload({
    required dynamic mxid,
    dynamic ot,
    dynamic pc,
    String? token,
    String? userid,
    Map<String, String>? cookie,
  }) async {
    final int resolvedUserid =
        int.tryParse(
          userid ??
              cookie?['userid'] ??
              ApiClient().currentCookies['userid'] ??
              '0',
        ) ??
        0;
    final String resolvedToken =
        token ?? cookie?['token'] ?? ApiClient().currentCookies['token'] ?? '';
    final int resolvedOt =
        int.tryParse(
          (ot ?? DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        ) ??
        (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final int resolvedPc = int.tryParse((pc ?? 1).toString()) ?? 1;

    return ApiClient().createRequest(
      url: '/playhistory/v1/upload_songs',
      method: 'POST',
      params: {'plat': 3},
      data: {
        'songs': [
          {
            'mxid': int.tryParse(mxid.toString()) ?? 0,
            'op': 1,
            'ot': resolvedOt,
            'pc': resolvedPc,
          },
        ],
        'token': resolvedToken,
        'userid': resolvedUserid,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }
}
