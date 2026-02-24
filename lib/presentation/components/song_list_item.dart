import 'package:flutter/material.dart';

/// 通用歌曲列表项组件
class SongListItem extends StatefulWidget {
  final int index;
  final String songName;
  final String singerName;
  final String? coverUrl;
  final int? duration; // 秒或毫秒，通过 isDurationInMs 区分
  final bool isDurationInMs; // 默认为 false (秒)，true 为毫秒
  final VoidCallback? onTap;

  const SongListItem({
    super.key,
    required this.index,
    required this.songName,
    required this.singerName,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),

          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 序号：只有在不悬停时显示，悬停时显示播放按钮
              Container(
                width: 24,
                alignment: Alignment.center,
                child: _isHovering
                    ? Icon(
                        Icons.play_arrow,
                        size: 20,
                        color: theme.colorScheme.primary,
                      )
                    : Text(
                        '${widget.index + 1}'.padLeft(2, '0'),
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 12,
                          fontFamily: 'Monospace',
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.coverUrl ?? '',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 36,
                    height: 36,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.music_note,
                      size: 20,
                      color: theme.disabledColor,
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
              color: _isHovering
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: _isHovering ? FontWeight.w500 : FontWeight.normal,
            ),
          ),

          subtitle: Text(
            widget.singerName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          trailing: Text(
            _formatDuration(widget.duration, widget.isDurationInMs),
            style: TextStyle(
              fontSize: 12,
              color: theme.disabledColor,
              // fontFamily: 'Monospace',
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
