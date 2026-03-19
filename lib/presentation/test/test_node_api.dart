import 'dart:developer';
import 'dart:typed_data';

import 'package:battery_music/core/services/music_api_service.dart';
import 'package:battery_music/core/services/user_service.dart';
import 'package:battery_music/models/response/base_api.dart';
import 'package:battery_music/models/response/daily_recommend.dart';
import 'package:battery_music/models/response/login_qr_check.dart';
import 'package:battery_music/models/response/login_qr_key.dart';
import 'package:battery_music/models/response/register_dev.dart';
import 'package:battery_music/models/response/search_hot.dart';
import 'package:battery_music/models/response/search_keywords_song.dart';
import 'package:battery_music/models/response/search_keywords_special.dart';
import 'package:battery_music/models/response/top_card.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:battery_music/models/response/user_info_detail.dart';
import 'package:battery_music/models/response/user_playlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TestNodeApi extends StatefulWidget {
  const TestNodeApi({super.key});

  @override
  State<TestNodeApi> createState() => _TestNodeApiState();
}

class _TestNodeApiState extends State<TestNodeApi> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _nodeApiService = MusicApiService();
  final _musicApiService = MusicApiService();
  final _userService = UserService();
  Uint8List? _qrCode;
  String? _qrCodeKey;
  int? _userId;
  RegisterDev? _registerDev;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Node API 测试')),
      body: Center(child: _buildTopApi()),
    );
  }

  Future<void> _getTopPlaylist() async {
    final userPlayList = await _musicApiService.topPlaylist();
    // 遍历歌单
    for (final item in userPlayList.data!.specialList) {
      log(
        "${item.specialname}\t\t\t  GlableId:${item.globalCollectionId} Pic: ${item.getFlexibleCover()}\t ",
      );
    }
  }

  Future<void> _getTopSong() async {
    final topSong = await _musicApiService.topSong();
    for (final item in topSong.data!) {
      log(
        "${item.songname}\t\t\t  Hash:${item.hash}\t Pic: ${item.getAlbumSizableCover()}\t",
      );
    }
  }

  Widget _buildTopApi() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _getTopPlaylist();
          },
          child: Text("获取歌单推荐"),
        ),
        ElevatedButton(
          onPressed: () {
            _getTopSong();
          },
          child: Text("新歌"),
        ),
      ],
    );
  }

  Future<void> _getUserPlayList() async {
    final userPlayList = await _nodeApiService.userPlaylist(
      page: 1,
      pageSize: 10,
    );
    debugPrint(userPlayList.toString());
    debugPrint(userPlayList.data?.toJson().toString());
    // log(res.data!.info);
    // 遍历歌单
    for (final item in userPlayList.data!.info!) {
      log(
        "${item.name!}\t\t\t ListID: ${item.listid}\t GlableId:${item.globalCollectionId} Pic: ${item.getCoverUrl(size: 200)}\t Count: ${item.count}",
      );
      if (item.authors != null) {
        for (final author in item.authors!) {
          log("Author: ${author.authorName} (for item: ${item.name})");
        }
      } else {
        log(
          "Authors: null (for item: ${item.name})",
        ); // 当 authors 为 null 时，打印提示信息
      }
    }
  }

  Future<void> _getSearchHot() async {
    final BaseApi<SearchHot> response = await _nodeApiService.searchHot();
    // debugPrint(response.data?.toJson().toString()); //太多了，不能输出
    for (final item in response.data!.list!) {
      log("${item.name!}: ${item.keywords!.first.keyword!}"); //输出一个刚刚好
    }
  }

  Future<void> _getEveryDayRecommend() async {
    final response = await _nodeApiService.everydayRecommend();
    // debugPrint(res.data?.toJson().toString());
    for (final item in response.data!.songList!) {
      if (item.recCopyWrite != null) {
        // log(item.toJson());
        log(
          "音乐名称: ${item.songname}"
                  "\t作者: ${item.authorName}" +
              "\tHash: ${item.hash}" +
              "\t封面: ${item.getSizableCoverUrl()}",
        );
      }
    }
  }

  Future<void> _getTopCard(int cardId) async {
    final response = await _nodeApiService.topCard(cardId);
    // log(response.data!.toJson());
    for (final item in response.data!.songList ?? []) {
      // log(item.toJson());
      log(
        "音乐名称: ${item.songname}"
                "\t作者: ${item.authorName}" +
            "\tHash: ${item.hash}" +
            "\t封面: ${item.getSizableCoverUrl()}",
      );
    }
  }

  Future<void> _getMusicUrl(String hash) async {
    try {
      final response = await _nodeApiService.songUrl(hash, quality: 'flac');
      log(response.url!.first);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getPlayListDetail() async {
    final response = await _nodeApiService.playlistTrack(
      "collection_3_1250725353_23_0",
      pageSize: 2,
    );
    debugPrint(response.data!.toJson());
  }

  Future<void> _searchKeyword() async {
    final response = await _nodeApiService.searchKeywords<SearchKeywordsSong>(
      "HOYO-MIX",
      type: 'song',
      pageSize: 2,
    );
    log(response.data!.toJson());
  }

  Future<void> _searchSuggest() async {
    final response = await _nodeApiService.searchSuggest("HOYO-MIX");
    log(response.toJson());
  }

  Future<void> _searchKeywordsforPlayList() async {
    final response = await _nodeApiService
        .searchKeywords<SearchKeywordsSpecial>(
          "睡觉",
          type: 'special',
          pageSize: 2,
        );
    log(response.data!.toJson());
  }

  Future<void> _getMusicUrlNew() async {
    final response = await _nodeApiService.songUrlNew(
      "B142F5845EF337449F6110CE34131A65",
    );
    log(response.toString());
  }

  Widget _buildMusicApi() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _getUserPlayList();
          },
          child: Text("获取歌单"),
        ),
        ElevatedButton(
          onPressed: () {
            _getSearchHot();
          },
          child: Text("获取热搜"),
        ),
        ElevatedButton(
          onPressed: () {
            _getEveryDayRecommend();
          },
          child: Text("获取每日推荐"),
        ),
        ElevatedButton(
          onPressed: () {
            _getTopCard(1);
          },
          child: Text("歌曲推荐"),
        ),
        ElevatedButton(
          onPressed: () {
            _getMusicUrl("953539B9367C8C500CC8E41F0C03BA13");
          },
          child: Text("获取音乐URL"),
        ),
        ElevatedButton(
          onPressed: () {
            _getPlayListDetail();
          },
          child: Text("获取歌单详情"),
        ),
        ElevatedButton(
          onPressed: () {
            _searchKeyword();
          },
          child: Text("搜索关键词(音乐)"),
        ),
        ElevatedButton(
          onPressed: () {
            _searchKeywordsforPlayList();
          },
          child: Text("搜索关键词(歌单)"),
        ),
        ElevatedButton(
          onPressed: () {
            _searchSuggest();
          },
          child: Text("搜索建议"),
        ),
        ElevatedButton(
          onPressed: () {
            _getMusicUrlNew();
          },
          child: Text("获取音乐URL(新)"),
        ),
      ],
    );
  }

  Future<void> _login() async {
    final BaseApi<UserInfo> result = await _musicApiService.loginForCellPhone(
      _phoneController.text,
      _codeController.text,
    );
    debugPrint(result.data?.toJson().toString());
    setState(() {
      _userId = result.data!.userId;
    });
    _userService.saveUserInfo(userInfo: result.data);
  }

  Future<void> _captchaSent() async {
    final r = await _musicApiService.registerDev();
    _userService.saveUserInfo(registerDev: r.data);
    final BaseApi result = await _musicApiService.captchaSent(
      _phoneController.text,
    );
    debugPrint(result.toString());
  }

  Future<void> _getUserDetail() async {
    final BaseApi<UserInfoDetail> result = await _musicApiService.userDetail();
    debugPrint(result.data?.toJson().toString());
  }

  Future<void> _getQrCode() async {
    final BaseApi<LoginQrKey> result = await _musicApiService.loginQrKey();
    debugPrint(result.data?.toJson().toString());
    setState(() {
      _qrCode = result.data?.qrImage;
      _qrCodeKey = result.data?.qrcode;
    });
  }

  Future<void> _qrCodeCheck() async {
    final BaseApi<LoginQrCheck> result = await _musicApiService.loginQrCheck(
      _qrCodeKey!,
    );
    debugPrint(result.data?.toJson().toString());
    _userService.saveUserInfo(loginQrCheck: result.data);
  }

  Future<void> _loginToken() async {
    final BaseApi<UserInfo> result = await _musicApiService.loginToken();
    debugPrint(result.data?.toJson().toString());
  }

  Widget _buildPhoneLogin() {
    return Column(
      children: [
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(hintText: '请输入手机号'),
        ),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(hintText: '请输入验证码'),
        ),
        // 获取验证码
        ElevatedButton(
          onPressed: () {
            _captchaSent();
          },
          child: const Text('获取验证码(自动设置dfid了)'),
        ),
        // 登录
        ElevatedButton(
          onPressed: () {
            _login();
          },
          child: const Text('登录'),
        ),
        // 获取用户信息
        ElevatedButton(
          onPressed: () {
            _getUserDetail();
          },
          child: const Text('获取用户信息'),
        ),
        // 获取二维码
        ElevatedButton(
          onPressed: () {
            _getQrCode();
          },
          child: const Text('获取二维码'),
        ),
        _qrCode != null
            ? SizedBox(height: 200, child: Image.memory(_qrCode!))
            : const Text('请先获取二维码'),
        // 获取二维码状态
        ElevatedButton(
          onPressed: () {
            _qrCodeCheck();
          },
          child: const Text('获取二维码状态'),
        ),
        //刷新登录
        ElevatedButton(
          onPressed: () {
            _loginToken();
          },
          child: const Text('刷新登录'),
        ),
        ElevatedButton(
          onPressed: () {
            log(UserService.getUserId.toString());
            log(UserService.getNickname);
            log(UserService.getAvatarUrl);
            log(UserService.getVipType.toString());
            log(UserService.getVipBeginTime);
            log(UserService.getVipEndTime);
            log(UserService.getBirthday);
            log(UserService.getDfid);
            log(UserService.getCookies.toString());
          },
          child: Text("获取UserServicex信息"),
        ),
      ],
    );
  }
}
