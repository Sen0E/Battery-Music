import 'dart:async';
import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/models/song_url_response.dart';

/// 音频播放服务类
/// 负责实际的音频播放逻辑，包括播放控制、播放列表管理等
class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final NodeServiceApi _api;

  // --- 播放列表 ---
  List<dynamic> _playlist = []; // 存储歌曲对象 (SongItem 或 PlaylistSong)
  int _currentIndex = -1;

  // --- 播放状态 ---
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  ProcessingState _processingState = ProcessingState.idle;
  double _volume = 1.0;

  // --- 当前歌曲信息 ---
  String _currentSongName = "未知歌曲";
  String _currentSinger = "未知歌手";
  String? _currentCoverUrl;

  // --- 防重入标志 ---
  bool _isLoadingNewSong = false;

  // --- Stream controllers ---
  final StreamController<bool> _isPlayingController =
      StreamController.broadcast();
  final StreamController<Duration> _positionController =
      StreamController.broadcast();
  final StreamController<Duration> _durationController =
      StreamController.broadcast();
  final StreamController<ProcessingState> _processingStateController =
      StreamController.broadcast();
  final StreamController<double> _volumeController =
      StreamController.broadcast();
  final StreamController<String> _currentSongNameController =
      StreamController.broadcast();
  final StreamController<String> _currentSingerController =
      StreamController.broadcast();
  final StreamController<String?> _currentCoverUrlController =
      StreamController.broadcast();

  // --- Getters ---
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  ProcessingState get processingState => _processingState;
  double get volume => _volume; // 添加volume getter
  String get currentSongName => _currentSongName;
  String get currentSinger => _currentSinger;
  String? get currentCoverUrl => _currentCoverUrl;
  bool get hasCurrentSong => _currentIndex != -1 && _playlist.isNotEmpty;
  List<dynamic> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  // --- Streams ---
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<ProcessingState> get processingStateStream =>
      _processingStateController.stream;
  Stream<double> get volumeStream =>
      _volumeController.stream; // 添加volume stream
  Stream<String> get currentSongNameStream => _currentSongNameController.stream;
  Stream<String> get currentSingerStream => _currentSingerController.stream;
  Stream<String?> get currentCoverUrlStream =>
      _currentCoverUrlController.stream;

  AudioPlayerService(this._api) {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // 监听播放状态
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _processingState = state.processingState;
      _isPlayingController.add(_isPlaying);

      if (state.processingState == ProcessingState.completed) {
        // 自动播放下一首
        playNext();
      }
    });

    // 监听进度
    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      _positionController.add(pos);
    });

    // 监听总时长
    _audioPlayer.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      _durationController.add(_duration);
    });

    // 监听音量变化
    _audioPlayer.volumeStream.listen((vol) {
      _volume = vol;
      _volumeController.add(vol);
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
    if (playlist != null) {
      _playlist = playlist;
    }

    if (index != null) {
      _currentIndex = index;
    } else {
      // 如果没有提供 index，尝试在当前列表中查找或添加
      int idx = _playlist.indexOf(song);
      if (idx != -1) {
        _currentIndex = idx;
      } else {
        _playlist.add(song);
        _currentIndex = _playlist.length - 1;
      }
    }
    await _playCurrent();
  }

  /// 播放当前索引的歌曲
  Future<void> _playCurrent() async {
    // 防止重复加载
    if (_isLoadingNewSong) return;
    _isLoadingNewSong = true;

    try {
      if (_currentIndex < 0 || _currentIndex >= _playlist.length) return;

      final song = _playlist[_currentIndex];
      _updateCurrentSongInfo(song);

      try {
        // 适配不同类型的歌曲对象
        String? hash;
        if (song is Map<String, dynamic>) {
          // 如果是Map类型，尝试从中提取hash
          hash = song['fileHash'] ?? song['hash'];
        } else if (song.runtimeType.toString().contains('SongItem')) {
          // 处理SongItem类型
          hash = song.fileHash;
        } else if (song.runtimeType.toString().contains('PlaylistSong')) {
          // 处理PlaylistSong类型
          hash = song.hash;
        }

        if (hash == null || hash.isEmpty) {
          log("歌曲 Hash 为空，无法播放");
          playNext(); // 跳过无效歌曲
          return;
        }

        final SongUrlResponse response = await _api.songUrl(hash);
        final String? url = response.playUrl;

        if (url != null && url.isNotEmpty) {
          try {
            // 确保播放器处于正确的初始状态
            if (_audioPlayer.playerState.processingState !=
                ProcessingState.idle) {
              await _audioPlayer.stop();
              // 添加延时确保停止完成
              await Future.delayed(const Duration(milliseconds: 50));
            }

            await _audioPlayer.setUrl(url);
            await _audioPlayer.play();
          } catch (e, stack) {
            log("JustAudio 播放异常: $e");
            log("详细堆栈: $stack");
          }
        } else {
          log("获取播放链接失败 (URL 为空)");
          // playNext();
        }
      } catch (e) {
        log("播放流程出错: $e");
      }
    } finally {
      // 重置标志位，使用延时确保不会过早重置
      await Future.delayed(const Duration(milliseconds: 100));
      _isLoadingNewSong = false;
    }
  }

  /// 更新当前歌曲显示的元数据
  void _updateCurrentSongInfo(dynamic song) {
    if (song is Map<String, dynamic>) {
      // 如果是Map类型
      _currentSongName = song['songName'] ?? song['songNameOnly'] ?? "未知歌曲";
      _currentSinger = song['singerName'] ?? "未知歌手";
      _currentCoverUrl =
          song['image']?.replaceAll('{size}', '400') ?? song['cover'];
    } else if (song.runtimeType.toString().contains('SongItem')) {
      _currentSongName = song.songName ?? "未知歌曲";
      _currentSinger = song.singerName ?? "未知歌手";
      _currentCoverUrl = song.image?.replaceAll('{size}', '400');
    } else if (song.runtimeType.toString().contains('PlaylistSong')) {
      _currentSongName = song.songNameOnly;
      _currentSinger = song.singerName;
      _currentCoverUrl = song.getCoverUrl(size: 400);
    }

    // 添加到控制器中，供外部监听
    _currentSongNameController.add(_currentSongName);
    _currentSingerController.add(_currentSinger);
    _currentCoverUrlController.add(_currentCoverUrl);
  }

  /// 暂停/恢复
  void togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  /// 上一首
  void playPrevious() {
    if (_playlist.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
      _playCurrent();
    } else {
      // 已经是第一首，循环到最后一首或停止
      _currentIndex = _playlist.length - 1;
      _playCurrent();
    }
  }

  /// 下一首
  void playNext() {
    if (_playlist.isEmpty) return;
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      _playCurrent();
    } else {
      // 已经是最后一首，循环到第一首
      _currentIndex = 0;
      _playCurrent();
    }
  }

  /// 跳转进度
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// 设置音量
  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioPlayer.setVolume(volume);
    _volumeController.add(volume);
  }

  /// 获取音频播放器实例
  AudioPlayer get audioPlayer => _audioPlayer;

  /// 释放资源
  void dispose() {
    _audioPlayer.dispose();
    _isPlayingController.close();
    _positionController.close();
    _durationController.close();
    _processingStateController.close();
    _volumeController.close();
    _currentSongNameController.close();
    _currentSingerController.close();
    _currentCoverUrlController.close();
  }
}
