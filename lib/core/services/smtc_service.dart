import 'dart:developer';
import 'dart:io';

import 'package:battery_music/models/entity/music_item.dart';
import 'package:smtc_windows/smtc_windows.dart';

class SmtcService {
  static final SmtcService _instance = SmtcService._internal();
  factory SmtcService() => _instance;

  SMTCWindows? _smtc;

  // --- 给音频播放器使用的回调 ---
  void Function()? onPlay;
  void Function()? onPause;
  void Function()? onNext;
  void Function()? onPrevious;

  SmtcService._internal() {
    // 确保仅在 Windows 平台初始化 SMTC
    if (Platform.isWindows) {
      _initSmtc();
    }
  }

  // 变更为异步方法，以等待插件的 initialize
  Future<void> _initSmtc() async {
    try {
      // 新版 smtc_windows 要求先进行初始化
      // 注意：官方推荐在 main.dart 的 runApp 之前调用，但为了解耦，在这里安全调用也是可行的
      await SMTCWindows.initialize();

      _smtc = SMTCWindows(
        config: const SMTCConfig(
          fastForwardEnabled: false,
          nextEnabled: true,
          pauseEnabled: true,
          playEnabled: true,
          rewindEnabled: false,
          prevEnabled: true,
          stopEnabled: true,
        ),
      );

      // 监听 Windows 系统的媒体控制按键（新版变更为 buttonPressStream）
      _smtc?.buttonPressStream.listen((event) {
        switch (event) {
          case PressedButton.play:
            onPlay?.call();
            break;
          case PressedButton.pause:
            onPause?.call();
            break;
          case PressedButton.next:
            onNext?.call();
            break;
          case PressedButton.previous:
            onPrevious?.call();
            break;
          default:
            break;
        }
      });
      log("SMTC (Windows 媒体控制) 初始化成功");
    } catch (e) {
      log("SMTC 初始化失败: $e");
    }
  }

  /// 更新歌曲元数据（封面、标题、歌手等）
  void updateMetadata(MusicItem item) {
    if (_smtc == null) return;
    try {
      _smtc?.updateMetadata(
        MusicMetadata(
          title: item.songName,
          artist: item.singerName,
          // SMTC 通常支持直接传入本地路径或网络 URL
          thumbnail: item.coverImage,
        ),
      );
    } catch (e) {
      log("SMTC 更新元数据失败: $e");
    }
  }

  /// 更新播放状态（播放/暂停）
  void updatePlaybackStatus(bool isPlaying) {
    if (_smtc == null) return;
    try {
      _smtc?.setPlaybackStatus(
        isPlaying ? PlaybackStatus.playing : PlaybackStatus.paused,
      );
    } catch (e) {
      log("SMTC 更新播放状态失败: $e");
    }
  }

  /// 更新时间轴（播放进度）
  void updateTimeline(Duration position, Duration duration) {
    if (_smtc == null) return;
    try {
      // 新版 PlaybackTimeline 参数变更为 int 类型的毫秒数 (Ms)
      _smtc?.setTimeline(
        PlaybackTimeline(
          startTimeMs: 0,
          endTimeMs: duration.inMilliseconds,
          positionMs: position.inMilliseconds,
          minSeekTimeMs: 0,
          maxSeekTimeMs: duration.inMilliseconds,
        ),
      );
    } catch (e) {
      // 进度更新非常频繁，此处静默捕获异常防止日志污染
    }
  }

  /// 释放资源
  void dispose() {
    if (_smtc == null) return;
    try {
      _smtc?.dispose();
    } catch (e) {
      log("SMTC 销毁失败: $e");
    }
  }
}
