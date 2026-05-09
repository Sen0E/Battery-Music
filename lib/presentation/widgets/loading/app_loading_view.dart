import 'package:flutter/material.dart';

class AppLoadingView extends StatefulWidget {
  const AppLoadingView({super.key});

  @override
  State<AppLoadingView> createState() => _AppLoadingViewState();
}

class _AppLoadingViewState extends State<AppLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_controller.value);
        final glowOpacity = 0.18 + (t * 0.16);
        final lineOpacity = 0.08 + (t * 0.1);

        return ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                _TopStrip(colors: colors, lineOpacity: lineOpacity),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Row(
                      children: [
                        _SidebarSkeleton(
                          colors: colors,
                          lineOpacity: lineOpacity,
                          glowOpacity: glowOpacity,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              _HeaderSkeleton(
                                colors: colors,
                                lineOpacity: lineOpacity,
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: _ContentSkeleton(
                                  colors: colors,
                                  lineOpacity: lineOpacity,
                                  glowOpacity: glowOpacity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _BottomPlayerSkeleton(
                  colors: colors,
                  lineOpacity: lineOpacity,
                  glowOpacity: glowOpacity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopStrip extends StatelessWidget {
  const _TopStrip({required this.colors, required this.lineOpacity});

  final ColorScheme colors;
  final double lineOpacity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          _SkeletonBox(
            width: 160,
            height: 20,
            colors: colors,
            opacity: lineOpacity + 0.08,
          ),
          const Spacer(),
          _SkeletonBox(
            width: 110,
            height: 36,
            colors: colors,
            opacity: lineOpacity,
          ),
          const SizedBox(width: 12),
          _SkeletonBox(
            width: 36,
            height: 36,
            colors: colors,
            opacity: lineOpacity,
          ),
          const SizedBox(width: 10),
          _SkeletonBox(
            width: 36,
            height: 36,
            colors: colors,
            opacity: lineOpacity,
          ),
        ],
      ),
    );
  }
}

class _SidebarSkeleton extends StatelessWidget {
  const _SidebarSkeleton({
    required this.colors,
    required this.lineOpacity,
    required this.glowOpacity,
  });

  final ColorScheme colors;
  final double lineOpacity;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SkeletonBox(
            width: 120,
            height: 18,
            colors: colors,
            opacity: lineOpacity + 0.08,
          ),
          const SizedBox(height: 18),
          _SidebarBlock(
            colors: colors,
            lineOpacity: lineOpacity,
            glowOpacity: glowOpacity,
            titleWidth: 88,
          ),
          const SizedBox(height: 14),
          _SidebarBlock(
            colors: colors,
            lineOpacity: lineOpacity,
            glowOpacity: glowOpacity,
            titleWidth: 110,
          ),
          const SizedBox(height: 14),
          _SidebarBlock(
            colors: colors,
            lineOpacity: lineOpacity,
            glowOpacity: glowOpacity,
            titleWidth: 78,
          ),
        ],
      ),
    );
  }
}

class _SidebarBlock extends StatelessWidget {
  const _SidebarBlock({
    required this.colors,
    required this.lineOpacity,
    required this.glowOpacity,
    required this.titleWidth,
  });

  final ColorScheme colors;
  final double lineOpacity;
  final double glowOpacity;
  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: glowOpacity),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SkeletonBox(
            width: titleWidth,
            height: 14,
            colors: colors,
            opacity: lineOpacity + 0.12,
          ),
          const SizedBox(height: 14),
          for (final width in [0.86, 0.7, 0.9, 0.64])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SkeletonBox(
                width: 200,
                height: 10,
                colors: colors,
                opacity: lineOpacity,
                widthFactor: width,
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton({
    required this.colors,
    required this.lineOpacity,
  });

  final ColorScheme colors;
  final double lineOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          _SkeletonBox(
            width: 56,
            height: 56,
            colors: colors,
            opacity: lineOpacity + 0.14,
            radius: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SkeletonBox(
                  width: 180,
                  height: 16,
                  colors: colors,
                  opacity: lineOpacity + 0.08,
                ),
                const SizedBox(height: 10),
                _SkeletonBox(
                  width: 280,
                  height: 10,
                  colors: colors,
                  opacity: lineOpacity,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _SkeletonBox(
            width: 120,
            height: 38,
            colors: colors,
            opacity: lineOpacity,
          ),
        ],
      ),
    );
  }
}

class _ContentSkeleton extends StatelessWidget {
  const _ContentSkeleton({
    required this.colors,
    required this.lineOpacity,
    required this.glowOpacity,
  });

  final ColorScheme colors;
  final double lineOpacity;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: constraints.maxWidth < 900 ? 220 : 240,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: glowOpacity),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _SkeletonBox(
                      width: double.infinity,
                      height: double.infinity,
                      colors: colors,
                      opacity: lineOpacity + 0.08,
                      radius: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SkeletonBox(
                    width: 120,
                    height: 12,
                    colors: colors,
                    opacity: lineOpacity + 0.08,
                  ),
                  const SizedBox(height: 8),
                  _SkeletonBox(
                    width: 84,
                    height: 10,
                    colors: colors,
                    opacity: lineOpacity,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BottomPlayerSkeleton extends StatelessWidget {
  const _BottomPlayerSkeleton({
    required this.colors,
    required this.lineOpacity,
    required this.glowOpacity,
  });

  final ColorScheme colors;
  final double lineOpacity;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          _SkeletonBox(
            width: 56,
            height: 56,
            colors: colors,
            opacity: lineOpacity + 0.14,
            radius: 14,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SkeletonBox(
                  width: 180,
                  height: 14,
                  colors: colors,
                  opacity: lineOpacity + 0.08,
                ),
                const SizedBox(height: 10),
                _SkeletonBox(
                  width: 120,
                  height: 10,
                  colors: colors,
                  opacity: lineOpacity,
                ),
                const SizedBox(height: 12),
                _SkeletonBox(
                  width: double.infinity,
                  height: 8,
                  colors: colors,
                  opacity: glowOpacity,
                  radius: 999,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _SkeletonBox(
            width: 132,
            height: 40,
            colors: colors,
            opacity: lineOpacity,
            radius: 20,
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.colors,
    required this.opacity,
    this.radius = 12,
    this.widthFactor,
  });

  final double width;
  final double height;
  final ColorScheme colors;
  final double opacity;
  final double radius;
  final double? widthFactor;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = widthFactor == null ? width : width * widthFactor!;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: effectiveWidth,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: colors.primary.withValues(alpha: opacity),
          border: Border.all(
            color: colors.primary.withValues(alpha: opacity + 0.1),
          ),
        ),
      ),
    );
  }
}
