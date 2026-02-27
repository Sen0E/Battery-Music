import 'dart:developer';
import 'dart:typed_data';

import 'package:battery_music/core/services/v2/node_api_client.dart';
import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/models/v2/base_api.dart';
import 'package:battery_music/models/v2/daily_recommend.dart';
import 'package:battery_music/models/v2/login_qr_check.dart';
import 'package:battery_music/models/v2/login_qr_key.dart';
import 'package:battery_music/models/v2/register_dev.dart';
import 'package:battery_music/models/v2/search_hot.dart';
import 'package:battery_music/models/v2/top_card.dart';
import 'package:battery_music/models/v2/user_info.dart';
import 'package:battery_music/models/v2/user_info_detail.dart';
import 'package:battery_music/models/v2/user_playlist.dart';
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
  final _nodeApiService = NodeApiService();
  final _nodeApiClient = NodeApiClient();
  Uint8List? _qrCode;
  String? _qrCodeKey;
  int? _userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Node API 测试')),
      body: Center(child: _buildMusicApi()),
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
        "${item.name!}\t\t\t ListID: ${item.listid}\t Pic: ${item.getCoverUrl(size: 200)}\t Count: ${item.count}",
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
          "音乐名称: ${item.songname}" +
              "\t作者: ${item.authorName}" +
              "\tHash: ${item.hash}" +
              "\t封面: ${item.getSizableCoverUrl()}",
        );
      }
    }
  }

  Future<void> _getTopCard() async {
    final response = await _nodeApiService.topCard(1);
    // log(response.data!.toJson());
    for (final item in response.data!.songList ?? []) {
      // log(item.toJson());
      log(
        "音乐名称: ${item.songname}" +
            "\t作者: ${item.authorName}" +
            "\tHash: ${item.hash}" +
            "\t封面: ${item.getSizableCoverUrl()}",
      );
    }
  }

  Future<void> _getMusicUrl(String hash) async {
    BaseApi<RegisterDev> registerDev = await _nodeApiService
        .registerDev(); // 鉴权（必须调用）
    final response = await _nodeApiService.songUrl(
      hash,
      registerDev.data!.dfid!,
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
            _getTopCard();
          },
          child: Text("歌曲推荐"),
        ),
        ElevatedButton(
          onPressed: () {
            _getMusicUrl("FE9DCD9D1D142832AB10D5E98CA17C98");
          },
          child: Text("获取音乐URL"),
        ),
      ],
    );
  }

  Future<void> _login() async {
    final BaseApi<UserInfo> result = await _nodeApiService.loginForCellPhone(
      _phoneController.text,
      _codeController.text,
    );
    debugPrint(result.data?.toJson().toString());
    setState(() {
      _userId = result.data!.userId;
    });
  }

  Future<void> _captchaSent() async {
    final BaseApi result = await _nodeApiService.captchaSent(
      _phoneController.text,
    );
    debugPrint(result.toString());
  }

  Future<void> _getUserDetail() async {
    final BaseApi<UserInfoDetail> result = await _nodeApiService.userDetail();
    debugPrint(result.data?.toJson().toString());
  }

  Future<void> _getQrCode() async {
    final BaseApi<LoginQrKey> result = await _nodeApiService.loginQrKey();
    debugPrint(result.data?.toJson().toString());
    setState(() {
      _qrCode = result.data?.qrImage;
      _qrCodeKey = result.data?.qrcode;
    });
  }

  Future<void> _qrCodeCheck() async {
    final BaseApi<LoginQrCheck> result = await _nodeApiService.loginQrCheck(
      _qrCodeKey!,
    );
    debugPrint(result.data?.toJson().toString());
  }

  Future<void> _loginToken() async {
    String? token = await _nodeApiClient.getToken();
    final BaseApi<UserInfo> result = await _nodeApiService.loginToken();
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
          child: const Text('获取验证码'),
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
      ],
    );
  }
}
