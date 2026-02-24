import 'package:flutter/material.dart';

/// 侧边栏状态 Provider
/// 管理侧边栏的选中状态
class SidebarProvider extends ChangeNotifier {
  // 当前选中的侧边栏索引 (0: 为我推荐, 1: 精选, etc...)
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  /// 切换侧边栏菜单
  /// [index] 选中的菜单索引
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// 重置为默认索引
  void resetToDefault() {
    _selectedIndex = 0;
    notifyListeners();
  }
}

/// 播放器状态 Provider
/// 管理播放器核心状态，如播放/暂停、进度、当前歌曲等
class PlayerStateProvider extends ChangeNotifier {
  // 是否正在播放
  bool _isPlaying = false;

  // 播放进度(0-1)
  double _playProgress = 0.0;

  // 总时长（毫秒）
  Duration _duration = Duration.zero;

  // 当前播放位置（毫秒）
  Duration _position = Duration.zero;

  // 当前播放的歌曲信息
  String _currentSongName = "";
  String _currentSinger = "";
  String _currentCoverUrl = "";

  bool get isPlaying => _isPlaying;
  double get playProgress => _playProgress;
  Duration get duration => _duration;
  Duration get position => _position;
  String get currentSongName => _currentSongName;
  String get currentSinger => _currentSinger;
  String get currentCoverUrl => _currentCoverUrl;

  /// 开始播放
  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  /// 暂停播放
  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  /// 停止播放
  void stop() {
    _isPlaying = false;
    _position = Duration.zero;
    _playProgress = 0.0;
    notifyListeners();
  }

  /// 更新播放进度
  void updateProgress(
    double progress, {
    Duration position = Duration.zero,
    Duration duration = Duration.zero,
  }) {
    _playProgress = progress;
    if (duration != Duration.zero) {
      _duration = duration;
    }
    if (position != Duration.zero) {
      _position = position;
    }
    notifyListeners();
  }

  /// 更新当前播放歌曲信息
  void updateCurrentSong({String? songName, String? singer, String? coverUrl}) {
    if (songName != null) _currentSongName = songName;
    if (singer != null) _currentSinger = singer;
    if (coverUrl != null) _currentCoverUrl = coverUrl;
    notifyListeners();
  }

  /// 重置播放状态
  void reset() {
    _isPlaying = false;
    _playProgress = 0.0;
    _position = Duration.zero;
    _duration = Duration.zero;
    _currentSongName = "";
    _currentSinger = "";
    _currentCoverUrl = "";
    notifyListeners();
  }
}

/// 播放器 UI 状态 Provider
/// 管理播放器界面的显示状态，如底部播放栏显示等
class PlayerUiProvider extends ChangeNotifier {
  // 是否显示底部播放栏
  bool _showBottomBar = false;

  bool get showBottomBar => _showBottomBar;

  /// 显示底部播放栏
  void showBottomBarNow() {
    _showBottomBar = true;
    notifyListeners();
  }

  /// 隐藏底部播放栏
  void hideBottomBar() {
    _showBottomBar = false;
    notifyListeners();
  }
}
