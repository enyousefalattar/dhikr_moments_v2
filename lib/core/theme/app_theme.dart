import 'package:flutter/material.dart';

class AppTheme {
  // Morning Theme Data
  static final morningTheme = {
    'gradientColors': [const Color(0xFFFFF3E0), const Color(0xFFFFAB91)],
    'primaryColor': const Color(0xFFFF8F00),
    'cardColor': Colors.white.withValues(alpha: 0.9),
    'textColor': Colors.black87,
  };

  // Evening Theme Data
  static final eveningTheme = {
    'gradientColors': [const Color(0xFF1A237E), const Color(0xFF0D47A1)],
    'primaryColor': const Color(0xFF536DFE),
    'cardColor': Colors.white.withValues(alpha: 0.8),
    'textColor': Colors.white,
  };

  // Dark Morning Theme Data
  static final darkMorningTheme = {
    'gradientColors': [const Color(0xFF3E2723), const Color(0xFF5D4037)],
    'primaryColor': const Color(0xFFFFB74D),
    'cardColor': Colors.black.withValues(alpha: 0.6),
    'textColor': Colors.white,
  };

  // Dark Evening Theme Data
  static final darkEveningTheme = {
    'gradientColors': [const Color(0xFF000000), const Color(0xFF121212)],
    'primaryColor': const Color(0xFF7986CB),
    'cardColor': Colors.white.withValues(alpha: 0.1),
    'textColor': Colors.white,
  };
}
