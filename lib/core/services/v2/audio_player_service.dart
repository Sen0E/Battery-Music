import 'dart:developer';

import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/models/v2/entity/music_item.dart';
import 'package:battery_music/models/v2/response/song_data.dart';
import 'package:media_kit/media_kit.dart';

class AudioPlayerService {
  static final AudioPlayerService _audioPlayerService =
      AudioPlayerService._internal();
  factory AudioPlayerService() => _audioPlayerService;

  late final Player player;

  final NodeApiService _nodeApiService = NodeApiService();

  final List<MusicItem> _playlist = [];
  int _currentIndex = -1;

  AudioPlayerService._internal() {
    MediaKit.ensureInitialized();
    player = Player();

    player.stream.completed.listen((completed) {
      if (completed) {
        log("当前歌曲播放完毕，自动切歌...");
        playNext();
      }
    });
  }

  // --- 状态获取 (提供给外部只读) ---

  List<MusicItem> get playlist => List.unmodifiable(_playlist);

  MusicItem? get currentMusic =>
      (_currentIndex >= 0 && _currentIndex < _playlist.length)
      ? _playlist[_currentIndex]
      : null;

  int get currentIndex => _currentIndex;

  /// 内部通用播放方法：处理哈希值解析并丢给 media_kit
  Future<void> _playInternal(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final targetMusic = _playlist[_currentIndex];

    try {
      log("正在解析哈希值... 歌曲: ${targetMusic.songName} (Hash: ${targetMusic.hash})");
      final realUrl = await _fetchRealUrlFromHash(targetMusic.hash);
      if (realUrl != null) {
        // 解析成功，交给 media_kit 播放
        await player.open(Media(realUrl));
        await player.play();
      } else {
        log("当前音乐无法播放，正在切换下一首");
        playNext();
      }
    } catch (e) {
      log("获取播放链接失败: $e");
      // 解析失败策略：可以自动跳过当前歌曲播放下一首
      playNext();
    }
  }

  /// 将 hash 转换为真实 URL
  Future<String?> _fetchRealUrlFromHash(String hash) async {
    SongData res = await _nodeApiService.songUrl(hash);
    if (res.status == 1 && res.url != null && res.url!.isNotEmpty) {
      return res.url!.first;
    }
    return null;
  }

  /// 播放音乐 (继续播放)
  Future<void> play() async {
    if (_currentIndex == -1 && _playlist.isNotEmpty) {
      await _playInternal(0); // 列表有歌但还没开始播，默认播第一首
    } else {
      await player.play(); // 继续播放当前暂停的歌
    }
  }

  /// 暂停音乐
  Future<void> pause() async {
    await player.pause();
  }

  /// 播放上一首
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    int prevIndex = _currentIndex - 1;
    // 列表循环播放逻辑
    if (prevIndex < 0) {
      prevIndex = _playlist.length - 1;
    }
    await _playInternal(prevIndex);
  }

  /// 播放下一首
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    int nextIndex = _currentIndex + 1;
    // 列表循环播放逻辑
    if (nextIndex >= _playlist.length) {
      nextIndex = 0;
    }
    await _playInternal(nextIndex);
  }

  /// 清空播放列表
  Future<void> clearPlaylist() async {
    _playlist.clear();
    _currentIndex = -1;
    await player.stop();
  }

  /// 添加多个音乐到播放列表
  void addMultiple(List<MusicItem> items) {
    _playlist.addAll(items);
  }

  /// 添加单个音乐
  void addSingle(MusicItem item) {
    _playlist.add(item);
  }

  /// 添加一首音乐并立即播放
  Future<void> addAndPlay(MusicItem item) async {
    _playlist.add(item);
    // 播放刚刚加入到队尾的那首歌
    await _playInternal(_playlist.length - 1);
  }

  /// 添加一首音乐为下一首播放 (插队功能)
  void addNext(MusicItem item) {
    if (_playlist.isEmpty || _currentIndex == -1) {
      // 如果列表本来就是空的，或者还没开始播放，直接加进去
      _playlist.add(item);
    } else {
      // 插入到当前播放索引的正后方
      _playlist.insert(_currentIndex + 1, item);
    }
  }

  /// 播放指定音乐 (按索引播放)
  Future<void> playSpecific(int index) async {
    await _playInternal(index);
  }

  /// 设置音量 (接收0.0-100.0范围的值)
  Future<void> setVolume(double volume) async {
    // 确保音量在有效范围内
    double clampedVolume = volume.clamp(0.0, 100.0);
    await player.setVolume(clampedVolume);
  }

  /// 获取当前音量
  double get volume => player.state.volume;

  /// 销毁释放资源 (通常在 App 退出时调用)
  void dispose() {
    player.dispose();
  }
}