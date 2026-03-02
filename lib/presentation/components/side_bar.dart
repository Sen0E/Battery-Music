import 'package:battery_music/models/response/user_playlist.dart';
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
  // 控制各类别展开/收起的状态
  bool _minePlaylistsExpanded = true;
  bool _likedPlaylistsExpanded = true;
  bool _albumsExpanded = true;

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
            Icons.computer_rounded,
            "本地",
            provider,
            theme,
          ),
          _buildMenuItem(
            context,
            6,
            Icons.grid_view_rounded,
            "其他",
            provider,
            theme,
          ),

          _buildDivider(theme),

          // 歌单列表区
          Expanded(child: _buildPlaylistSections(context, provider, theme)),
        ],
      ),
    );
  }

  Widget _buildPlaylistSections(
    BuildContext context,
    SidebarProvider provider,
    ThemeData theme,
  ) {
    final playlistProvider = context.watch<PlaylistProvider>();
    if (playlistProvider.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (playlistProvider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "加载失败: ${playlistProvider.errorMessage}",
            style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 获取各种类型的歌单
    final minePlaylists = playlistProvider.minePlaylist;
    final likedPlaylists = playlistProvider.likePlaylist;
    final albums = playlistProvider.albumslist;

    // 计算索引偏移量，前7个是固定的菜单项，所以歌单从索引7开始
    int currentIndex = 7;

    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0, // 去除阴影
          materialGapSize: 0, // 去除面板之间的缝隙
          dividerColor: Colors.transparent, // 去除分割线
          expandIconColor: theme.colorScheme.onSurfaceVariant,
          expansionCallback: (int panelIndex, bool isExpanded) {
            setState(() {
              switch (panelIndex) {
                case 0:
                  _minePlaylistsExpanded = isExpanded;
                  break;
                case 1:
                  _likedPlaylistsExpanded = isExpanded;
                  break;
                case 2:
                  _albumsExpanded = isExpanded;
                  break;
              }
            });
          },
          children: [
            // 我的歌单部分
            ExpansionPanel(
              backgroundColor: Colors.transparent, // 强制背景透明
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return _buildSectionHeader("我的歌单", isExpanded, theme);
              },
              body: _buildPlaylistItems(
                minePlaylists,
                currentIndex,
                provider,
                theme,
              ),
              isExpanded: _minePlaylistsExpanded,
            ),

            // 收藏的歌单部分
            ExpansionPanel(
              backgroundColor: Colors.transparent, // 强制背景透明
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return _buildSectionHeader("收藏歌单", isExpanded, theme);
              },
              body: _buildPlaylistItems(
                likedPlaylists,
                currentIndex + minePlaylists.length,
                provider,
                theme,
              ),
              isExpanded: _likedPlaylistsExpanded,
            ),

            // 收藏的专辑部分
            ExpansionPanel(
              backgroundColor: Colors.transparent, // 强制背景透明
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return _buildSectionHeader("收藏专辑", isExpanded, theme);
              },
              body: _buildPlaylistItems(
                albums,
                currentIndex + minePlaylists.length + likedPlaylists.length,
                provider,
                theme,
              ),
              isExpanded: _albumsExpanded,
            ),
          ],
        ),
      ),
    );
  }

  // 适配点 3：分类标题的赛博极简排版
  Widget _buildSectionHeader(String title, bool isExpanded, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title, // 如果你想更极客一点，可以在传入时使用 title.toUpperCase() (如果是英文)
        style: TextStyle(
          fontSize: 12, // 字号缩小，作为层级分类的标签
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0, // 增加字距，带来“控制面板”的疏离感
          color: theme.colorScheme.onSurfaceVariant.withOpacity(
            0.6,
          ), // 颜色调暗，不抢歌单列表的风头
        ),
      ),
    );
  }

  Widget _buildPlaylistItems(
    List<dynamic> playlists,
    int startIndex,
    SidebarProvider provider,
    ThemeData theme,
  ) {
    if (playlists.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        final menuIndex = startIndex + index;

        String name;
        String? imageUrl;

        if (playlist is SongListInfo) {
          name = playlist.name ?? "未知歌单";
          imageUrl = playlist.getCoverUrl(size: 60);
        } else {
          name = playlist.toString();
          imageUrl = null;
        }

        return _buildMenuItem(
          context,
          menuIndex,
          Icons.queue_music_rounded,
          name,
          provider,
          theme,
          imageUrl: imageUrl,
        );
      },
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      alignment: Alignment.centerLeft,
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
              fontWeight: FontWeight.w900,
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
