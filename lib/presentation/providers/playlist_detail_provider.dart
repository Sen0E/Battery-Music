import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/models/base_response.dart';
import 'package:battery_music/models/playlist_track_new_response.dart';
import 'package:flutter/material.dart';

/// 歌单详情 Provider
/// 负责获取和管理单个歌单的详细信息（包括歌曲列表）
class PlaylistDetailProvider extends ChangeNotifier {
  List<PlaylistSong> _songs = [];
  PlaylistTrackDataNew? _playlistData;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 30;
  String? _errorMessage;

  List<PlaylistSong> get songs => _songs;
  PlaylistTrackDataNew? get playlistData => _playlistData;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  /// 获取歌单详情（第一页）
  /// [listid] 歌单 ID
  Future<void> fetchPlaylistDetail(int listid) async {
    _isLoading = true;
    _errorMessage = null;
    _songs.clear();
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();

    try {
      _currentPage = 1;
      final ApiResponse<PlaylistTrackDataNew> response = await NodeServiceApi
          .instance
          .playlistTrackNew(listid, _currentPage, _pageSize);
      if (response.status == 1) {
        _playlistData = response.data;
        _songs = response.data!.songs ?? [];

        // 检查是否还有更多数据
        _hasMore = _songs.length >= _pageSize;
      } else {
        _errorMessage = "获取歌单详情失败";
      }
    } catch (e) {
      _errorMessage = "网络错误: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 加载更多歌曲
  Future<void> loadMoreSongs(int listid) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final ApiResponse<PlaylistTrackDataNew> response = await NodeServiceApi
          .instance
          .playlistTrackNew(listid, nextPage, _pageSize);

      if (response.status == 1 && response.data!.songs != null) {
        final newSongs = response.data!.songs!;
        _songs.addAll(newSongs);
        _currentPage = nextPage;

        // 检查是否还有更多数据
        _hasMore = newSongs.length >= _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = "加载更多失败: $e";
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 清除数据
  void clearData() {
    _songs.clear();
    _playlistData = null;
    _isLoading = false;
    _isLoadingMore = false;
    _hasMore = true;
    _currentPage = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
