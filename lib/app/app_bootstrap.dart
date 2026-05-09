import 'dart:developer';

import 'package:battery_music/core/services/music_api_service.dart';
import 'package:battery_music/core/services/user_service.dart';

/// 应用启动阶段的初始化入口。
class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    await UserService.initialize(false);

    if (UserService.dfid.isNotEmpty) {
      return;
    }

    try {
      final response = await MusicApiService().registerDev();
      final registerDev = response.data;
      if (registerDev != null) {
        await UserService().saveUserInfo(registerDev: registerDev);
      }
    } catch (e, stackTrace) {
      log('设备注册失败，但应用会继续启动: $e', stackTrace: stackTrace);
    }
  }
}
