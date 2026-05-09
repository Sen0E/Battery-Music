import 'package:flutter/material.dart';

class SkeletonPulse extends StatefulWidget {
  const SkeletonPulse({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Opacity(opacity: 0.72 + (t * 0.2), child: child);
      },
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
    this.opacity = 0.12,
    this.margin,
    this.color,
    this.alignment = Alignment.centerLeft,
  });

  final double width;
  final double height;
  final double radius;
  final double opacity;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderOpacity = (opacity + 0.08).clamp(0.0, 1.0).toDouble();
    final box = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? colors.primary.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colors.primary.withValues(alpha: borderOpacity),
        ),
      ),
    );

    return width.isFinite ? Align(alignment: alignment, child: box) : box;
  }
}

class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    required this.size,
    this.opacity = 0.12,
    this.margin,
  });

  final double size;
  final double opacity;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      radius: size / 2,
      opacity: opacity,
      margin: margin,
    );
  }
}

class SkeletonSongRow extends StatelessWidget {
  const SkeletonSongRow({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.coverSize = 40,
    this.showIndex = true,
    this.showTrailing = true,
  });

  final EdgeInsetsGeometry padding;
  final double coverSize;
  final bool showIndex;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (showIndex) ...[
            const SkeletonBox(width: 24, height: 12, radius: 4),
            const SizedBox(width: 16),
          ],
          SkeletonBox(width: coverSize, height: coverSize, radius: 6),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonBox(width: double.infinity, height: 13),
                SizedBox(height: 9),
                FractionallySizedBox(
                  widthFactor: 0.52,
                  child: SkeletonBox(width: double.infinity, height: 10),
                ),
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 18),
            const SkeletonBox(width: 42, height: 12, radius: 4),
          ],
        ],
      ),
    );
  }
}
