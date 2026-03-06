import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../utils/encrypt_util.dart';
import '../utils/helper_util.dart';
import '../utils/config.dart';

class User {
  /// 获取当前内存中的 token
  static String get _token => ApiClient().currentCookies['token'] ?? '';

  /// 获取当前内存中的 userid
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;

  /// 获取当前内存中的 mid
  static String get _mid => ApiClient().currentCookies['KUGOU_API_MID'] ?? '';

  // ==========================================
  // 用户基础信息
  // ==========================================

  /// 获取用户详情 (user_detail.js)
  static Future<Map<String, dynamic>> userDetail() async {
    final int clienttimeMs = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // RSA 加密 token 和时间戳防重放
    final String pk = EncryptUtil.cryptoRSAEncrypt({
      'token': _token,
      'clienttime': clienttimeMs,
    }).toUpperCase();

    return ApiClient().createRequest(
      url: '/v3/get_my_info',
      method: 'POST',
      params: {'plat': 1},
      data: {
        'visit_time': clienttimeMs,
        'usertype': 1,
        'p': pk,
        'userid': _userid,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'usercenter.kugou.com'},
    );
  }

  /// 获取用户 VIP 详情 (user_vip_detail.js)
  static Future<Map<String, dynamic>> userVipDetail() async {
    return ApiClient().createRequest(
      baseURL: 'https://kugouvip.kugou.com',
      url: '/v1/get_union_vip',
      method: 'GET',
      params: {'busi_type': 'concept'},
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 用户的音乐资产 (歌单、历史、云盘)
  // ==========================================

  /// 获取用户自建/收藏歌单 (user_playlist.js)
  static Future<Map<String, dynamic>> userPlaylist({
    int? page = 1,
    int? pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/v7/get_all_list',
      method: 'POST',
      params: {'plat': 1, 'userid': _userid, 'token': _token},
      data: {
        'userid': _userid,
        'token': _token,
        'total_ver': 979,
        'type': 2,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'cloudlist.service.kugou.com'},
    );
  }

  /// 获取用户听歌历史排行 (user_history.js)
  static Future<Map<String, dynamic>> userHistory({String? bp}) async {
    final Map<String, dynamic> dataMap = {
      'token': _token,
      'userid': _userid,
      'source_classify': 'app',
      'to_subdivide_sr': 1,
    };
    if (bp != null) dataMap['bp'] = bp;

    return ApiClient().createRequest(
      url: '/playhistory/v1/get_songs',
      method: 'POST',
      data: dataMap,
      encryptType: EncryptType.android,
    );
  }

  /// 获取用户最近常听 (user_listen.js)
  static Future<Map<String, dynamic>> userListen({int type = 0}) async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final String p = EncryptUtil.cryptoRSAEncrypt({
      'clienttime': clienttime,
      'token': _token,
    }).toUpperCase();

    return ApiClient().createRequest(
      baseURL: 'https://listenservice.kugou.com',
      url: '/v2/get_list',
      method: 'POST',
      params: {'clienttime': clienttime, 'plat': 0},
      data: {
        't_userid': _userid,
        'userid': _userid,
        'list_type': type,
        'area_code': 1,
        'cover': 2,
        'p': p,
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 用户社交与互动
  // ==========================================

  /// 获取用户关注的歌手 (user_follow.js)
  static Future<Map<String, dynamic>> userFollow() async {
    final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final String p = EncryptUtil.cryptoRSAEncrypt({
      'clienttime': clienttime,
      'token': _token,
    }).toUpperCase();

    return ApiClient().createRequest(
      url: '/v4/follow_list',
      method: 'POST',
      params: {'plat': 1},
      data: {
        'merge': 2,
        'need_iden_type': 1,
        'ext_params': 'k_pic,jumptype,singerid,score',
        'userid': _userid,
        'type': 0,
        'id_type': 0,
        'p': p,
      },
      encryptType: EncryptType.android,
      headers: {'x-router': 'relationuser.kugou.com'},
    );
  }

  /// 获取用户收藏的视频 (user_video_collect.js)
  static Future<Map<String, dynamic>> userVideoCollect({
    int page = 1,
    int pagesize = 30,
  }) async {
    return ApiClient().createRequest(
      url: '/collectservice/v2/collect_list_mixvideo',
      method: 'POST',
      params: {'plat': 1},
      data: {
        'userid': _userid,
        'token': _token,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取用户点赞的视频 (user_video_love.js)
  static Future<Map<String, dynamic>> userVideoLove({int pagesize = 30}) async {
    return ApiClient().createRequest(
      url: '/m.comment.service/v1/get_user_like_video',
      method: 'GET',
      params: {
        'kugouid': _userid,
        'pagesize': pagesize,
        'load_video_info': 1,
        'p': 1,
        'plat': 1,
      },
      encryptType: EncryptType.android,
    );
  }

  // ==========================================
  // 音乐云盘专属 API
  // ==========================================

  /// 获取云盘音乐播放 URL (user_cloud_url.js)
  static Future<Map<String, dynamic>> userCloudUrl(
    String hash, {
    int albumAudioId = 0,
    int audioId = 0,
    String name = '',
  }) async {
    final String lowerHash = hash.toLowerCase();

    return ApiClient().createRequest(
      url: '/bsstrackercdngz/v2/query_musicclound_url',
      method: 'GET',
      params: {
        'hash': lowerHash,
        'ssa_flag': 'is_fromtrack',
        'version': '20102',
        'ssl': 0,
        'album_audio_id': albumAudioId,
        'pid': 20026,
        'audio_id': audioId,
        'kv_id': 2,
        'key': HelperUtil.signCloudKey(lowerHash, '20026'),
        'bucket': 'musicclound',
        'name': name,
        'with_res_tag': 0,
      },
      encryptType: EncryptType.android,
    );
  }

  /// 获取云盘歌曲列表 (user_cloud.js)
  /// ⚠️ 这个接口极其特殊，出入参都是二进制加密流，因此单独使用 Dio 发起请求
  static Future<Map<String, dynamic>> userCloud({
    int page = 1,
    int pagesize = 30,
  }) async {
    try {
      final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // AES 加密业务参数
      final Map<String, dynamic> dataMap = {
        'page': page,
        'pagesize': pagesize,
        'getkmr': 1,
      };
      final Map<String, String> aesEncrypt = EncryptUtil.playlistAesEncrypt(
        dataMap,
      );

      // RSA 加密 AES 的 Key、UID 和 Token
      final String p = EncryptUtil.rsaEncrypt2({
        'aes': aesEncrypt['key'],
        'uid': _userid,
        'token': _token,
      }).toUpperCase();

      // 组装请求参数 (带签名)
      final Map<String, dynamic> paramsMap = {
        'clienttime': clienttime,
        'mid': _mid,
        'key': HelperUtil.signParamsKey(
          clienttime.toString(),
          appid: KugouConfig.appid,
        ),
        'clientver': KugouConfig.clientver,
        'appid': KugouConfig.appid,
        'p': p,
      };

      // 发起纯二进制请求
      final Dio dio = Dio();
      final String cookieStr = ApiClient().currentCookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');

      final response = await dio.post(
        'https://mcloudservice.kugou.com/v1/get_list',
        queryParameters: paramsMap,
        // 将 base64 还原为真实的二进制字节流
        data: base64Decode(aesEncrypt['str']!),
        options: Options(
          headers: {
            'Cookie': cookieStr,
            'User-Agent':
                'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
          },
          responseType: ResponseType.bytes, // 核心：声明接收二进制 ArrayBuffer
        ),
      );

      // 对返回的二进制流进行 AES 解密
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
}
