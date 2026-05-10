import '../core/api_client.dart';
import '../utils/config.dart';

class Sheet {
  /// 乐谱列表 (sheet_list.js)
  static Future<Map<String, dynamic>> sheetList({
    required dynamic albumAudioId,
    int opernType = 0,
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/miniyueku/v1/opern/list',
      method: 'GET',
      params: {
        'album_audio_id': albumAudioId,
        'opern_type': opernType,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 乐谱详情 (sheet_detail.js)
  static Future<Map<String, dynamic>> sheetDetail({
    required dynamic id,
    required dynamic source,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      baseURL: 'https://miniyueku.kugou.com',
      url: '/v1/opern/detail',
      method: 'GET',
      params: {'id': id, 'source': source},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 推荐乐谱 (sheet_hot.js)
  static Future<Map<String, dynamic>> sheetHot({
    int opernType = 1,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/miniyueku/v1/opern_square/get_home_hot_opern',
      method: 'GET',
      params: {'srcappid': Config.srcappid, 'opern_type': opernType},
      encryptType: EncryptType.web,
      cookie: cookie,
    );
  }

  /// 乐谱合集 (sheet_collection.js)
  static Future<Map<String, dynamic>> sheetCollection({
    int position = 2,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/miniyueku/v1/opern_square/get_home_module_config',
      method: 'GET',
      params: {'srcappid': Config.srcappid, 'position': position},
      encryptType: EncryptType.web,
      cookie: cookie,
    );
  }

  /// 乐谱合集详情 (sheet_collection_detail.js)
  static Future<Map<String, dynamic>> sheetCollectionDetail({
    required dynamic collectionId,
    int page = 1,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/miniyueku/v1/opern_square/collection_detail',
      method: 'GET',
      params: {
        'srcappid': Config.srcappid,
        'page': page,
        'collection_id': collectionId,
      },
      encryptType: EncryptType.web,
      cookie: cookie,
    );
  }
}
