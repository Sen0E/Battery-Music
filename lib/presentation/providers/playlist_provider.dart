import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/models/v2/response/base_api.dart';
import 'package:flutter/material.dart';

import '../../models/v2/response/user_playlist.dart';

/// 歌单列表 Provider
/// 负责获取和管理用户的所有歌单，并分类
class PlaylistProvider extends ChangeNotifier {
  final NodeApiService _nodeApiService = NodeApiService();
  List<SongListInfo> _allPlaylists = [];
  SongListInfo? _likedPlaylist;
  List<SongListInfo> _minePlaylist = [];
  List<SongListInfo> _albumslist = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<SongListInfo> get minePlaylist => _minePlaylist;
  List<SongListInfo> get albumslist => _albumslist;
  SongListInfo? get likedPlaylist => _likedPlaylist;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 获取用户歌单列表
  /// 从 API 获取所有歌单，并进行分类
  Future<void> fetchUserPlaylists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final BaseApi<UserPlaylist> response = await _nodeApiService
          .userPlaylist();
      if (response.status == 1) {
        _allPlaylists = response.data!.info ?? [];
        _filterPlaylists();
      } else {
        _errorMessage = "获取失败";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 筛选歌单
  void _filterPlaylists() {
    // 筛选 喜欢音乐
    try {
      _likedPlaylist = _allPlaylists.firstWhere((p) => p.isDef == 2);
    } catch (_) {
      _likedPlaylist = null;
    }

    // 筛选 专辑
    _albumslist = _allPlaylists.where((p) {
      return p.source == 2;
    }).toList();

    // 筛选 自建歌单
    _minePlaylist = _allPlaylists.where((p) {
      return p.type == 0 && p.isDef == null;
    }).toList();
  }
}
