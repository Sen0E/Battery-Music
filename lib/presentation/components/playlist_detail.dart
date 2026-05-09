import 'package:battery_music/presentation/components/song_list_item.dart';
import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/playlist_detail_provider.dart';
import 'package:battery_music/presentation/widgets/loading/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 歌单详情页面
/// 展示指定歌单内的所有歌曲列表
class PlaylistDetailPage extends StatefulWidget {
  final String globalId;
  final String playlistName;

  const PlaylistDetailPage({
    super.key,
    required this.globalId,
    required this.playlistName,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant PlaylistDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 globalId 发生变化，重新获取数据
    if (oldWidget.globalId != widget.globalId) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 获取歌单详情数据
  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PlaylistDetailProvider>();
      provider.clearData(); // 清除之前的数据
      provider.fetchPlaylistDetail(widget.globalId);
    });
  }

  /// 滚动监听
  void _onScroll() {
    if (_isBottom) {
      _loadMore();
    }
  }

  /// 是否滚动到底部
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9); // 距离底部10%时开始加载
  }

  /// 加载更多数据
  void _loadMore() {
    final provider = context.read<PlaylistDetailProvider>();
    if (!provider.isLoadingMore && provider.hasMore) {
      provider.loadMoreSongs(widget.globalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlaylistDetailProvider>();
    final theme = Theme.of(context);

    return Scaffold(body: _buildBody(provider, theme));
  }

  /// 构建页面主体内容
  Widget _buildBody(PlaylistDetailProvider provider, ThemeData theme) {
    if (provider.isLoading) {
      return const _PlaylistDetailSkeleton();
    }

    if (provider.errorMessage != null && provider.songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "加载失败: ${provider.errorMessage}",
              style: TextStyle(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchData(),
              child: const Text("重新加载"),
            ),
          ],
        ),
      );
    }

    if (provider.songs.isEmpty) {
      return const Center(child: Text("歌单为空"));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: provider.songs.length + (provider.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // 如果是最后一个是加载指示器
              if (index >= provider.songs.length) {
                return const SkeletonPulse(
                  child: SkeletonSongRow(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                );
              }

              final song = provider.songs[index];
              final songNameParts = (song.name ?? '未知歌曲').split(' - ');
              return SongListItem(
                index: index,
                songName: songNameParts.length > 1
                    ? songNameParts.last
                    : songNameParts.first,
                singerName: songNameParts.length > 1
                    ? songNameParts.first
                    : '未知歌手',
                musicpackAdvance: song.transParam?.musicpackAdvance,
                coverUrl: song.getCoverUrl(),
                duration: song.timelen,
                isDurationInMs: true, // 歌单详情里的时长是毫秒
                onTap: () {
                  // 播放逻辑
                  context.read<AudioPlayerProvider>().playSong(
                    song,
                    playlist: provider.songs,
                    index: index,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaylistDetailSkeleton extends StatelessWidget {
  const _PlaylistDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: 14,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) => const SkeletonSongRow(),
      ),
    );
  }
}
