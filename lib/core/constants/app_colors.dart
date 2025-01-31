// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF45BF7A, // Custom Green Swatch
    <int, Color>{
      50: Color(0xFFE3F6EC),
      100: Color(0xFFC1EBD4),
      200: Color(0xFF9DDEBA),
      300: Color(0xFF79D2A1),
      400: Color(0xFF5EC78D),
      500: Color(0xFF45BF7A), // Primary
      600: Color(0xFF3DAC71),
      700: Color(0xFF339763),
      800: Color(0xFF298254),
      900: Color(0xFF1A623C),
    },
  );
  static const Color primaryColor = Color(0xFF45BF7A);
  static const Color secondaryColor = Color(0xFFFFA726);
  static const Color accentColor = Color(0xFFFF4D4D);
  // Black and White Colors
  static const Color white = Color(0xFFF5F7F8);
  static const Color black = Color(0xFF4C585B);
  // Original Colors
  static const Color originalDarkThemeBg = Color(0xFF121212);
  static const Color originalLightThemeBg = Color(0XFFFEF7FF);
  // Background Colors
  static const Color lightColorBg = Color(0xFFF5F5F5);
  static const Color darkColorBg = Color(0xFF1E1E1E);
}
