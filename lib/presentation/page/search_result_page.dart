import 'package:battery_music/models/search_special_response.dart';
import 'package:battery_music/presentation/components/song_list_item.dart';
import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 搜索结果页面
/// 展示搜索关键词后的单曲和歌单结果，支持 Tab 切换
class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final searchProvider = context.read<SearchProvider>();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: searchProvider.searchTabIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        searchProvider.onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final keyword = searchProvider.currentKeyword;
    final theme = Theme.of(context);

    // 同步 Provider 状态
    if (_tabController.index != searchProvider.searchTabIndex) {
      _tabController.animateTo(searchProvider.searchTabIndex);
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // 保持背景通透
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // 透明背景
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80, // 增加高度容纳标题和 TabBar
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: keyword,
                    style: TextStyle(color: theme.colorScheme.primary), // 关键词高亮
                  ),
                  const TextSpan(text: ' 的搜索结果'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 将 TabBar 放在 Title 下方，不占用 Bottom 槽位，布局更灵活
            SizedBox(
              width: 200, // 限制 TabBar 宽度，左对齐
              height: 30,
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: theme.colorScheme.onSurface, // 选中文字颜色 (黑/白)
                unselectedLabelColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.5,
                ),
                indicatorColor: theme.colorScheme.primary, // 柠檬绿指示器
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                dividerColor: Colors.transparent, // 去掉默认底线
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: '单曲'),
                  Tab(text: '歌单'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSongResults(theme), _buildPlaylistResults(theme)],
      ),
    );
  }

  /// 构建歌单搜索结果列表
  Widget _buildPlaylistResults(ThemeData theme) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.playlistResults.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }
        if (provider.playlistResults.isEmpty) {
          return _buildEmptyState(theme, '没有找到相关歌单');
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // 检测是否滚动到底部并还有更多数据可加载
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                !provider.isLoading &&
                provider.hasMorePlaylists) {
              provider.searchPlaylists(isLoadMore: true);
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount:
                provider.playlistResults.length +
                (provider.isLoading && provider.hasMorePlaylists ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              // 如果是最后一个项目且还有更多数据，显示加载更多的提示
              if (index == provider.playlistResults.length &&
                  provider.isLoading &&
                  provider.hasMorePlaylists) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              return _PlaylistItemWidget(
                playlist: provider.playlistResults[index],
              );
            },
          ),
        );
      },
    );
  }

  /// 构建单曲搜索结果列表
  Widget _buildSongResults(ThemeData theme) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.songResults.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }
        if (provider.songResults.isEmpty) {
          return _buildEmptyState(theme, '没有找到相关歌曲');
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // 检测是否滚动到底部并还有更多数据可加载
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                !provider.isLoading &&
                provider.hasMoreSongs) {
              provider.searchSongs(isLoadMore: true);
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount:
                provider.songResults.length +
                (provider.isLoading && provider.hasMoreSongs ? 1 : 0),
            // 桌面端列表通常比较密集，不需要 excessive spacing
            itemExtent: 60,
            itemBuilder: (context, index) {
              // 如果是最后一个项目且还有更多数据，显示加载更多的提示
              if (index == provider.songResults.length &&
                  provider.isLoading &&
                  provider.hasMoreSongs) {
                return Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                    strokeWidth: 2,
                  ),
                );
              }

              final song = provider.songResults[index];
              return SongListItem(
                index: index,
                songName: song.songName ?? '未知歌曲',
                singerName: song.singerName ?? '未知歌手',
                coverUrl: song.image?.replaceAll('{size}', '100'),
                duration: song.duration,
                isDurationInMs: false, // 搜索结果是秒
                onTap: () {
                  // 播放逻辑
                  context.read<AudioPlayerProvider>().playSong(
                    song,
                    playlist: provider.songResults,
                    index: index,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// 构建空状态视图
  Widget _buildEmptyState(ThemeData theme, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: theme.hintColor)),
        ],
      ),
    );
  }
}

/// 歌单列表项组件
class _PlaylistItemWidget extends StatelessWidget {
  final PlaylistItem playlist;
  const _PlaylistItemWidget({required this.playlist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05), // 悬停背景
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ), // 微弱边框
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              playlist.getImageUrl(size: 100),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 48,
                height: 48,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(Icons.music_note, color: theme.iconTheme.color),
              ),
            ),
          ),
        ),
        title: Text(
          playlist.specialName ?? '未知歌单',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${playlist.songCount ?? 0}首  •  By ${playlist.nickname ?? '未知作者'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 16,
              color: theme.disabledColor,
            ),
            const SizedBox(width: 4),
            Text(
              playlist.formattedPlayCount,
              style: TextStyle(color: theme.disabledColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
