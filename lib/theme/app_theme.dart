// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette — deep cosmic dark with electric violet & cyan accents
  static const Color background = Color(0xFF07070D);
  static const Color surface = Color(0xFF0F0F1A);
  static const Color card = Color(0xFF141422);
  static const Color accent = Color(0xFF7C3AED); // Electric violet
  static const Color accentGlow = Color(0xFF9D5FF3);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color pink = Color(0xFFFF2D78);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color divider = Color(0xFF1E1E35);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: cyan,
        surface: surface,
        background: background,
        onPrimary: textPrimary,
        onSurface: textPrimary,
      ),
      fontFamily: 'SF Pro Display',
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}

// Gradient definitions
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF07070D), Color(0xFF0D0B1A), Color(0xFF07070D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x557C3AED), Colors.transparent],
    radius: 0.8,
  );
}
