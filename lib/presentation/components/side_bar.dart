import 'package:battery_music/presentation/providers/player_ui_provider.dart';
import 'package:battery_music/presentation/providers/playlist_provider.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    super.initState();
    // 初始化时获取歌单数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaylistProvider>().fetchUserPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SidebarProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 220,
      color: colorScheme.surface,
      child: Column(
        children: [
          _buildLogo(theme),

          // 导航菜单区
          _buildMenuItem(
            context,
            0,
            Icons.recommend_rounded,
            "推荐",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            1,
            Icons.library_music_rounded,
            "乐库",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            2,
            Icons.queue_music_rounded,
            "歌单",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            3,
            Icons.radio_rounded,
            "频道",
            provider,
            theme,
          ),

          _buildDivider(theme),

          _buildMenuItem(
            context,
            4,
            Icons.favorite_rounded,
            "喜欢音乐",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            5,
            Icons.bookmark_rounded,
            "收藏",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            6,
            Icons.computer_rounded,
            "本地",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            7,
            Icons.grid_view_rounded,
            "其他",
            provider,
            theme,
          ),

          _buildDivider(theme),

          // 歌单列表区
          Expanded(child: _buildPlaylistList(context, provider, theme)),
        ],
      ),
    );
  }

  Widget _buildPlaylistList(
    BuildContext context,
    SidebarProvider provider,
    ThemeData theme,
  ) {
    final playlistProvider = context.watch<PlaylistProvider>();

    if (playlistProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (playlistProvider.errorMessage != null) {
      return Center(
        child: Text("加载失败", style: TextStyle(color: theme.colorScheme.error)),
      );
    }

    final playlists = playlistProvider.customPlaylists;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        // 歌单列表的索引从 8 开始，避免与上面的固定菜单冲突
        // 假设固定菜单有 8 个 (0-7)，那么歌单列表从 8 开始 ---------需要修改！！！！
        final menuIndex = 8 + index;

        return _buildMenuItem(
          context,
          menuIndex,
          Icons.queue_music_rounded, // 默认图标，也可以根据歌单类型设置
          playlist.name ?? "未知歌单",
          provider,
          theme,
          imageUrl: playlist.getCoverUrl(size: 60), // 传入封面URL
        );
      },
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      alignment: Alignment.centerLeft, // 桌面端通常左对齐看起来更整齐
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图标使用高亮主色
          Icon(
            Icons.music_note_rounded,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Battery',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900, // 更粗的字体更有质感
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Music',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    int index,
    IconData icon,
    String title,
    SidebarProvider provider,
    ThemeData theme, {
    String? imageUrl,
  }) {
    final isSelected = provider.selectedIndex == index;
    final colorScheme = theme.colorScheme;

    // 优先显示图片，否则显示图标
    Widget leadingWidget;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      leadingWidget = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          imageUrl,
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 图片加载失败时回退到图标
            return Icon(
              icon,
              size: 22,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            );
          },
        ),
      );
    } else {
      leadingWidget = Icon(
        icon,
        size: 22,
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            // 切换页面
            provider.setSelectedIndex(index);
            // 清除搜索结果，返回主视图
            context.read<SearchProvider>().clearResults();
          },
          selected: isSelected,

          selectedTileColor: colorScheme.primary,

          // 悬停效果
          hoverColor: colorScheme.onSurface.withValues(alpha: 0.05),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),

          leading: leadingWidget,

          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
