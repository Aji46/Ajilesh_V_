import 'package:flutter/material.dart';

/// Central color palette for the portfolio — dark, techy theme with a
/// cyan/violet accent gradient (nods to both "Flutter" and "Cyber Security").
class AppColors {
  AppColors._();

  static bool _dark = true;

  static Color get background => _dark ? const Color(0xFF0A0E1A) : const Color(0xFFF5F7FB);
  static Color get surface => _dark ? const Color(0xFF121826) : Colors.white;
  static Color get surfaceLight => _dark ? const Color(0xFF1B2436) : const Color(0xFFEAF0F8);

  static const Color primary = Color(0xFF00B4D8);
  static const Color secondary = Color(0xFF6C3CE9);
  static const Color accent = Color(0xFF00F5A0);

  static Color get textPrimary => _dark ? const Color(0xFFF4F6FB) : const Color(0xFF172033);
  static Color get textSecondary => _dark ? const Color(0xFFA6AFC3) : const Color.fromARGB(255, 23, 27, 34);
  static Color get textMuted => _dark ? const Color(0xFF6C7688) : const Color.fromARGB(255, 38, 44, 53);

  static Color get divider => _dark ? const Color(0xFF232D42) : const Color(0xFFD9E0EC);

  static LinearGradient get heroGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: _dark
        ? const [Color(0xFF0A0E1A), Color(0xFF15213A), Color(0xFF1A1030)]
        : const [Color(0xFFF5F7FB), Color(0xFFE5F5FA), Color(0xFFF0EAFB)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  static LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceLight, surface],
  );

  static void setDarkMode(bool value) {
    _dark = value;
  }
}
