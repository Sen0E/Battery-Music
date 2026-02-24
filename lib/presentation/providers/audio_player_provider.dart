import 'dart:async';
import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/core/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// 定义歌曲项的基本接口
abstract class SongItemBase {
  String get name;
  String get singer;
  String? get coverUrl;
}

/// 音频播放器 Provider
/// 负责实际的音频播放逻辑，包括获取播放链接、播放控制、播放列表管理等
class AudioPlayerProvider extends ChangeNotifier {
  late final AudioPlayerService _audioPlayerService;
  final NodeServiceApi _api = NodeServiceApi.instance;

  // --- 播放状态 ---
  bool get isPlaying => _audioPlayerService.isPlaying;
  Duration get position => _audioPlayerService.position;
  Duration get duration => _audioPlayerService.duration;
  ProcessingState get processingState => _audioPlayerService.processingState;
  double get volume => _audioPlayerService.volume;
  String get currentSongName => _audioPlayerService.currentSongName;
  String get currentSinger => _audioPlayerService.currentSinger;
  String? get currentCoverUrl => _audioPlayerService.currentCoverUrl;
  bool get hasCurrentSong => _audioPlayerService.hasCurrentSong;
  // 公开播放列表
  List<dynamic> get playlist => _audioPlayerService.playlist;

  AudioPlayerProvider() {
    _audioPlayerService = AudioPlayerService(_api);
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // 监听播放状态
    _audioPlayerService.isPlayingStream.listen((isPlaying) {
      notifyListeners();
    });

    _audioPlayerService.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // 自动播放下一首
        playNext();
      }
      notifyListeners();
    });

    // 监听进度
    _audioPlayerService.positionStream.listen((pos) {
      notifyListeners();
    });

    // 监听总时长
    _audioPlayerService.durationStream.listen((d) {
      notifyListeners();
    });

    // 监听音量变化
    _audioPlayerService.volumeStream.listen((vol) {
      notifyListeners();
    });

    // 监听歌曲信息变化
    _audioPlayerService.currentSongNameStream.listen((name) {
      notifyListeners();
    });

    _audioPlayerService.currentSingerStream.listen((singer) {
      notifyListeners();
    });

    _audioPlayerService.currentCoverUrlStream.listen((coverUrl) {
      notifyListeners();
    });
  }

  /// 播放指定歌曲
  /// [song] 歌曲对象 (SongItem 或 PlaylistSong)
  /// [playlist] 可选，如果提供了播放列表，则替换当前播放列表
  /// [index] 可选，如果提供了播放列表，指定播放的索引
  Future<void> playSong(
    dynamic song, {
    List<dynamic>? playlist,
    int? index,
  }) async {
    // await _audioPlayerService.playSong(song, playlist: playlist, index: index);

    final safePlaylist = playlist != null ? List.from(playlist) : null;
    await _audioPlayerService.playSong(
      song,
      playlist: safePlaylist,
      index: index,
    );

    notifyListeners();
  }

  /// 暂停/恢复
  void togglePlay() {
    _audioPlayerService.togglePlay();
    notifyListeners();
  }

  /// 上一首
  void playPrevious() {
    _audioPlayerService.playPrevious();
    notifyListeners();
  }

  /// 下一首
  void playNext() {
    _audioPlayerService.playNext();
    notifyListeners();
  }

  /// 跳转进度
  Future<void> seek(Duration position) async {
    await _audioPlayerService.seek(position);
    notifyListeners();
  }

  /// 设置音量
  Future<void> setVolume(double volume) async {
    await _audioPlayerService.setVolume(volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }
}
