import 'dart:io';

import 'package:battery_music/app/app_providers.dart';
import 'package:battery_music/presentation/page/splash_page.dart';
import 'package:battery_music/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Battery Music');
    await windowManager.setSize(const Size(1440, 900));
    await windowManager.setMinimumSize(const Size(800, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  });

  runApp(const BatteryMusicApp());
}

class BatteryMusicApp extends StatefulWidget {
  const BatteryMusicApp({super.key});

  @override
  State<BatteryMusicApp> createState() => _BatteryMusicAppState();
}

class _BatteryMusicAppState extends State<BatteryMusicApp>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
  }

  @override
  void onWindowClose() async {
    await windowManager.hide();
    await windowManager.destroy();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(),
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const SplashPage(),
      ),
    );
  }
}
