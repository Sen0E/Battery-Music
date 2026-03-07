import 'package:flutter/material.dart';

// 假设这是你从截图中提取的品牌荧光绿
const Color brandAccentColor = Color(0xFFD4FF28);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 只需要提供一个可以垂直滚动的视图即可，不包含 Scaffold 和导航
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== 1. 每日歌单推荐 (API) ==========
          _buildSectionHeader('每日歌单推荐'),
          const SizedBox(height: 20),
          _buildDailyPlaylists(),

          const SizedBox(height: 48),

          // ========== 2. 私人专属好歌 (API) ==========
          _buildSectionHeader('私人专属好歌'),
          const SizedBox(height: 20),
          _buildPersonalizedTracks(),

          const SizedBox(height: 48),

          // ========== 3. 探索更多音乐 (组合 4 个分类 API) ==========
          _buildSectionHeader('探索音乐宇宙'),
          const SizedBox(height: 20),
          _buildCategoryColumns(),

          const SizedBox(height: 60), // 底部留白，防止内容贴底
        ],
      ),
    );
  }

  /// 统一的区块标题，带上你的品牌色点缀
  Widget _buildSectionHeader(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 品牌色小竖条
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: brandAccentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  /// 每日歌单推荐 (横向滑动的大方块卡片)
  Widget _buildDailyPlaylists() {
    return SizedBox(
      height: 220,
      // 注意：这里用回我们之前写好的 CustomHorizontalScrollView 来支持鼠标拖拽
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
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
                    color: Colors.white.withOpacity(0.05), // 占位背景色
                    child: Icon(
                      Icons.album,
                      color: Colors.white.withOpacity(0.2),
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '每日推荐歌单标题',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '为你量身定制',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
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

  /// 私人专属好歌 (横向滑动的长条形单曲卡片，排成两行)
  Widget _buildPersonalizedTracks() {
    return SizedBox(
      height: 160, // 容纳两行单曲卡片
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildTrackCard('专属单曲 ${index * 2 + 1}'),
              const SizedBox(height: 16),
              _buildTrackCard('专属单曲 ${index * 2 + 2}'),
            ],
          );
        },
      ),
    );
  }

  /// 单曲卡片 UI (长条形)
  Widget _buildTrackCard(String title) {
    return Container(
      width: 280,
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        // hover 效果可以后续通过 InkWell 添加
      ),
      child: Row(
        children: [
          // 歌曲封面
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 48,
              height: 48,
              color: Colors.white.withOpacity(0.1),
              child: const Icon(Icons.music_note, color: Colors.white54),
            ),
          ),
          const SizedBox(width: 16),
          // 歌曲信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '歌手名字',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 播放按钮使用你的品牌色
          Icon(
            Icons.play_circle_fill,
            color: brandAccentColor.withOpacity(0.8),
            size: 32,
          ),
        ],
      ),
    );
  }

  /// 对应 4 个分类 API 的网格布局 (新歌、经典、热门、小众)
  Widget _buildCategoryColumns() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildCategoryList('新歌速递')),
        const SizedBox(width: 24),
        Expanded(child: _buildCategoryList('热门好歌精选')),
        const SizedBox(width: 24),
        Expanded(child: _buildCategoryList('经典怀旧金曲')),
        const SizedBox(width: 24),
        Expanded(child: _buildCategoryList('小众宝藏佳作')),
      ],
    );
  }

  /// 构建单个分类下的迷你榜单
  Widget _buildCategoryList(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // 极淡的背景色区分区块
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // 列表项
          for (int i = 0; i < 4; i++) ...[
            Row(
              children: [
                // 排名数字
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      // 前三名使用品牌色高亮
                      color: i < 3
                          ? brandAccentColor
                          : Colors.white.withOpacity(0.3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 歌曲名
                Expanded(
                  child: Text(
                    'API返回的歌曲名称...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (i < 3) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
