import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/models/v2/response/search_hot.dart';
// import 'package:battery_music/models/search_hot_response.dart';
// import 'package:battery_music/models/search_special_response.dart';
// import 'package:battery_music/models/search_suggest_response.dart';
import 'package:battery_music/models/v2/response/search_keywords_song.dart';
import 'package:battery_music/models/v2/response/search_keywords_special.dart';
import 'package:battery_music/models/v2/response/search_suggest.dart';
import 'package:flutter/foundation.dart';
// import 'package:battery_music/models/search_song_response.dart';
// import 'package:battery_music/core/services/node_service_api.dart';

/// 搜索类型枚举
enum SearchType { songs, playlists }

/// 搜索状态管理 Provider
/// 负责管理搜索关键词、搜索结果（单曲/歌单）、热搜榜、搜索建议及分页加载状态
class SearchProvider extends ChangeNotifier {
  // final NodeServiceApi _api = NodeServiceApi.instance;
  final NodeApiService _nodeApiService = NodeApiService();

  // --- 状态 ---
  String _currentKeyword = '';
  List<SearchCategory> _hotSearchCategories = [];
  List<RecordData> _searchSuggestions = [];
  List<SearchKeywordsSong> _songResults = [];
  List<SearchKeywordsSpecial> _playlistResults = [];
  bool _isLoading = false;
  int _searchTabIndex = 0; // 0: 歌曲, 1: 歌单

  // --- 分页状态 ---
  int _songPage = 1;
  int _playlistPage = 1;
  final int _pageSize = 30;
  bool _hasMoreSongs = true;
  bool _hasMorePlaylists = true;

  // --- Getters ---
  String get currentKeyword => _currentKeyword;
  List<SearchCategory> get hotSearchCategories => _hotSearchCategories;
  List<RecordData> get searchSuggestions => _searchSuggestions;
  List<SearchKeywordsSong> get songResults => _songResults;
  List<SearchKeywordsSpecial> get playlistResults => _playlistResults;
  bool get isLoading => _isLoading;
  int get searchTabIndex => _searchTabIndex;
  bool get hasMoreSongs => _hasMoreSongs;
  bool get hasMorePlaylists => _hasMorePlaylists;

