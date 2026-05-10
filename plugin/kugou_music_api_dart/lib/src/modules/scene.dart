import '../core/api_client.dart';
import '../utils/config.dart';

class Scene {
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _token => ApiClient().currentCookies['token'] ?? '';

  /// 场景音乐列表 (scene_lists.js)
  static Future<Map<String, dynamic>> sceneLists({
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/scene/list',
      method: 'GET',
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 场景音乐详情 (scene_module.js)
  static Future<Map<String, dynamic>> sceneModule({
    required dynamic id,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/scene/module',
      method: 'POST',
      params: {'scene_id': id},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取场景音乐讨论区 (scene_lists_v2.js)
  static Future<Map<String, dynamic>> sceneListsV2({
    required dynamic id,
    int page = 1,
    int pagesize = 30,
    String sort = 'rec',
    Map<String, String>? cookie,
  }) async {
    const Map<String, int> sortType = {'rec': 1, 'hot': 2, 'new': 3};

    return ApiClient().createRequest(
      url: '/scene/v1/scene/list_v2',
      method: 'POST',
      params: {
        'scene_id': id,
        'page': page,
        'pagesize': pagesize,
        'sort_type': sortType[sort] ?? 1,
        'kugouid': _userid,
      },
      data: {'exposure': []},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取场景音乐模块 Tag (scene_module_info.js)
  static Future<Map<String, dynamic>> sceneModuleInfo({
    required dynamic id,
    required dynamic moduleId,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/scene/module_info',
      method: 'GET',
      params: {'scene_id': id, 'module_id': moduleId},
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取场景音乐歌单列表 (scene_collection_list.js)
  static Future<Map<String, dynamic>> sceneCollectionList({
    required dynamic tagId,
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/distribution/collection_list',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'token': _token,
        'userid': _userid,
        'tag_id': tagId,
        'page': page,
        'page_size': pagesize,
        'exposed_data': [],
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取场景音乐视频列表 (scene_video_list.js)
  static Future<Map<String, dynamic>> sceneVideoList({
    required dynamic tagId,
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/distribution/video_list',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'token': _token,
        'userid': _userid,
        'tag_id': tagId,
        'page': page,
        'page_size': pagesize,
        'exposed_data': [],
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }

  /// 获取场景音乐音乐列表 (scene_audio_list.js)
  static Future<Map<String, dynamic>> sceneAudioList({
    required dynamic id,
    required dynamic moduleId,
    required dynamic tag,
    int page = 1,
    int pagesize = 30,
    Map<String, String>? cookie,
  }) async {
    return ApiClient().createRequest(
      url: '/scene/v1/scene/audio_list',
      method: 'POST',
      params: {
        'scene_id': id,
        'module_id': moduleId,
        'tag': tag,
        'page': page,
        'page_size': pagesize,
      },
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'token': _token,
        'userid': _userid,
      },
      encryptType: EncryptType.android,
      cookie: cookie,
    );
  }
}
