import 'package:battery_music/app/app_bootstrap.dart';
import 'package:battery_music/core/services/music_api_service.dart';
import 'package:battery_music/core/services/user_service.dart';
import 'package:battery_music/models/response/base_api.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:battery_music/presentation/layout/main_layout.dart';
import 'package:battery_music/presentation/page/login_page.dart';
import 'package:battery_music/presentation/widgets/loading/app_loading_view.dart';
import 'package:flutter/material.dart';

/// 启动页，负责完成应用初始化并分流到登录页或主页。
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final MusicApiService _musicApiService = MusicApiService();
  final UserService _userService = UserService();
  bool _didRoute = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapAndRoute();
    });
  }

  Future<void> _bootstrapAndRoute() async {
    await AppBootstrap.initialize();
    await _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (_didRoute) {
      return;
    }

    if (!UserService.hasLogin) {
      _navigateToLogin();
      return;
    }

    late final BaseApi<UserInfo> result;
    try {
      result = await _musicApiService.loginToken();
    } catch (_) {
      await _userService.logOut();
      _navigateToLogin();
      return;
    }

    if (result.status == 1) {
      await _userService.saveUserInfo(userInfo: result.data);
      _navigateToHome();
    } else {
      await _userService.logOut();
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    if (mounted && !_didRoute) {
      _didRoute = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    }
  }

  void _navigateToLogin() {
    if (mounted && !_didRoute) {
      _didRoute = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoadingView());
  }
}
