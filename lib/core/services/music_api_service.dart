import 'package:battery_music/models/response/base_api.dart';
import 'package:battery_music/models/response/daily_recommend.dart';
import 'package:battery_music/models/response/login_qr_check.dart';
import 'package:battery_music/models/response/login_qr_key.dart';
import 'package:battery_music/models/response/playlist_track.dart';
import 'package:battery_music/models/response/register_dev.dart';
import 'package:battery_music/models/response/search_hot.dart';
import 'package:battery_music/models/response/search_keywords.dart';
import 'package:battery_music/models/response/search_suggest.dart';
import 'package:battery_music/models/response/song_data.dart';
import 'package:battery_music/models/response/top_card.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:battery_music/models/response/user_info_detail.dart';
import 'package:battery_music/models/response/user_playlist.dart';
import 'package:flutter/material.dart';
import 'package:kugou_music_api_dart/kugou_music_api_dart.dart';

class MusicApiService {
  static final MusicApiService _musicApiService = MusicApiService._internal();
  factory MusicApiService() => _musicApiService;
  MusicApiService._internal();

  /// 手机号登录
  /// [cellPhone] 手机号
  /// [code] 验证码
  Future<BaseApi<UserInfo>> loginForCellPhone(
    String cellPhone,
    String code,
  ) async {
    final res = await Login.loginByVerifyCode(cellPhone, code);
    debugPrint("loginForCellPhone response: ${res['body']}");
    return BaseApi<UserInfo>.fromMap(
      res['body'],
      (map) => UserInfo.fromMap(map),
    );
  }

  /// 发送验证码
  /// [cellPhone] 手机号
  Future<BaseApi> captchaSent(String cellPhone) async {
    final res = await Login.sendMobileCode(cellPhone);
    debugPrint("captchaSent response: ${res['body']}");
    return BaseApi.fromMap(res['body'], (map) => null);
  }

  /// 获取酷狗登录二维码和Key
  Future<BaseApi<LoginQrKey>> loginQrKey() async {
    final res = await Login.loginQrKey();
    debugPrint("loginQrKey response: ${res['body']}");
    return BaseApi<LoginQrKey>.fromMap(
      res['body'],
      (map) => LoginQrKey.fromMap(map),
    );
  }

  /// 获取酷狗登录二维码扫码状态
  /// [key] 二维码 Key
  Future<BaseApi<LoginQrCheck>> loginQrCheck(String key) async {
    final res = await Login.loginQrCheck(key);
    debugPrint("loginQrCode response: ${res['body']}");
    return BaseApi<LoginQrCheck>.fromMap(
      res['body'],
      (map) => LoginQrCheck.fromMap(map),
    );
  }

  /// 刷新登录
  /// [token] 用户 Token
  /// [userid] 用户 ID
  Future<BaseApi<UserInfo>> loginToken({String? token, String? userid}) async {
    final res = await Login.loginToken(token: token, userid: userid);
    debugPrint("refreshLogin response: ${res['body']}");
    return BaseApi<UserInfo>.fromMap(
      res['body'],
      (map) => UserInfo.fromMap(map),
    );
  }

  /// dfid获取
  Future<BaseApi<RegisterDev>> registerDev() async {
    final res = await Device.registerDev();
    debugPrint("registerDev response: ${res['body']}");
    return BaseApi<RegisterDev>.fromMap(
      res['body'],
      (map) => RegisterDev.fromMap(map),
    );
  }

  /// 获取用户详细信息
  Future<BaseApi<UserInfoDetail>> userDetail() async {
    final res = await User.userDetail();
    debugPrint("userDetail response: ${res['body']}");
    return BaseApi<UserInfoDetail>.fromMap(
      res['body'],
      (map) => UserInfoDetail.fromMap(map),
    );
  }

  /// 获取用户歌单
  Future<BaseApi<UserPlaylist>> userPlaylist({int? page, int? pageSize}) async {
    final res = await User.userPlaylist(page: page, pagesize: pageSize);
    debugPrint("userPlaylist response: ${res['body']}");
    return BaseApi<UserPlaylist>.fromMap(
      res['body'],
      (map) => UserPlaylist.fromMap(map),
    );
  }

