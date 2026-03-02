import 'package:battery_music/presentation/components/bottom_player_bar.dart';
import 'package:battery_music/presentation/components/side_bar.dart';
import 'package:battery_music/presentation/components/top_bar.dart';
import 'package:battery_music/presentation/page/liked_music_page.dart';
import 'package:battery_music/presentation/page/music_library_page.dart';
import 'package:battery_music/presentation/components/playlist_detail.dart';
import 'package:battery_music/presentation/page/recommended_page.dart';
import 'package:battery_music/presentation/page/search_result_page.dart';
import 'package:battery_music/presentation/providers/player_ui_provider.dart';
import 'package:battery_music/presentation/providers/playlist_provider.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const SideBar(),
                Expanded(
                  child: Column(
                    children: [
                      const TopBar(),
                      Expanded(child: _buildContent(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomPlayerBar(),
        ],
      ),
    );
  }
}

Widget _buildContent(BuildContext context) {
  final searchProvider = context.watch<SearchProvider>();

  // 优先显示搜索结果页
  if (searchProvider.currentKeyword.isNotEmpty) {
    return const SearchResultPage();
  }

  final selectedIndex = context.watch<SidebarProvider>().selectedIndex;

  // 根据侧边栏选择显示不同页面
  switch (selectedIndex) {
    case 0:
      return const RecommendedPage();
    case 1:
      return const MusicLibraryPage();
    case 4:
      return const LikedMusicPage();
    default:
      // 处理歌单列表的点击
      // 前面的菜单项占用了 0-6 的索引，所以歌单项从索引 8 开始
      if (selectedIndex >= 7) {
        final playlistProvider = context.read<PlaylistProvider>();

        // 计算在歌单区域内的索引
        int playlistIndex = selectedIndex - 7;

        // 获取各个类型的歌单
        final minePlaylist = playlistProvider.minePlaylist;
        final likePlaylist = playlistProvider.likePlaylist;
        final albums = playlistProvider.albumslist;

        // 检查是否在我的歌单范围内
        if (playlistIndex < minePlaylist.length) {
          final playlist = minePlaylist[playlistIndex];
          return PlaylistDetailPage(
            globalId: playlist.globalCollectionId ?? "",
            playlistName: playlist.name ?? "歌单详情",
          );
        }

        // 检查是否在收藏的歌单范围内
        playlistIndex -= minePlaylist.length;
        if (playlistIndex < likePlaylist.length) {
          final playlist = likePlaylist[playlistIndex];
          return PlaylistDetailPage(
            globalId: playlist.globalCollectionId ?? "",
            playlistName: playlist.name ?? "歌单详情",
          );
        }

        // 检查是否在收藏的专辑范围内
        playlistIndex -= likePlaylist.length;
        if (playlistIndex < albums.length) {
          final album = albums[playlistIndex];
          return PlaylistDetailPage(
            globalId: album.globalCollectionId ?? "",
            playlistName: album.name ?? "专辑详情",
          );
        }
      }

      return Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Text(
            "页面 $selectedIndex 待开发",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
  }
}
