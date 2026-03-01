import 'dart:async';

// import 'package:battery_music/core/services/user_service.dart';
import 'package:battery_music/core/services/v2/user_service.dart';
import 'package:battery_music/models/v2/response/search_suggest.dart';
import 'package:battery_music/presentation/components/window_controls.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
        context.read<SearchProvider>().fetchHotSearches();
      } else {
        // 关键：延迟关闭浮层。
        // 这为浮层内的点击事件（如点击建议项）提供了处理时间窗口，
        // 避免了因焦点立即丢失而导致浮层被移除，使得点击事件失效的问题。
        Future.delayed(const Duration(milliseconds: 200), () {
          // 延迟后再次检查，确保用户没有快速地重新聚焦到输入框上。
          if (!_searchFocusNode.hasFocus) {
            _removeOverlay();
          }
        });
      }
    });

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final keyword = _searchController.text;
        if (keyword.isNotEmpty) {
          context.read<SearchProvider>().fetchSearchSuggestions(keyword);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => SearchOverlay(
        layerLink: _layerLink,
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onSearch: _performSearch,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _performSearch(String keyword) {
    if (keyword.trim().isNotEmpty) {
      context.read<SearchProvider>().search(keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: DragToMoveArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SearchTextField(
                    layerLink: _layerLink,
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onSubmitted: _performSearch,
                  ),
                ),
              ),
              const Expanded(child: DragToMoveArea(child: SizedBox())),
              const UserInfoWidget(),
              const SizedBox(width: 20),
              const WindowControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String keyword) onSearch;

  const SearchOverlay({
    super.key,
    required this.layerLink,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchProvider = context.watch<SearchProvider>();
    final suggestions = searchProvider.searchSuggestions;
    final hotSearches = searchProvider.hotSearchCategories;

    final bool showSuggestions =
        searchController.text.isNotEmpty && suggestions.isNotEmpty;

    void handleTap(String keyword) {
      searchController.text = keyword;
      onSearch(keyword);
      // 点击后，让输入框失去焦点，这将触发 top_bar 中的延迟关闭逻辑
      searchFocusNode.unfocus();
    }

    return Positioned(
      width: 300,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 42),
        child: Material(
          elevation: 10,
          color: theme.cardTheme.color,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 450),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: showSuggestions
                ? _SearchSuggestions(suggestions: suggestions, onTap: handleTap)
                : _HotSearch(
                    hotSearchCategories: hotSearches,
                    isLoading: searchProvider.isLoading,
                    onTap: handleTap,
                  ),
          ),
        ),
      ),
    );
  }
}

class _HotSearch extends StatelessWidget {
  final List<dynamic> hotSearchCategories;
  final bool isLoading;
  final Function(String) onTap;

  const _HotSearch({
    required this.hotSearchCategories,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading && hotSearchCategories.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (hotSearchCategories.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text("暂无热搜内容", style: TextStyle(color: theme.hintColor)),
        ),
      );
    }

    final firstCategory = hotSearchCategories.first;
    final keywords = firstCategory.keywords ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _HotSearchHeader(title: firstCategory.name ?? "热门搜索"),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              final item = keywords[index];
              final keywordText = item.keyword ?? "";
              return _HotSearchItem(
                keyword: keywordText,
                rank: index + 1,
                onTap: () => onTap(keywordText),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  final List<RecordData> suggestions;
  final Function(String) onTap;

  const _SearchSuggestions({required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return InkWell(
          onTap: () => onTap(suggestion.hintInfo ?? ""),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              suggestion.hintInfo ?? "",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}

class _HotSearchHeader extends StatelessWidget {
  final String title;
  const _HotSearchHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _HotSearchItem extends StatelessWidget {
  final String keyword;
  final int rank;
  final VoidCallback onTap;

  const _HotSearchItem({
    required this.keyword,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTop3 = rank <= 3;

    return InkWell(
      onTap: onTap,
      hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                "$rank",
                style: TextStyle(
                  color: isTop3
                      ? theme.colorScheme.primary
                      : theme.disabledColor,
                  fontWeight: isTop3 ? FontWeight.w900 : FontWeight.normal,
                  fontStyle: isTop3 ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                keyword,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: isTop3 ? 1.0 : 0.8,
                  ),
                  fontWeight: isTop3 ? FontWeight.w500 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final LayerLink layerLink;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String value) onSubmitted;

  const SearchTextField({
    super.key,
    required this.layerLink,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFocus = focusNode.hasFocus;

    return CompositedTransformTarget(
      link: layerLink,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            onSubmitted(value);
            focusNode.unfocus();
          },
          cursorColor: theme.colorScheme.primary,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: "搜索音乐...",
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 18,
              color: hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserInfo(),
      builder: (context, snapshot) {
        String userName = "游客";
        String userInitials = "U";
        String userPicUrl = "";
        bool isVip = false;

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final userInfo = snapshot.data!;
          userName = userInfo['nickname'] ?? "游客";
          final name = userName.isNotEmpty ? userName : "游客";
          userInitials = name.isNotEmpty
              ? name.substring(0, 1).toUpperCase()
              : "U";
          userPicUrl = userInfo['avatarUrl'] ?? "";
          isVip = userInfo['VipType'] != 0;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              backgroundImage: userPicUrl.isNotEmpty
                  ? NetworkImage(userPicUrl)
                  : null,
              child: userPicUrl.isEmpty
                  ? Text(
                      userInitials,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              userName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            if (isVip) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "VIP",
                  style: TextStyle(
                    fontSize: 9,
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadUserInfo() async {
    // 使用新的 UserService 方法
    final nickname = UserService.getNickname;
    final avatarUrl = UserService.getAvatarUrl;
    final vipType = UserService.vipType;
    return {'nickname': nickname, 'avatarUrl': avatarUrl, 'VipType': vipType};
  }
}
