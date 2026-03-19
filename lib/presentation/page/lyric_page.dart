import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LyricLine {
  final Duration time;
  final String text;
  LyricLine(this.time, this.text);
}

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen>
    with TickerProviderStateMixin {
  final List<LyricLine> lyrics = [
    LyricLine(const Duration(seconds: 0), "Welcome to the interactive preview"),
    LyricLine(
      const Duration(seconds: 3, milliseconds: 500),
      "This is a demonstration of Apple Music's lyrics effect",
    ),
    LyricLine(
      const Duration(seconds: 7),
      "Notice the smooth gradient masks at the top and bottom",
    ),
    LyricLine(
      const Duration(seconds: 11, milliseconds: 500),
      "It prevents the text from hard-cutting at the edges",
    ),
    LyricLine(
      const Duration(seconds: 16),
      "Watch how the active line scales up",
    ),
    LyricLine(
      const Duration(seconds: 19, milliseconds: 500),
      "And becomes bright and perfectly focused",
    ),
    LyricLine(
      const Duration(seconds: 23),
      "While the surrounding lines fade back",
    ),
    LyricLine(
      const Duration(seconds: 27),
      "With reduced opacity and a slight blur",
    ),
    LyricLine(
      const Duration(seconds: 31),
      "Try clicking on any lyric line to jump",
    ),
    LyricLine(
      const Duration(seconds: 35),
      "Observe the Jelly Scroll elastic effect",
    ),
    LyricLine(
      const Duration(seconds: 39),
      "Lines lag behind and snap into place like a spring",
    ),
    LyricLine(
      const Duration(seconds: 44),
      "Making the motion feel physical and premium",
    ),
    LyricLine(const Duration(seconds: 49), "Enjoy the music... 🎵"),
    LyricLine(const Duration(seconds: 54), ""),
  ];

  late final ScrollController _scrollController;

  bool _isPlaying = false;
  Duration _currentTime = Duration.zero;

  // 物理引擎核心：高帧率时钟
  late final Ticker _physicsTicker;
  final double _itemHeight = 80.0;
  double _viewportHeight = 0.0;

  // --- 全新加入的纯物理滚动状态 ---
  double _scrollTargetY = 0.0;
  double _scrollCurrentY = 0.0;
  double _scrollVelocityY = 0.0;
  bool _isPhysicsScrolling = false;

  // 物理引擎数组：为每一行分配独立的 Y 轴物理偏移和速度
  late List<double> _linePhysicsY;
  late List<double> _linePhysicsV;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 初始化物理引擎状态
    _linePhysicsY = List.filled(lyrics.length, 0.0);
    _linePhysicsV = List.filled(lyrics.length, 0.0);

    // 启动全局物理时钟 (约 60fps)
    _physicsTicker = createTicker((elapsed) {
      if (!mounted) return;
      bool needsRepaint = false;

      // 1. 处理播放时间推进
      if (_isPlaying) {
        _currentTime += const Duration(milliseconds: 16);
        _checkActiveLine();
        needsRepaint = true;
      }

      // 2. 核心：果冻弹簧物理运算
      if (_scrollController.hasClients && _viewportHeight > 0) {
        double currentVelocity = 0.0;

        // 【核心大修复】：为列表主轴注入和 HTML 一模一样的弹簧阻尼模型！
        // 彻底消灭原生动画“起步速度过快”造成的突变
        if (_isPhysicsScrolling) {
          double diffScroll = _scrollTargetY - _scrollCurrentY;
          _scrollVelocityY += diffScroll * 0.0012; // 极缓的启动张力
          _scrollVelocityY *= 0.96; // 巨大的阻尼摩擦力
          _scrollCurrentY += _scrollVelocityY;

          if (_scrollVelocityY.abs() < 0.05 && diffScroll.abs() < 0.5) {
            _scrollCurrentY = _scrollTargetY;
            _scrollVelocityY = 0.0;
            _isPhysicsScrolling = false;
          }

          _scrollController.jumpTo(_scrollCurrentY);
          currentVelocity = _scrollVelocityY;
        } else {
          // 如果系统处于静止，或用户正在手动拖拽
          double offset = _scrollController.offset;
          currentVelocity = offset - _scrollCurrentY;
          _scrollCurrentY = offset;
        }

        // 【完美还原】：带距离系数的弹性形变，有了上面平缓的速度铺垫，
        // 这里的拉伸会像缓慢呼吸一样展开，再柔和地收拢。
        for (int i = 0; i < lyrics.length; i++) {
          double itemOffset = i * _itemHeight;
          double distanceFromCenter = itemOffset - _scrollCurrentY;
          double normalizedDistance =
              (distanceFromCenter / (_viewportHeight / 2)).clamp(-1.0, 1.0);

          double stretchFactor = 12.0;
          double targetJellyY =
              (currentVelocity * normalizedDistance * stretchFactor).clamp(
                -60.0,
                60.0,
              );

          double jellyDiff = targetJellyY - _linePhysicsY[i];
          _linePhysicsV[i] += jellyDiff * 0.015; // 张力
          _linePhysicsV[i] *= 0.92; // 阻尼

          double newY = _linePhysicsY[i] + _linePhysicsV[i];

          if ((newY - _linePhysicsY[i]).abs() > 0.05 ||
              currentVelocity.abs() > 0.01) {
            needsRepaint = true;
          }
          _linePhysicsY[i] = newY;
        }
      }

      if (needsRepaint) {
        setState(() {});
      }
    });

    _physicsTicker.start(); // 引擎常驻运行
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _physicsTicker.dispose();
    super.dispose();
  }

  void _checkActiveLine() {
    int newActiveIndex = -1;
    for (int i = 0; i < lyrics.length; i++) {
      if (_currentTime >= lyrics[i].time &&
          (i == lyrics.length - 1 || _currentTime < lyrics[i + 1].time)) {
        newActiveIndex = i;
        break;
      }
    }

    if (_currentTime >= const Duration(seconds: 55)) {
      _stopPlay();
      return;
    }

    if (newActiveIndex != -1 && lyrics[newActiveIndex].text.isNotEmpty) {
      final targetOffset = newActiveIndex * _itemHeight;
      if (_scrollTargetY != targetOffset) {
        _scrollToIndex(newActiveIndex);
      }
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _stopPlay() {
    setState(() {
      _isPlaying = false;
      _currentTime = Duration.zero;
    });
    _scrollToIndex(0);
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final targetOffset = index * _itemHeight;
    _scrollTargetY = targetOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    // 唤醒纯物理引擎进行滚动追踪
    _isPhysicsScrolling = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.5,
                  colors: [Color(0xFF8A2BE2), Color(0xFF4B0082), Colors.black],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "NOW PLAYING",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),

              Expanded(
                flex: 7,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _viewportHeight = constraints.maxHeight;
                    final paddingVertical =
                        _viewportHeight / 2 - (_itemHeight / 2);

                    return ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.15, 0.85, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      // 使用 NotificationListener 完美隔离自动滚动和手动拖拽冲突
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollStartNotification &&
                              notification.dragDetails != null) {
                            // 当用户手指放上屏幕进行主动滑动时，立刻打断物理引擎自动寻路
                            _isPhysicsScrolling = false;
                          }
                          return false;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: paddingVertical,
                          ),
                          itemCount: lyrics.length,
                          itemBuilder: (context, index) {
                            if (lyrics[index].text.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return _buildLyricLine(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: LinearProgressIndicator(
                          value:
                              _currentTime.inMilliseconds /
                              const Duration(seconds: 55).inMilliseconds,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        iconSize: 56,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlay,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLyricLine(int index) {
    final line = lyrics[index];

    final double itemOffset = index * _itemHeight;
    double scrollOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    final double distanceFromCenter = itemOffset - scrollOffset;
    final double normalizedDistance =
        (distanceFromCenter / (_viewportHeight / 2)).clamp(-1.0, 1.0);

    final double jellyTranslationY = _linePhysicsY[index];

    final double scale =
        1.0 - (normalizedDistance.abs() * 0.15).clamp(0.0, 0.3);
    final double opacity =
        1.0 - (normalizedDistance.abs() * 0.8).clamp(0.0, 0.85);

    return GestureDetector(
      onTap: () {
        _currentTime = line.time;
        _scrollToIndex(index);
        if (!_isPlaying) _togglePlay();
      },
      child: Container(
        height: _itemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(0, jellyTranslationY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: opacity,
              child: Text(
                line.text,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
