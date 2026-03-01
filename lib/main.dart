import 'dart:io';
import 'package:battery_music/core/services/v2/node_manager.dart';
import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/player_ui_provider.dart';
import 'package:battery_music/presentation/providers/playlist_detail_provider.dart';
import 'package:battery_music/presentation/providers/playlist_provider.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:battery_music/presentation/theme/app_theme.dart';
import 'package:battery_music/core/services/node_api_client.dart';
import 'package:battery_music/core/services/node_service_manager.dart';
import 'package:battery_music/presentation/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化音频支持
  // JustAudioMediaKit.ensureInitialized();

  // await NodeServiceManager.instance.startNodeService(); // 启动 NodeService
  // await NodeApiClient.instance.init(); // 初始化 Cookie 管理

  await windowManager.ensureInitialized(); // 初始化窗口管理器

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Battery Music'); // 设置标题
    await windowManager.setSize(const Size(1440, 900)); // 设置尺寸
    await windowManager.setMinimumSize(const Size(800, 600)); // 设置最小尺寸
    await windowManager.center(); // 居中
    await windowManager.show(); // 显示窗口
    await windowManager.focus(); // 聚焦窗口
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden); // 隐藏标题栏
  });

  runApp(const BatteryMusicApp());
}

class BatteryMusicApp extends StatefulWidget {
  const BatteryMusicApp({super.key});

  @override
  State<BatteryMusicApp> createState() => _BatteryMusicAppState();
}

class _BatteryMusicAppState extends State<BatteryMusicApp> with WindowListener {
  @override
  void initState() {
    super.initState();

    windowManager.addListener(this); // 添加监听器
    windowManager.setPreventClose(true); // 拦截关闭事件
  }

  @override
  void onWindowClose() async {
    // 先隐藏窗口
    await windowManager.hide();

    // 停止 Node 服务
    await NodeServiceManager.instance.stopNodeService();

    // 销毁窗口并退出进程
    await windowManager.destroy();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SidebarProvider()), // 侧边栏状态
        ChangeNotifierProvider(create: (_) => PlayerStateProvider()), // 播放器状态
        ChangeNotifierProvider(create: (_) => SearchProvider()), // 搜索
        ChangeNotifierProvider(create: (_) => PlaylistProvider()), // 歌单列表
        ChangeNotifierProvider(create: (_) => PlaylistDetailProvider()), // 歌单详情
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()), // 音频播放器
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: SplashPage(),
      ),
    );
  }
}
