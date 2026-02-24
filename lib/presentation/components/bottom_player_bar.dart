import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomPlayerBar extends StatelessWidget {
  const BottomPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<AudioPlayerProvider>();
    final theme = Theme.of(context);

    // 检查播放列表是否为空，如果播放列表为空则隐藏底部栏
    if (playerProvider.playlist.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 左侧歌曲信息
          Expanded(child: _buildSongDetail(playerProvider, theme)),
          // 中间控制按钮
          Expanded(flex: 2, child: _buildPlayerControl(playerProvider, theme)),
          // 右侧音量与列表
          Expanded(child: _buildVolumeAndList(playerProvider, theme)),
        ],
      ),
    );
  }

  // 歌曲信息组件
  Widget _buildSongDetail(AudioPlayerProvider provider, ThemeData theme) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // TODO: 跳转到歌曲详情页
            },
            child: Container(
              width: 56, // 稍微缩小一点封面，让排版更透气
              height: 56,
              decoration: BoxDecoration(
                // 适配点：占位背景色
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: provider.currentCoverUrl != null
                    ? Image.network(
                        provider.currentCoverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.music_note_rounded,
                          color: theme.iconTheme.color?.withValues(alpha: 0.5),
                        ),
                      )
                    : Icon(
                        Icons.album_outlined,
                        color: theme.iconTheme.color?.withValues(alpha: 0.5),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.currentSongName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: theme.colorScheme.onSurface, // 适配文字颜色
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.currentSinger,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant, // 次级文字颜色
                ),
              ),
              const SizedBox(height: 6),
              // 适配点：桌面端建议使用 IconButton 获得自带的悬停效果
              Row(
                children: [
                  _buildHoverIcon(
                    Icons.favorite_border_rounded,
                    theme,
                    tooltip: "喜欢",
                  ),
                  const SizedBox(width: 4),
                  _buildHoverIcon(
                    Icons.chat_bubble_outline_rounded,
                    theme,
                    tooltip: "评论",
                  ),
                  const SizedBox(width: 4),
                  _buildHoverIcon(Icons.share_rounded, theme, tooltip: "分享"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建带 Hover 效果的小图标按钮
  Widget _buildHoverIcon(IconData icon, ThemeData theme, {String? tooltip}) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  // 播放控制组件
  Widget _buildPlayerControl(AudioPlayerProvider provider, ThemeData theme) {
    // 安全处理滑块数值，防止进度大于总时长导致崩溃
    final double maxDuration = provider.duration.inMilliseconds.toDouble();
    final double safeMax = maxDuration > 0 ? maxDuration : 1.0;
    final double safeValue = provider.position.inMilliseconds.toDouble().clamp(
      0.0,
      safeMax,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: provider.playPrevious,
              icon: Icon(
                Icons.skip_previous_rounded,
                size: 28,
                color: theme.colorScheme.onSurface,
              ),
              hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            const SizedBox(width: 16),

            // 适配点：核心 Cyber 播放按钮
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary, // 强力柠檬绿
                boxShadow: [
                  // 添加微弱的绿色发光效果
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                padding: const EdgeInsets.all(10),
                onPressed: provider.togglePlay,
                icon: Icon(
                  provider.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 32,
                  color: theme.colorScheme.onPrimary, // 黑色的图标产生极高对比度
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: provider.playNext,
              icon: Icon(
                Icons.skip_next_rounded,
                size: 28,
                color: theme.colorScheme.onSurface,
              ),
              hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // 进度条区域
        Row(
          children: [
            Text(
              _formatDuration(provider.position),
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'Monospace', // 等宽数字
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 3),
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.1,
                  ),
                  thumbColor: theme.colorScheme.primary,
                  overlayColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                ),
                child: Slider(
                  value: safeValue,
                  min: 0.0,
                  max: safeMax,
                  onChanged: (value) {
                    provider.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDuration(provider.duration),
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'Monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 音量控制与列表
  Widget _buildVolumeAndList(AudioPlayerProvider provider, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          provider.volume == 0
              ? Icons.volume_off_rounded
              : Icons.volume_up_rounded,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(
          width: 90, // 控制音量条宽度
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              // 音量条不需要像进度条那么抢眼，使用黑/白即可
              activeTrackColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.7,
              ),
              inactiveTrackColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.1,
              ),
              thumbColor: theme.colorScheme.onSurface,
              overlayColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            child: Slider(
              value: provider.volume,
              onChanged: (value) {
                provider.setVolume(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            // TODO: 打开右侧播放列表抽屉
          },
          tooltip: '播放列表',
          icon: Icon(
            Icons.queue_music_rounded,
            color: theme.colorScheme.onSurface,
          ),
          hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ],
    );
  }

  // 格式化时长
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