  /// 主搜索入口
  /// [keyword] 搜索关键词
  /// 重置所有状态并执行默认搜索（单曲）
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) return;

    _currentKeyword = keyword;
    _isLoading = true;
    // 重置所有结果和分页
    _songResults = [];
    _playlistResults = [];
    _songPage = 1;
    _playlistPage = 1;
    _hasMoreSongs = true;
    _hasMorePlaylists = true;
    _searchTabIndex = 0; // 默认显示歌曲

    notifyListeners();

    try {
      // 默认执行歌曲搜索
      // final response = await _api.searchKeywords<SearchSongResponse>(
      //   _currentKeyword,
      //   _songPage,
      //   pageSize: _pageSize,
      //   type: 'song',
      //   fromJson: SearchSongResponse.fromJson,
      // );
      final response = await _nodeApiService.searchKeywords<SearchKeywordsSong>(
        _currentKeyword,
        page: _songPage,
        pageSize: _pageSize,
      );
      // if (response.data != null) {
      //   final newItems = response.data!.lists ?? [];
      //   _songResults = newItems;
      //   _hasMoreSongs = newItems.length >= _pageSize;
      //   _songPage++;
      // }
      if (response.data != null) {
        final newItems = response.data!.lists ?? [];
        _songResults = newItems;
        _hasMoreSongs = newItems.length >= _pageSize;
        _songPage++;
      }
    } catch (e) {
      debugPrint('Error searching songs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 切换搜索结果 Tab
  /// [index] 0: 单曲, 1: 歌单
  /// 切换时若对应数据为空，则自动触发加载
  Future<void> onTabChanged(int index) async {
    if (_searchTabIndex == index) return;
    _searchTabIndex = index;
    notifyListeners();

    // 切换到歌单tab且歌单数据为空，则加载
    if (index == 1 && _playlistResults.isEmpty) {
      await searchPlaylists();
    }
    // 切换到歌曲tab且歌曲数据为空，则加载
    else if (index == 0 && _songResults.isEmpty) {
      await searchSongs();
    }
  }

  /// 搜索歌曲
  /// [isLoadMore] 是否为上拉加载更多
  Future<void> searchSongs({bool isLoadMore = false}) async {
    if (_isLoading || (isLoadMore && !_hasMoreSongs)) return;

    _isLoading = true;
    if (!isLoadMore) {
      _songPage = 1;
      _songResults = [];
    }
    notifyListeners();

    try {
      // final response = await _api.searchKeywords<SearchSongResponse>(
      //   _currentKeyword,
      //   _songPage,
      //   pageSize: _pageSize,
      //   type: 'song',
      //   fromJson: SearchSongResponse.fromJson,
      // );

      // if (response.data != null) {
      //   final newItems = response.data!.lists ?? [];
      //   if (isLoadMore) {
      //     _songResults.addAll(newItems);
      //   } else {
      //     _songResults = newItems;
      //   }
      //   _hasMoreSongs = newItems.length >= _pageSize;
      //   _songPage++;
      // }

      final response = await _nodeApiService.searchKeywords<SearchKeywordsSong>(
        _currentKeyword,
        page: _songPage,
        pageSize: _pageSize,
      );
      if (response.data != null) {
        final newItems = response.data!.lists ?? [];
        if (isLoadMore) {
          _songResults.addAll(newItems);
        } else {
          _songResults = newItems;
        }
        _hasMoreSongs = newItems.length >= _pageSize;
        _songPage++;
      }
    } catch (e) {
      debugPrint('Error searching songs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 搜索歌单
  /// [isLoadMore] 是否为上拉加载更多
  Future<void> searchPlaylists({bool isLoadMore = false}) async {
    if (_isLoading || (isLoadMore && !_hasMorePlaylists)) return;

    _isLoading = true;
    if (!isLoadMore) {
      _playlistPage = 1;
      _playlistResults = [];
    }
    notifyListeners();

    try {
      // final response = await _api.searchKeywords<SearchSpecialResponse>(
      //   _currentKeyword,
      //   _playlistPage,
      //   pageSize: _pageSize,
      //   type: 'special',
      //   fromJson: SearchSpecialResponse.fromJson,
      // );

      // if (response.data != null) {
      //   final newItems = response.data!.lists ?? [];
      //   if (isLoadMore) {
      //     _playlistResults.addAll(newItems);
      //   } else {
      //     _playlistResults = newItems;
      //   }
      //   _hasMorePlaylists = newItems.length >= _pageSize;
      //   _playlistPage++;
      // }

      final response = await _nodeApiService
          .searchKeywords<SearchKeywordsSpecial>(
            _currentKeyword,
            type: 'special',
            page: _playlistPage,
            pageSize: _pageSize,
          );
      if (response.data != null) {
        final newItems = response.data!.lists ?? [];
        if (isLoadMore) {
          _playlistResults.addAll(newItems);
        } else {
          _playlistResults = newItems;
        }
        _hasMorePlaylists = newItems.length >= _pageSize;
        _playlistPage++;
      }
    } catch (e) {
      debugPrint('Error searching playlists: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取热搜榜单
  Future<void> fetchHotSearches() async {
    _isLoading = true;
    notifyListeners();

    try {
      // final response = await _api.searchHot();
      // if (response.data != null) {
      //   _hotSearchCategories = response.data!.list ?? [];
      // }
      final response = await _nodeApiService.searchHot();
      if (response.status == 1) {
        _hotSearchCategories = response.data!.list ?? [];
      }
    } catch (e) {
      debugPrint('Error fetching hot searches: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取搜索建议
  /// [keyword] 当前输入的关键词
  Future<void> fetchSearchSuggestions(String keyword) async {
    if (keyword.isEmpty) {
      _searchSuggestions = [];
      notifyListeners();
      return;
    }
    try {
      // _searchSuggestions = await _api.searchSuggest(keyword);
      final response = await _nodeApiService.searchSuggest(keyword);
      if (response.status == 1) {
        _searchSuggestions = response.data!.first.recordDatas!;
      } else {
        _searchSuggestions = [];
      }
    } catch (e) {
      debugPrint('Error fetching search suggestions: $e');
      _searchSuggestions = [];
    } finally {
      notifyListeners();
    }
  }

  /// 清除搜索状态
  void clearResults() {
    _currentKeyword = '';
    _songResults = [];
    _playlistResults = [];
    _searchTabIndex = 0;
    notifyListeners();
  }
}
