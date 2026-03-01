// import 'package:battery_music/presentation/page/playlist_detail_page.dart';
// import 'package:battery_music/presentation/providers/playlist_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /// 收藏歌单页面
// /// 展示用户收藏的歌单详情，复用 PlaylistDetailPage
// class FavoritePage extends StatelessWidget {
//   const FavoritePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final playlistProvider = context.watch<PlaylistProvider>();
//     final favoritePlaylist = playlistProvider.favoritePlaylist;

//     if (favoritePlaylist == null) {
//       return const Center(child: Text("未找到收藏歌单"));
//     }

//     // 复用 PlaylistDetailPage，传入 globalId
//     return PlaylistDetailPage(
//       listId: favoritePlaylist.listid ?? 0,
//       playlistName: "收藏",
//     );
//   }
// }
