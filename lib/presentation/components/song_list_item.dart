import 'package:flutter/material.dart';

/// 通用歌曲列表项组件
class SongListItem extends StatefulWidget {
  final int index;
  final String songName;
  final String singerName;
  final int? musicpackAdvance;
  final String? coverUrl;
  final int? duration; // 秒或毫秒，通过 isDurationInMs 区分
  final bool isDurationInMs; // 默认为 false (秒)，true 为毫秒
  final VoidCallback? onTap;

  const SongListItem({
    super.key,
    required this.index,
    required this.songName,
    required this.singerName,
    this.musicpackAdvance,
    this.coverUrl,
    this.duration,
    this.isDurationInMs = false,
    this.onTap,
  });

  @override
  State<SongListItem> createState() => _SongListItemState();
}

class _SongListItemState extends State<SongListItem> {
  bool _isHovering = false;

  String _formatDuration(int? duration, bool isMs) {
    if (duration == null) return '00:00';
    final d = isMs
        ? Duration(milliseconds: duration)
        : Duration(seconds: duration);
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // @override
  // Widget build(BuildContext context) {
  //   final theme = Theme.of(context);

  //   return MouseRegion(
  //     onEnter: (_) => setState(() => _isHovering = true),
  //     onExit: (_) => setState(() => _isHovering = false),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: ListTile(
  //         dense: true,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //         hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 12),

  //         leading: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // 序号：只有在不悬停时显示，悬停时显示播放按钮
  //             Container(
  //               width: 24,
  //               alignment: Alignment.center,
  //               child: _isHovering
  //                   ? Icon(
  //                       Icons.play_arrow,
  //                       size: 20,
  //                       color: theme.colorScheme.primary,
  //                     )
  //                   : Text(
  //                       '${widget.index + 1}'.padLeft(2, '0'),
  //                       style: TextStyle(
  //                         color: theme.disabledColor,
  //                         fontSize: 12,
  //                         fontFamily: 'Monospace',
  //                       ),
  //                     ),
  //             ),
  //             const SizedBox(width: 12),
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(4),
  //               child: Image.network(
  //                 widget.coverUrl ?? '',
  //                 width: 36,
  //                 height: 36,
  //                 fit: BoxFit.cover,
  //                 errorBuilder: (_, _, _) => Container(
  //                   width: 36,
  //                   height: 36,
  //                   color: theme.colorScheme.surfaceContainerHighest,
  //                   child: Icon(
  //                     Icons.music_note,
  //                     size: 20,
  //                     color: theme.disabledColor,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),

  //         title: Text(
  //           widget.songName,
  //           overflow: TextOverflow.ellipsis,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: _isHovering
  //                 ? theme.colorScheme.primary
  //                 : theme.colorScheme.onSurface,
  //             fontWeight: _isHovering ? FontWeight.w500 : FontWeight.normal,
  //           ),
  //         ),

  //         subtitle: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             if (widget.musicpackAdvance == 1) ...[
  //               Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 6,
  //                   vertical: 2,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: Colors.red,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: Text(
  //                   'VIP',
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 6),
  //             ],
  //             Text(
  //               widget.singerName,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
  //               ),
  //             ),
  //           ],
  //         ),

  //         trailing: Text(
  //           _formatDuration(widget.duration, widget.isDurationInMs),
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: theme.disabledColor,
  //             // fontFamily: 'Monospace',
  //           ),
  //         ),
  //         onTap: widget.onTap,
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          // 桌面端通常圆角小一点显得更硬朗
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          // 悬停颜色：使用半透明的文字色，适配深/浅模式
          hoverColor: colorScheme.onSurface.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),

          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 序号 / 播放图标
              Container(
                width: 24,
                alignment: Alignment.center,
                child: _isHovering
                    ? Icon(
                        Icons.play_arrow_rounded,
                        size: 22,
                        color: colorScheme.primary, // 悬停时播放图标为亮绿色
                      )
                    : Text(
                        '${widget.index + 1}'.padLeft(2, '0'),
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 12,
                          fontFamily: 'Monospace', // 启用等宽字体，增加数据感
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // 封面图
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    widget.coverUrl ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 40,
                      height: 40,
                      color: colorScheme.surfaceVariant, // 占位色
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 20,
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          title: Text(
            widget.songName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              // 悬停时标题变绿，未悬停时跟随主题色
              color: _isHovering ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- VIP 标签适配 ---
                if (widget.musicpackAdvance == 1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1, // 稍微紧凑一点
                    ),
                    decoration: BoxDecoration(
                      // 修改点：VIP 背景改为主题主色 (柠檬绿)
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'VIP',
                      style: TextStyle(
                        fontSize: 9, // 字号调小显精致
                        // 修改点：在亮绿背景上，必须用黑色文字
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w900, // 极粗字体
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // 歌手名
                Flexible(
                  child: Text(
                    widget.singerName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 时长
          trailing: Text(
            _formatDuration(widget.duration, widget.isDurationInMs),
            style: TextStyle(
              fontSize: 12,
              color: theme.disabledColor,
              fontFamily: 'Monospace', // 启用等宽字体，对齐更漂亮
              letterSpacing: -0.5,
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
