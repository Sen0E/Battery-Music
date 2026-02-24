import 'package:flutter/material.dart';

class AppTheme {
  // 核心品牌色定义
  // 这种高亮绿在深色和浅色模式下都需要搭配黑色文本才能保证可读性
  static const Color _primaryBrand = Color(0xFFC8EB21);
  static const Color _onPrimary = Colors.black; // 按钮上的文字颜色

  // 浅色模式色彩 (Light Palette)
  // 使用微带灰调的白色，减少桌面端大屏的刺眼感
  static const Color _lightBackground = Color(0xFFF9FAFB);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightTextPrimary = Color(0xFF111827);
  // static const Color _lightTextSecondary = Color(0xFF6B7280);

  // 深色模式色彩 (Dark Palette)
  // 不使用纯黑(000000)，而是使用有质感的深灰，减轻视觉疲劳
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkTextPrimary = Color(0xFFF3F4F6);
  // static const Color _darkTextSecondary = Color(0xFF9CA3AF);

  // --- 浅色主题 Theme ---
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 基础色彩方案
      colorScheme: const ColorScheme.light(
        primary: _primaryBrand,
        onPrimary: _onPrimary,
        secondary: Color(0xFF4B5563), // 辅助色使用沉稳的中性灰
        onSecondary: Colors.white,
        surface: _lightSurface,
        onSurface: _lightTextPrimary,
        error: Color(0xFFEF4444),
      ),

      // 字体配置
      fontFamily: 'HarmonyOS Sans SC',

      // 背景色
      scaffoldBackgroundColor: _lightBackground,

      // AppBar 样式
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      // 卡片样式
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // 按钮样式
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBrand,
          foregroundColor: _onPrimary, // 确保按钮文字是黑色的
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // 输入框样式
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryBrand, width: 2),
        ),
      ),
    );
  }

  // --- 深色主题 Theme ---
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // 基础色彩方案
      colorScheme: const ColorScheme.dark(
        primary: _primaryBrand,
        onPrimary: _onPrimary,
        secondary: Color(0xFF9CA3AF),
        onSecondary: Colors.black,
        surface: _darkSurface,
        onSurface: _darkTextPrimary,
        error: Color(0xFFCF6679),
      ),

      // 字体配置
      fontFamily: 'HarmonyOS Sans SC',

      scaffoldBackgroundColor: _darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        // 深色模式下通常使用边框或者更亮的表面色来区分，而不是阴影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBrand,
          foregroundColor: _onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryBrand, width: 2),
        ),
      ),

      // 桌面端滚动条样式优化
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          _primaryBrand.withValues(alpha: 0.4),
        ),
        trackColor: WidgetStateProperty.all(
          Colors.white.withValues(alpha: 0.05),
        ),
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(8),
      ),
    );
  }
}
