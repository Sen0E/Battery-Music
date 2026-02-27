import 'dart:developer';

import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/core/services/user_service.dart';
import 'package:battery_music/models/base_response.dart';
import 'package:battery_music/models/login_response.dart';
import 'package:battery_music/models/user_detial_response.dart';
import 'package:battery_music/presentation/layout/main_layout.dart';
import 'package:battery_music/presentation/test/test_node_api.dart';
import 'package:flutter/material.dart';
import 'package:battery_music/core/services/node_api_client.dart';
import 'package:battery_music/presentation/page/login_page.dart';

/// 启动页
/// 负责检查用户登录状态，根据 Cookie 有效性跳转至主页或登录页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// 检查登录状态
  /// 1. 检查本地是否有 Cookie
  /// 2. 如果有，尝试刷新 Token
  /// 3. 根据结果跳转
  Future<void> _checkLoginStatus() async {
    // 测试用
    log("进入测试页面"); // 调试信息可以保留
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _navigateToApiTest(),
    ); // 确保在当前帧绘制完成后跳转

    // 检查本地是否有 Cookie
    final hasLocalCookies = await NodeApiClient.instance.hasCookies();

    // _navigateToHome(); // 测试用
    // return;

    if (!hasLocalCookies) {
      _navigateToLogin();
      return;
    }

    // 如果有 Cookie，尝试请求服务器刷新 Token
    List cookies = await NodeApiClient.instance.getCookies();
    String token = cookies.firstWhere((cookie) => cookie.name == 'token').value;
    String userid = cookies
        .firstWhere((cookie) => cookie.name == 'userid')
        .value;
    // 刷新 Token
    ApiResponse<LoginResponse> result = await NodeServiceApi.instance
        .loginToken(token, userid);

    if (result.status == 1) {
      // 获取用户信息
      ApiResponse<UserDetial> userDetialResult = await NodeServiceApi.instance
          .userDetial();
      UserService.instance.saveUserInfo(userDetialResult.data!);
      // Token 有效，跳转到主页
      _navigateToHome();
    } else {
      // Token 无效，清除本地 Cookie 并去登录页
      await NodeApiClient.instance.clearCookies();
      _navigateToLogin();
    }
  }

  /// 跳转到主页
  void _navigateToHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
  }

  /// 跳转到登录页
  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  // 跳转到API测试页面
  void _navigateToApiTest() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const TestNodeApi()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
