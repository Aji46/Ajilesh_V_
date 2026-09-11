import 'package:flutter/material.dart';

/// Central color palette for the portfolio — dark, techy theme with a
/// cyan/violet accent gradient (nods to both "Flutter" and "Cyber Security").
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF121826);
  static const Color surfaceLight = Color(0xFF1B2436);

  static const Color primary = Color(0xFF00B4D8);
  static const Color secondary = Color(0xFF6C3CE9);
  static const Color accent = Color(0xFF00F5A0);

  static const Color textPrimary = Color(0xFFF4F6FB);
  static const Color textSecondary = Color(0xFFA6AFC3);
  static const Color textMuted = Color(0xFF6C7688);

  static const Color divider = Color(0xFF232D42);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0E1A), Color(0xFF15213A), Color(0xFF1A1030)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceLight, surface],
  );
}
