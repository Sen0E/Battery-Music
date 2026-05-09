import 'package:battery_music/models/response/top_card.dart';
import 'package:battery_music/presentation/providers/home_page_provider.dart';
import 'package:battery_music/presentation/widgets/loading/skeleton_widgets.dart';
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
      return const _DailyPlaylistsSkeleton();
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
                    child: Image.network(
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
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  playlist.specialname,
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
                  playlist.nickname,
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
      return const _TrackCardsSkeleton();
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
      return _CategoryListSkeleton(title: title);
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
      return item.songname;
    } else if (item is SongItem) {
      return item.songname ?? item.filename ?? '未知歌曲';
    }
    return '未知歌曲';
  }
}

class _DailyPlaylistsSkeleton extends StatelessWidget {
  const _DailyPlaylistsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: SkeletonPulse(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          itemBuilder: (context, index) => const _PlaylistCardSkeleton(),
        ),
      ),
    );
  }
}

class _PlaylistCardSkeleton extends StatelessWidget {
  const _PlaylistCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 160, height: 160, radius: 12),
          SizedBox(height: 12),
          SkeletonBox(width: 138, height: 13),
          SizedBox(height: 8),
          SkeletonBox(width: 92, height: 10),
        ],
      ),
    );
  }
}

class _TrackCardsSkeleton extends StatelessWidget {
  const _TrackCardsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: SkeletonPulse(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemBuilder: (context, index) {
            return const Column(
              children: [
                _TrackCardSkeleton(),
                SizedBox(height: 16),
                _TrackCardSkeleton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TrackCardSkeleton extends StatelessWidget {
  const _TrackCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          SkeletonBox(width: 48, height: 48, radius: 6),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonBox(width: double.infinity, height: 13),
                SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 0.56,
                  child: SkeletonBox(width: double.infinity, height: 10),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          SkeletonCircle(size: 32),
        ],
      ),
    );
  }
}

class _CategoryListSkeleton extends StatelessWidget {
  const _CategoryListSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          SkeletonPulse(
            child: Column(
              children: List.generate(7, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 6 ? 0 : 16),
                  child: const Row(
                    children: [
                      SkeletonBox(width: 24, height: 14, radius: 4),
                      SizedBox(width: 12),
                      Expanded(
                        child: SkeletonBox(width: double.infinity, height: 12),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
