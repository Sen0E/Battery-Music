import 'dart:convert';
import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../utils/encrypt_util.dart';
import '../utils/helper_util.dart';
import '../utils/config.dart';

class Playlist {
  /// 获取当前内存中的 token
  static String get _token => ApiClient().currentCookies['token'] ?? '';

  /// 获取当前内存中的 userid
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;

  // ==========================================
  // 歌单基本操作 (增、删、查)
  // ==========================================

  /// 获取歌单详情 (playlist_detail.js)
  /// [ids] 支持用逗号分隔的 global_collection_id
  static Future<Map<String, dynamic>> playlistDetail(String ids) async {
    final List<Map<String, String>> data = ids
        .split(',')
        .map((s) => {'global_collection_id': s.trim()})
        .toList();

    return ApiClient().createRequest(
      url: '/v3/get_list_info',
      method: 'POST',
      data: {'data': data, 'userid': _userid, 'token': _token},
      encryptType: EncryptType.android,
      headers: {'x-router': 'pubsongs.kugou.com'},
    );
  }

  /// 收藏/创建歌单 (playlist_add.js)
  /// [name] 歌单名称
  /// [type] 0: 创建自建歌单, 1: 收藏别人的歌单
  /// [source] 来源标识
  static Future<Map<String, dynamic>> playlistAdd({
    required String name,
    int type = 0,
    int source = 1,
    int isPri = 0, // 是否私密
    dynamic listCreateUserid,
    dynamic listCreateListid,
    dynamic listCreateGid = '',
  }) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final Map<String, dynamic> dataMap = {
      'userid': _userid,
      'token': _token,
      'total_ver': 0,
      'name': name,
      'type': type,
      'source': source == 0 ? 0 : source,
      'is_pri': 0,
      'list_create_userid': listCreateUserid,
      'list_create_listid': listCreateListid,
      'list_create_gid': listCreateGid,
      'from_shupinmv': 0,
    };

    if (type == 0) {
      dataMap['is_pri'] = isPri;
    }

    final Map<String, dynamic> urlParams = type == 0
        ? {
            'last_time': clienttime,
            'last_area': 'gztx',
            'userid': _userid,
            'token': _token,
          }
        : {};

