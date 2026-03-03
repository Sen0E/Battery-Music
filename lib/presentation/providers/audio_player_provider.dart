import 'dart:async';
import 'package:battery_music/core/services/audio_player_service.dart';
import 'package:battery_music/models/entity/music_item.dart';
import 'package:battery_music/models/response/playlist_track.dart';
import 'package:battery_music/models/response/search_keywords_song.dart';
import 'package:battery_music/models/response/daily_recommend.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

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

  // --- 播放状态 ---
  bool get isPlaying => _audioPlayerService.player.state.playing;
  Duration get position => _audioPlayerService.player.state.position;
  Duration get duration => _audioPlayerService.player.state.duration;
  bool get hasCurrentSong => _audioPlayerService.currentMusic != null;
  // 公开播放列表
  List<dynamic> get playlist =>
      _audioPlayerService.playlist.map((e) => e).toList();

  String get currentSongName =>
      _audioPlayerService.currentMusic?.songName.split(' - ').last ?? '';
  String get currentSinger =>
      _audioPlayerService.currentMusic?.singerName ?? '';
  String? get currentCoverUrl => _audioPlayerService.currentMusic?.coverImage;
  // 将播放器的音量值（0.0-100.0）转换为Flutter Slider的范围（0.0-1.0）
  double get volume => _audioPlayerService.volume / 100.0;

  AudioPlayerProvider() {
    _audioPlayerService = AudioPlayerService();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // 监听播放状态
    _audioPlayerService.player.stream.playing.listen((isPlaying) {
      notifyListeners();
    });

    // 监听总时长
    _audioPlayerService.player.stream.duration.listen((d) {
      notifyListeners();
    });

    // 监听进度
    _audioPlayerService.player.stream.position.listen((pos) {
      notifyListeners();
    });

    // 监听音量变化
    _audioPlayerService.player.stream.volume.listen((vol) {
      notifyListeners();
    });

    // 监听播放结束事件
    _audioPlayerService.player.stream.completed.listen((completed) {
      if (completed) {
        log("当前歌曲播放完毕，自动切歌...");
        // 不在这里调用playNext，而是让AudioPlayerService内部处理
        // 因为AudioPlayerService内部已经监听了completed事件并处理了自动切换逻辑
      }
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
    // 将传入的动态类型转换为MusicItem类型
    if (playlist != null) {
      // 清空现有播放列表
      await _audioPlayerService.clearPlaylist();

      // 添加新列表
      final musicItems = playlist
          .whereType<dynamic>()
          .map((item) {
            // 处理搜索结果中的歌曲类型
            if (item is SearchKeywordsSong) {
              return MusicItem(
                hash: item.fileHash!,
                songName: item.fileName!.split(' - ').last,
                singerName: item.singerName ?? '',
                coverImage: item.getImageUrl(),
              );
            } else
            // 处理歌单中的歌曲类型
            if (item is PlaylistTrackSongItem) {
              return MusicItem(
                hash: item.hash!,
                songName: item.name!.split(' - ').last,
                singerName: item.name!.split('-').first,
                coverImage: item.getCoverUrl(),
              );
            } else
            // 处理每日推荐中的歌曲类型
            if (item is DailyRecommendSongItem) {
              return MusicItem(
                hash: item.hash ?? '',
                songName: item.songname!,
                singerName: item.authorName!,
                coverImage: item.getSizableCoverUrl(),
              );
            } else {
              debugPrint("无法处理此歌曲类型：${item.runtimeType}");
              return null;
            }
          })
          .where((item) => item != null)
          .cast<MusicItem>()
          .toList();

      _audioPlayerService.addMultiple(musicItems);

      // 播放指定索引的歌曲
      int actualIndex =
          index ??
          musicItems.indexOf(
            musicItems.firstWhere(
              (item) =>
                  (item.hash ==
                  (song is SearchKeywordsSong ? song.fileHash : song.hash)),
              orElse: () => musicItems[0],
            ),
          );

      if (actualIndex >= 0 && actualIndex < musicItems.length) {
        await _audioPlayerService.playSpecific(actualIndex);
      }
    } else {
      // 单曲播放
      MusicItem musicItem;
      if (song is SearchKeywordsSong) {
        // 处理搜索结果中的歌曲类型
        musicItem = MusicItem(
          hash: song.fileHash ?? '',
          songName: song.fileName ?? song.oriSongName ?? '',
          singerName: song.singerName ?? '',
          coverImage: song.image ?? '',
        );
      } else if (song is! MusicItem) {
        // 转换为MusicItem
        musicItem = MusicItem(
          hash: song.hash ?? '',
          songName: song.name ?? song.songName ?? '',
          singerName: song.singer ?? song.singerName ?? song.artist ?? '',
          coverImage: song.coverImage ?? song.albumCover ?? song.coverUrl ?? '',
        );
      } else {
        musicItem = song;
      }

      await _audioPlayerService.addAndPlay(musicItem);
    }

    notifyListeners();
  }

  /// 暂停/恢复
  void togglePlay() {
    if (_audioPlayerService.player.state.playing) {
      _audioPlayerService.pause();
    } else {
      _audioPlayerService.play();
    }
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
    await _audioPlayerService.player.seek(position);
    notifyListeners();
  }

  /// 设置音量 (接收0.0-1.0范围的值，转换为0.0-100.0传递给播放器)
  Future<void> setVolume(double volume) async {
    log("设置音量: $volume");
    // 将Flutter Slider的0.0-1.0范围转换为播放器的0.0-100.0范围
    await _audioPlayerService.setVolume(volume * 100.0);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }
}
