import 'dart:typed_data';

import 'package:battery_music/core/services/v2/node_api_client.dart';
import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/models/v2/base_api.dart';
import 'package:battery_music/models/v2/login_qr_check.dart';
import 'package:battery_music/models/v2/login_qr_key.dart';
import 'package:battery_music/models/v2/user_info.dart';
import 'package:battery_music/models/v2/user_info_detail.dart';
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
      body: Center(child: _buildPhoneLogin()),
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
    final BaseApi<UserInfo> result = await _nodeApiService.loginToken(
      token!,
      _userId.toString(),
    );
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