    return ApiClient().createRequest(
      url: '/cloudlist.service/v5/add_list',
      method: 'POST',
      params: urlParams,
      data: dataMap,
      encryptType: EncryptType.android,
    );
  }

  /// 取消收藏/删除歌单 (playlist_del.js)
  /// 这个接口使用了高级的 AES+RSA 复合加密
  static Future<Map<String, dynamic>> playlistDel(int listid) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // AES 加密业务数据
    final Map<String, dynamic> dataMap = {
      'listid': listid,
      'total_ver': 0,
      'type': 1,
    };
    final Map<String, String> aesEncrypt = EncryptUtil.playlistAesEncrypt(
      dataMap,
    );

    // RSA 加密安全信息
    final String p = EncryptUtil.rsaEncrypt2({
      'aes': aesEncrypt['key'],
      'uid': _userid,
      'token': _token,
    }).toUpperCase();

    // 组装请求参数
    final Map<String, dynamic> paramsMap = {
      'clienttime': clienttime,
      'key': HelperUtil.signParamsKey(
        clienttime.toString(),
        appid: Config.appid,
      ),
      'last_area': 'gztx',
      'clientver': Config.clientver,
      'appid': Config.appid,
      'last_time': clienttime,
      'p': p,
    };

    // ⚠️ 这个接口原 JS 是 responseType: 'arraybuffer'，说明返回的是二进制
    // 为了稳妥，我们可以直接用 Dio 发起请求，或者如果 ApiClient 支持 String 也会尝试解析
    // 这里采用跟 user_cloud 一样直接使用内部 Dio 以防二进制流损坏
    try {
      final dio = Dio();
      final String cookieStr = ApiClient().currentCookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');

      // 把 AES 的 str 当做 raw string 传过去 (非 base64 还原，原 JS 就是 aesEncrypt.str)
      final response = await dio.post(
        'https://gateway.kugou.com/v2/delete_list',
        queryParameters: paramsMap,
        data: aesEncrypt['str'],
        options: Options(
          headers: {
            'Cookie': cookieStr,
            'x-router': 'cloudlist.service.kugou.com',
          },
          responseType: ResponseType.bytes,
        ),
      );

      final List<int> responseBytes = response.data as List<int>;
      final String base64Resp = base64Encode(responseBytes);
      final dynamic decryptedBody = EncryptUtil.playlistAesDecrypt(
        base64Resp,
        aesEncrypt['key']!,
      );

      return {'status': 200, 'body': decryptedBody};
    } catch (e) {
      return {
        'status': 502,
        'body': {'status': 0, 'msg': e.toString()},
      };
    }
  }

  // ==========================================
  // 歌单内的歌曲操作
  // ==========================================

  /// 获取自建歌单的所有歌曲 (playlist_track_all_new.js)
  static Future<Map<String, dynamic>> playlistTrackAllNew({
    required dynamic listid,
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/v4/get_list_all_file',
      method: 'POST',
      data: {
        'listid': listid,
        'userid': _userid,
        'area_code': 1,
        'show_relate_goods': 0,
        'pagesize': pagesize,
        'allplatform': 1,
        'show_cover': 1,
        'type': 0,
        'token': _token,
        'page': page,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'cloudlist.service.kugou.com'},
    );
  }

  /// 获取他人/公开歌单的所有歌曲 (playlist_track_all.js)
  /// [id] global_collection_id
  static Future<Map<String, dynamic>> playlistTrackAll({
    required dynamic id,
    int? page = 1,
    int? pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/pubsongs/v2/get_other_list_file_nofilt',
      method: 'GET',
      params: {
        'area_code': 1,
        'begin_idx': (page! - 1) * pagesize!,
        'plat': 1,
        'type': 1,
        'mode': 1,
        'personal_switch': 1,
        'extend_fields': 'abtags,hot_cmt,popularization',
        'pagesize': pagesize,
        'global_collection_id': id,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 对自建歌单添加歌曲 (playlist_tracks_add.js)
  /// [data] 格式: "name|hash|album_id|mixsongid,name|hash|album_id|mixsongid"
  static Future<Map<String, dynamic>> playlistTracksAdd(
    dynamic listid,
    String data,
  ) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final List<Map<String, dynamic>> resource = data
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) {
          final List<String> items = s.split('|');
          return {
            'number': 1,
            'name': items.isNotEmpty ? items[0] : '',
            'hash': items.length > 1 ? items[1] : '',
            'size': 0,
            'sort': 0,
            'timelen': 0,
            'bitrate': 0,
            'album_id': items.length > 2 ? (int.tryParse(items[2]) ?? 0) : 0,
            'mixsongid': items.length > 3 ? (int.tryParse(items[3]) ?? 0) : 0,
          };
        })
        .toList();

    return ApiClient().createRequest(
      url: '/cloudlist.service/v6/add_song',
      method: 'POST',
      params: {
        'last_time': clienttime,
        'last_area': 'gztx',
        'userid': _userid,
        'token': _token,
      },
      data: {
        'userid': _userid,
        'token': _token,
        'listid': listid,
        'list_ver': 0,
        'type': 0,
        'slow_upload': 1,
        'scene': 'false;null',
        'data': resource,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 对自建歌单删除歌曲 (playlist_tracks_del.js)
  /// [fileids] 用逗号分隔的歌曲 fileid (注意，不是 hash)
  static Future<Map<String, dynamic>> playlistTracksDel(
    dynamic listid,
    String fileids,
  ) async {
    final List<Map<String, dynamic>> resource = fileids
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'fileid': int.tryParse(s.trim()) ?? 0})
        .toList();

    return ApiClient().createRequest(
      url: '/v4/delete_songs',
      method: 'POST',
      data: {
        'listid': listid,
        'userid': _userid,
        'data': resource,
        'type': 0,
        'token': _token,
        'list_ver': 0,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'cloudlist.service.kugou.com'},
    );
  }

  // ==========================================
  // 其他周边功能
  // ==========================================

  /// 获取音效歌单 (playlist_effect.js)
  static Future<Map<String, dynamic>> playlistEffect({
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/pubsongs/v1/get_sound_effect_list',
      method: 'POST',
      data: {'page': page, 'pagesize': pagesize},
      encryptType: EncryptType.android,
    );
  }

  /// 获取相似歌单 (playlist_similar.js)
  static Future<Map<String, dynamic>> playlistSimilar(String ids) async {
    final List<Map<String, String>> data = ids
        .split(',')
        .map((s) => {'global_collection_id': s.trim()})
        .toList();
    final int clienttime = DateTime.now().millisecondsSinceEpoch;

    return ApiClient().createRequest(
      url: '/pubsongs/v1/kmr_get_similar_lists',
      method: 'POST',
      data: {
        'appid': Config.appid,
        'clientver': Config.clientver,
        'clienttime': clienttime,
        'key': HelperUtil.signParamsKey(clienttime, appid: Config.appid),
        'userid': _userid,
        'ugc': 1,
        'show_list': 1,
        'need_songs': 1,
        'data': data,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取歌单分类标签 (playlist_tags.js)
  static Future<Map<String, dynamic>> playlistTags() async {
    return ApiClient().createRequest(
      url: '/pubsongs/v1/get_tags_by_type',
      method: 'POST',
      data: {'tag_type': 'collection', 'tag_id': 0, 'source': 3},
      encryptType: EncryptType.android,
    );
  }
}
