import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowControls extends StatefulWidget {
  const WindowControls({super.key});

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // 监听窗口最大化状态，以便切换图标（最大化 vs 还原）
  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _WindowButton(
          icon: Icons.remove, // 最小化图标
          onPressed: () => windowManager.minimize(),
        ),
        FutureBuilder<bool>(
          future: windowManager.isMaximized(),
          initialData: false,
          builder: (context, snapshot) {
            final isMaximized = snapshot.data ?? false;
            return _WindowButton(
              // 根据状态切换图标：最大化时显示“还原”，否则显示“矩形”
              icon: isMaximized ? Icons.filter_none : Icons.crop_square,
              tooltip: isMaximized ? "还原" : "最大化",
              onPressed: () async {
                if (isMaximized) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
                setState(() {}); // 强制刷新图标状态
              },
            );
          },
        ),
        _WindowButton(
          icon: Icons.close,
          isCloseButton: true, // 标记为关闭按钮，会有红色特效
          onPressed: () => windowManager.close(),
        ),
      ],
    );
  }
}

/// 封装一个私有的按钮组件，处理悬停效果
class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCloseButton;
  final String? tooltip;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.isCloseButton = false,
    this.tooltip,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 定义颜色
    // 1. 关闭按钮：悬停变红，图标变白
    // 2. 普通按钮：悬停变微透明背景，图标跟随主题
    final hoverBackgroundColor = widget.isCloseButton
        ? const Color(0xFFE81123) // Windows 标准红 / 或用 theme.colorScheme.error
        : theme.colorScheme.onSurface.withValues(alpha: 0.1);

    final iconColor = widget.isCloseButton && _isHovering
        ? Colors.white
        : theme.colorScheme.onSurface; // 普通状态跟随主题文字颜色

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Tooltip(
        message: widget.tooltip ?? "",
        waitDuration: const Duration(seconds: 1),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 46, // 桌面端标准宽度通常在 40-50 之间
            height: 32, // 高度稍微压扁一点，显得更像 TitleBar 按钮
            decoration: BoxDecoration(
              color: _isHovering ? hoverBackgroundColor : Colors.transparent,
              // 桌面端通常不使用圆角，或者使用极小的圆角
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              widget.icon,
              size: 16, // 窗口图标不宜过大，16-18 为佳
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
