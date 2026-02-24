import 'package:battery_music/presentation/components/bottom_player_bar.dart';
import 'package:battery_music/presentation/components/side_bar.dart';
import 'package:battery_music/presentation/components/top_bar.dart';
import 'package:battery_music/presentation/page/favorite_page.dart';
import 'package:battery_music/presentation/page/liked_music_page.dart';
import 'package:battery_music/presentation/page/music_library_page.dart';
import 'package:battery_music/presentation/page/playlist_detail_page.dart';
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
    case 5:
      return const FavoritePage();
    default:
      // 处理歌单列表的点击
      if (selectedIndex >= 8) {
        final playlistProvider = context.read<PlaylistProvider>();
        final playlistIndex = selectedIndex - 8;
        if (playlistIndex < playlistProvider.customPlaylists.length) {
          final playlist = playlistProvider.customPlaylists[playlistIndex];
          // 复用 PlaylistDetailPage 显示普通歌单详情
          return PlaylistDetailPage(
            listId: playlist.listId ?? 0,
            playlistName: playlist.name ?? "歌单详情",
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