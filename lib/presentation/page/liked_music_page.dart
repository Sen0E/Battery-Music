import 'package:battery_music/presentation/page/playlist_detail_page.dart';
import 'package:battery_music/presentation/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// “我喜欢的音乐”页面
/// 展示用户“我喜欢的音乐”歌单详情，复用 PlaylistDetailPage
class LikedMusicPage extends StatelessWidget {
  const LikedMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlaylistProvider>();
    final likedPlaylist = playlistProvider.likedPlaylist;

    if (likedPlaylist == null) {
      return const Center(child: Text("未找到喜欢音乐歌单"));
    }

    // 复用 PlaylistDetailPage，传入 globalId
    return PlaylistDetailPage(
      listId: likedPlaylist.listId ?? 0,
      playlistName: "喜欢音乐",
    );
  }
}
