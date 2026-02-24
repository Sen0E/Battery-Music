import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/models/user_playlist_response.dart';
import 'package:flutter/material.dart';

/// 歌单列表 Provider
/// 负责获取和管理用户的所有歌单，并分类为“自建歌单”、“收藏歌单”和“喜欢音乐”
class PlaylistProvider extends ChangeNotifier {
  List<UserPlaylist> _allPlaylists = [];
  List<UserPlaylist> _customPlaylists = [];
  UserPlaylist? _favoritePlaylist; // 收藏歌单 (isDef == 1)
  UserPlaylist? _likedPlaylist; // 喜欢音乐 (isDef == 2)

  bool _isLoading = false;
  String? _errorMessage;

  List<UserPlaylist> get customPlaylists => _customPlaylists;
  UserPlaylist? get favoritePlaylist => _favoritePlaylist;
  UserPlaylist? get likedPlaylist => _likedPlaylist;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 获取用户歌单列表
  /// 从 API 获取所有歌单，并根据 isDef 字段进行分类
  Future<void> fetchUserPlaylists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await NodeServiceApi.instance.userPlayList();
      if (response.data != null) {
        _allPlaylists = response.data!.info ?? [];
        _filterPlaylists();
      } else {
        _errorMessage = "获取歌单失败";
      }
    } catch (e) {
      _errorMessage = "网络错误: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 筛选歌单
  /// 根据 isDef 字段将歌单分类：
  /// - isDef == 0 或 null: 自建歌单
  /// - isDef == 1: 收藏歌单
  /// - isDef == 2: 喜欢音乐
  void _filterPlaylists() {
    // 筛选 isDef 为 null 或 0 的歌单 (普通自建歌单)
    _customPlaylists = _allPlaylists.where((playlist) {
      return playlist.isDef == null || playlist.isDef == 0;
    }).toList();

    // 筛选 收藏歌单 (isDef == 1)
    try {
      _favoritePlaylist = _allPlaylists.firstWhere((p) => p.isDef == 1);
    } catch (_) {
      _favoritePlaylist = null;
    }

    // 筛选 喜欢音乐 (isDef == 2)
    try {
      _likedPlaylist = _allPlaylists.firstWhere((p) => p.isDef == 2);
    } catch (_) {
      _likedPlaylist = null;
    }
  }
}
