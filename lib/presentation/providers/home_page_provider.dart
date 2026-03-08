import 'package:battery_music/core/services/music_api_service.dart';
import 'package:battery_music/models/response/top_playlist.dart';
import 'package:battery_music/models/response/top_card.dart';
import 'package:battery_music/models/response/top_song.dart';
import 'package:flutter/foundation.dart';

class HomePageProvider extends ChangeNotifier {
  TopPlaylist? _topPlaylist;
  TopCard? _topCard;
  List<TopSong>? _newSongs;
  List<TopCard>? _categoryCards;

  bool _isLoadingPlaylists = false;
  bool _isLoadingCards = false;
  bool _isLoadingNewSongs = false;
  bool _isLoadingCategoryCards = false;

  String? _errorPlaylists;
  String? _errorCards;
  String? _errorNewSongs;
  String? _errorCategoryCards;

  TopPlaylist? get topPlaylist => _topPlaylist;
  TopCard? get topCard => _topCard;
  List<TopSong>? get newSongs => _newSongs;
  List<TopCard>? get categoryCards => _categoryCards;

  // 暴露出各个模块的具体加载和错误状态，供 UI 读取
  bool get isLoadingPlaylists => _isLoadingPlaylists;
  bool get isLoadingCards => _isLoadingCards;
  bool get isLoadingNewSongs => _isLoadingNewSongs;
  bool get isLoadingCategoryCards => _isLoadingCategoryCards;

  String? get errorPlaylists => _errorPlaylists;
  String? get errorCards => _errorCards;
  String? get errorNewSongs => _errorNewSongs;
  String? get errorCategoryCards => _errorCategoryCards;

  bool get isLoading =>
      _isLoadingPlaylists ||
      _isLoadingCards ||
      _isLoadingNewSongs ||
      _isLoadingCategoryCards;

  String? get error =>
      _errorPlaylists ?? _errorCards ?? _errorNewSongs ?? _errorCategoryCards;

  List<SpecialList> get recommendedPlaylists {
    return _topPlaylist?.specialList
            ?.where(
              (playlist) =>
                  playlist.specialname != null &&
                  playlist.getImgurl() != null &&
                  playlist.specialname!.isNotEmpty,
            )
            .toList() ??
        [];
  }

  List<SongItem> get personalizedSongs {
    return _topCard?.songList
            ?.where(
              (song) =>
                  song.songname != null &&
                  song.authorName != null &&
                  song.hash != null &&
                  song.songname!.isNotEmpty,
            )
            .toList() ??
        [];
  }

  List<TopSong> get topNewSongs {
    return _newSongs?.toList() ?? [];
  }

  List<SongItem> get hotSongs {
    return _categoryCards
            ?.elementAtOrNull(0)
            ?.songList
            ?.where(
              (song) => song.songname != null && song.songname!.isNotEmpty,
            )
            .toList() ??
        [];
  }

  List<SongItem> get nostalgicSongs {
    return _categoryCards
            ?.elementAtOrNull(1)
            ?.songList
            ?.where(
              (song) => song.songname != null && song.songname!.isNotEmpty,
            )
            .toList() ??
        [];
  }

  List<SongItem> get indieSongs {
    return _categoryCards
            ?.elementAtOrNull(2)
            ?.songList
            ?.where(
              (song) => song.songname != null && song.songname!.isNotEmpty,
            )
            .toList() ??
        [];
  }

  Future<void> fetchRecommendedPlaylists() async {
    _isLoadingPlaylists = true;
    _errorPlaylists = null;
    notifyListeners();

    try {
      final apiService = MusicApiService();
      final response = await apiService.topPlaylist();

      if (response.status == 1) {
        _topPlaylist = response.data;
      } else {
        _errorPlaylists = '获取推荐歌单失败';
      }
    } catch (e) {
      _errorPlaylists = e.toString();
    } finally {
      _isLoadingPlaylists = false;
      notifyListeners();
    }
  }

  Future<void> fetchPersonalizedSongs() async {
    _isLoadingCards = true;
    _errorCards = null;
    notifyListeners();

    try {
      final apiService = MusicApiService();
      final response = await apiService.topCard(1);

      if (response.status == 1) {
        _topCard = response.data;
      } else {
        _errorCards = '获取私人专属好歌失败';
      }
    } catch (e) {
      _errorCards = e.toString();
    } finally {
      _isLoadingCards = false;
      notifyListeners();
    }
  }

  Future<void> fetchNewSongs() async {
    _isLoadingNewSongs = true;
    _errorNewSongs = null;
    notifyListeners();

    try {
      final apiService = MusicApiService();
      final response = await apiService.topSong();

      if (response.status == 1 && response.data != null) {
        _newSongs = response.data;
      } else {
        _errorNewSongs = '获取新歌数据失败';
      }
    } catch (e) {
      _errorNewSongs = e.toString();
    } finally {
      _isLoadingNewSongs = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategoryCards() async {
    _isLoadingCategoryCards = true;
    _errorCategoryCards = null;
    notifyListeners();

    try {
      final apiService = MusicApiService();

      final hotSongsFuture = apiService.topCard(3);
      final nostalgicSongsFuture = apiService.topCard(2);
      final indieSongsFuture = apiService.topCard(4);

      final responses = await Future.wait([
        hotSongsFuture,
        nostalgicSongsFuture,
        indieSongsFuture,
      ]);

      final results = <TopCard>[];
      var hasError = false;
      var errorMsg = '';

      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];
        if (response.status == 1 && response.data != null) {
          results.add(response.data!);
        } else {
          hasError = true;
          errorMsg = '获取分类数据失败';
          break;
        }
      }

      if (!hasError) {
        _categoryCards = results;
      } else {
        _errorCategoryCards = errorMsg;
      }
    } catch (e) {
      _errorCategoryCards = e.toString();
    } finally {
      _isLoadingCategoryCards = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllHomeData() async {
    await Future.wait([
      fetchRecommendedPlaylists(),
      fetchPersonalizedSongs(),
      fetchNewSongs(),
      fetchCategoryCards(),
    ]);
  }
}
