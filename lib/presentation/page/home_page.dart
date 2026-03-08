import 'package:battery_music/models/response/top_card.dart';
import 'package:battery_music/presentation/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:battery_music/models/response/top_song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 在组件初始化后获取所有首页数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomePageProvider>();
      // 直接调用 provider 中已经写好的全量拉取方法
      provider.fetchAllHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取主题信息
    final theme = Theme.of(context);

    // 【关键修复】使用 watch 监听状态变化，这样数据加载后 UI 才会重绘
    final provider = context.watch<HomePageProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== 1. 每日歌单推荐 (API) ==========
          _buildSectionHeader('每日歌单推荐', theme),
          const SizedBox(height: 20),
          _buildDailyPlaylists(provider, theme), // 传入 provider 而不是 context

          const SizedBox(height: 48),

          // ========== 2. 私人专属好歌 (API) ==========
          _buildSectionHeader('私人专属好歌', theme),
          const SizedBox(height: 20),
          _buildPersonalizedTracks(provider, theme), // 传入 provider 而不是 context

          const SizedBox(height: 48),

          // ========== 3. 探索音乐宇宙 (组合 4 个分类 API) ==========
          _buildSectionHeader('探索音乐宇宙', theme),
          const SizedBox(height: 20),
          _buildCategoryColumns(provider, theme), // 传入 provider

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyPlaylists(HomePageProvider provider, ThemeData theme) {
    if (provider.isLoadingPlaylists && provider.recommendedPlaylists.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorPlaylists != null &&
        provider.recommendedPlaylists.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            "加载失败: ${provider.errorPlaylists}",
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final playlists = provider.recommendedPlaylists.take(8).toList();
    if (playlists.isEmpty) {
      return const SizedBox(height: 220, child: Center(child: Text("暂无推荐歌单")));
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 160,
                    height: 160,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: playlist.getImgurl() != null
                        ? Image.network(
                            playlist.getImgurl(),
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.music_note,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 48,
                              );
                            },
                          )
                        : Icon(
                            Icons.album,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  playlist.specialname ?? '未知歌单',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  playlist.nickname ?? '未知用户',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalizedTracks(HomePageProvider provider, ThemeData theme) {
    if (provider.isLoadingCards && provider.personalizedSongs.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorCards != null && provider.personalizedSongs.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            "加载失败: ${provider.errorCards}",
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final songs = provider.personalizedSongs.take(10).toList();
    if (songs.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text("暂无私人专属好歌")),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length ~/ 2 + (songs.length % 2 > 0 ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final firstIndex = index * 2;
          final secondIndex = index * 2 + 1;

          return Column(
            children: [
              _buildTrackCard(
                songs[firstIndex].songname ?? '未知歌曲',
                songs[firstIndex].authorName ?? '未知艺术家',
                songs[firstIndex].getSizableCoverUrl(size: 96),
                firstIndex,
                theme,
              ),
              const SizedBox(height: 16),
              if (secondIndex < songs.length)
                _buildTrackCard(
                  songs[secondIndex].songname ?? '未知歌曲',
                  songs[secondIndex].authorName ?? '未知艺术家',
                  songs[secondIndex].getSizableCoverUrl(size: 96),
                  secondIndex,
                  theme,
                )
              else
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrackCard(
    String songName,
    String singerName,
    String? coverUrl,
    int index,
    ThemeData theme,
  ) {
    return Container(
      width: 280,
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: coverUrl != null && coverUrl.isNotEmpty
                ? Image.network(
                    coverUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 48,
                        height: 48,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.music_note,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  songName,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  singerName,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_fill,
            color: theme.colorScheme.primary,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryColumns(HomePageProvider provider, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildCategoryList(
            '新歌速递',
            provider.topNewSongs,
            provider,
            theme,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildCategoryList(
            '热门好歌精选',
            provider.hotSongs,
            provider,
            theme,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildCategoryList(
            '经典怀旧金曲',
            provider.nostalgicSongs,
            provider,
            theme,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildCategoryList(
            '小众宝藏佳作',
            provider.indieSongs,
            provider,
            theme,
          ),
        ),
      ],
    );
  }

  // 修改了签名，直接接收 provider 进行状态判断，不再使用 context.select
  Widget _buildCategoryList(
    String title,
    List<dynamic> items,
    HomePageProvider provider,
    ThemeData theme,
  ) {
    print("标题: $title, 数据总数: ${items.length}"); // 添加这行来调试
    bool isLoading = false;
    String? error;

    if (title == '新歌速递') {
      isLoading = provider.isLoadingNewSongs;
      error = provider.errorNewSongs;
    } else {
      isLoading = provider.isLoadingCategoryCards;
      error = provider.errorCategoryCards;
    }

    if (isLoading && items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      );
    }

    if (error != null && items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '加载失败: $error',
              style: TextStyle(color: theme.colorScheme.error, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < items.length && i < 9; i++) ...[
            Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: i < 3
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _getItemTitle(items[i]),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (i < items.length - 1)
              const SizedBox(height: 16), // 修改这里，确保所有项目之间都有间距
          ],
        ],
      ),
    );
  }

  String _getItemTitle(dynamic item) {
    if (item is TopSong) {
      return item.songname ?? '未知歌曲';
    } else if (item is SongItem) {
      return item.songname ?? item.filename ?? '未知歌曲';
    }
    return '未知歌曲';
  }
}
