import 'package:flutter/material.dart';

/// Central color palette — dark tech theme with one signature cyan.
class AppColors {
  AppColors._();

  static bool _dark = true;

  static Color get background =>
      _dark ? const Color(0xFF0A0E1A) : const Color(0xFFF5F7FB);
  static Color get surface => _dark ? const Color(0xFF121826) : Colors.white;
  static Color get surfaceLight =>
      _dark ? const Color(0xFF1B2436) : const Color(0xFFEAF0F8);

  /// Signature color used across accents, shimmers, and highlights.
  static const Color unique = Color(0xFF00B4D8);
  static const Color uniqueDeep = Color(0xFF007A94);
  static const Color uniqueLight = Color(0xFF7AE8FF);

  static const Color primary = unique;
  static const Color secondary = uniqueDeep;
  static const Color accent = uniqueLight;

  /// Animated sweep used on logo, name, and other hero typography.
  static LinearGradient shimmerGradient(double progress) {
    final shift = -1.15 + 2.3 * progress;
    return LinearGradient(
      begin: Alignment(shift, -0.15),
      end: Alignment(shift + 1.4, 0.15),
      colors: const [uniqueDeep, unique, uniqueLight, unique, uniqueDeep],
    );
  }

  static List<Color> accentPair(int index) {
    return index.isEven
        ? const [unique, uniqueLight]
        : const [uniqueDeep, unique];
  }

  static Color get textPrimary =>
      _dark ? const Color(0xFFF4F6FB) : const Color(0xFF172033);
  static Color get textSecondary =>
      _dark ? const Color(0xFFA6AFC3) : const Color.fromARGB(255, 23, 27, 34);
  static Color get textMuted =>
      _dark ? const Color(0xFF6C7688) : const Color.fromARGB(255, 38, 44, 53);

  static Color get divider =>
      _dark ? const Color(0xFF232D42) : const Color(0xFFD9E0EC);

  static LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _dark
            ? const [Color(0xFF050810), Color(0xFF0E1A2E), Color(0xFF120D22)]
            : const [Color(0xFFF5F7FB), Color(0xFFE5F5FA), Color(0xFFF0EAFB)],
      );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [uniqueDeep, unique, uniqueLight],
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
