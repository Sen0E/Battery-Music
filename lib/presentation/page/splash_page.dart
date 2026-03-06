import 'package:battery_music/core/services/music_api_service.dart';
import 'package:battery_music/core/services/user_service.dart';
import 'package:battery_music/models/response/base_api.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:battery_music/presentation/layout/main_layout.dart';
import 'package:battery_music/presentation/page/login_page.dart';
import 'package:flutter/material.dart';

/// 启动页
/// 负责检查用户登录状态，根据 Cookie 有效性跳转至主页或登录页
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final MusicApiService _musicApiService = MusicApiService();
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  /// 检查登录状态
  Future<void> _checkLoginStatus() async {
    // 测试用
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     // 检查widget是否仍在界面上
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const TestNodeApi()),
    //     );
    //   }
    // }); // 确保在当前帧绘制完成后跳转
    // return;

    if (!UserService.hasLogin) {
      _navigateToLogin();
      return;
    }

    BaseApi<UserInfo> result = await _musicApiService.loginToken();
    if (result.status == 1) {
      _userService.saveUserInfo(userInfo: result.data);
      _navigateToHome();
    } else {
      _userService.logOut();
      _navigateToLogin();
    }
  }

  /// 跳转到主页
  void _navigateToHome() {
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
    }
  }

  /// 跳转到登录页
  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