  /// 获取歌单内音乐(所有的歌单)
  /// [id] 歌单 全局id
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<BaseApi<PlaylistTrack>> playlistTrack(
    String id, {
    int? page = 1,
    int? pageSize = 30,
  }) async {
    final res = await Playlist.playlistTrackAll(
      id: id,
      page: page,
      pagesize: pageSize,
    );
    debugPrint("playlistTrack response: ${res['body']}");
    return BaseApi<PlaylistTrack>.fromMap(
      res['body'],
      (map) => PlaylistTrack.fromMap(map),
    );
  }

  /// 获取热搜列表(实际并非热搜，太扯了这个API)
  Future<BaseApi<SearchHot>> searchHot() async {
    final res = await Search.searchHot();
    debugPrint("searchHot response: ${res['body']}");
    return BaseApi<SearchHot>.fromMap(
      res['body'],
      (map) => SearchHot.fromMap(map),
    );
  }

  /// 每日推荐
  Future<BaseApi<DailyRecommend>> everydayRecommend() async {
    final res = await Everyday.everydayRecommend();
    debugPrint("everydayRecommend response: ${res['body']}");
    return BaseApi<DailyRecommend>.fromMap(
      res['body'],
      (map) => DailyRecommend.fromMap(map),
    );
  }

  /// 歌曲推荐
  /// [cardId] 1：对应安卓 精选好歌随心听 || 私人专属好歌，2：对应安卓 经典怀旧金曲，
  /// 3：对应安卓 热门好歌精选，4：对应安卓 小众宝藏佳作，5：未知，6：对应 vip 专属推荐
  Future<BaseApi<TopCard>> topCard(int cardId) async {
    final res = await Top.topCard(cardId: cardId);
    debugPrint("topCard response: ${res['body']}");
    return BaseApi<TopCard>.fromMap(res['body'], (map) => TopCard.fromMap(map));
  }

  ///获取音乐URL
  ///[hash] 歌曲hash
  ///[freePart] 是否返回试听部分（仅部分歌曲）(0：否, 1：是)
  ///[quality] 音质(128,320,flac,high)
  Future<SongData> songUrl(
    String hash, {
    bool? freePart = false,
    String? quality = '128',
  }) async {
    final res = await Song.songUrl(
      hash: hash,
      freePart: freePart!,
      quality: quality!,
    );
    debugPrint("songUrl response: ${res['body']}");
    return SongData.fromMap(res['body']);
  }

  ///获取音乐URL（新版）
  ///[hash] 歌曲hash
  ///[albumAudioId] 专辑音频id
  ///[freePart] 是否返回试听部分（仅部分歌曲）(0：否, 1：是)
  Future<Map<String, dynamic>> songUrlNew(
    String hash, {
    String? albumAudioId,
    bool? freePart = false,
  }) async {
    final res = await Song.songUrlNew(
      hash: hash,
      albumAudioId: albumAudioId ?? '',
      freePart: freePart!,
    );
    debugPrint("songUrlNew response: ${res['body']}");
    return res['body'];
  }

  /// 搜索
  /// [keywords] 关键字
  /// [type] 搜索类型(默认为单曲，special：歌单，lyric：歌词，song：单曲，album：专辑，author：歌手，mv：mv)
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<BaseApi<SearchKeywords<T>>> searchKeywords<T>(
    String keywords, {
    String? type = 'song',
    int? page = 1,
    int? pageSize = 30,
  }) async {
    final res = await Search.search(
      keywords,
      page: page!,
      pagesize: pageSize!,
      type: type!,
    );
    debugPrint("searchKeywords response: ${res['body']}");
    return BaseApi<SearchKeywords<T>>.fromMap(
      res['body'],
      (map) => SearchKeywords<T>.fromMap(map),
    );
  }

  /// 搜索建议
  /// [keywords] 关键词
  /// [albumTipCount] 专辑提示数量
  /// [correctTipCount] 不知道
  /// [mvTipCount] MV提示数量
  /// [musicTipCount] 音乐提示数量
  Future<SearchSuggest> searchSuggest(
    String keywords, {
    int? albumTipCount,
    int? correctTipCount,
    int? mvTipCount,
    int? musicTipCount,
  }) async {
    final res = await Search.searchSuggest(keywords);
    debugPrint("searchSuggest response: ${res['body']}");
    return SearchSuggest.fromMap(res['body']);
  }
}
