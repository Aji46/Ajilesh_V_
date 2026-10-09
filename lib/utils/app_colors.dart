import 'package:flutter/material.dart';

/// Central color palette for the portfolio — dark, techy theme with a
/// cyan/violet accent gradient (nods to both "Flutter" and "Cyber Security").
class AppColors {
  AppColors._();

  static bool _dark = true;

  static Color get background =>
      _dark ? const Color(0xFF000000) : const Color(0xFFF5F7FB);
  static Color get surface => _dark ? const Color(0xFF080808) : Colors.white;
  static Color get surfaceLight =>
      _dark ? const Color(0xFF111111) : const Color(0xFFEAF0F8);

  static const Color primary = Color(0xFFFF4F83);
  static const Color secondary = Color(0xFFFF7957);
  static const Color accent = Color(0xFFFFC857);

  /// Evenly spaced spectrum for shimmer lines and accents (loops at end).
  static const List<Color> rgbSpectrum = [
    Color(0xFFFF4F83),
    Color(0xFFFF596B),
    Color(0xFFFF7957),
    Color(0xFFFF9B4A),
    Color(0xFFFFC857),
    Color(0xFFFF9850),
    Color(0xFFEF6682),
    Color(0xFFB94E84),
    Color(0xFFFF4F83),
  ];

  static const List<double> rgbSpectrumStops = [
    0.0,
    0.125,
    0.25,
    0.375,
    0.5,
    0.625,
    0.75,
    0.875,
    1.0,
  ];

  /// Animated sweep used on logo, name, and other hero typography.
  static LinearGradient shimmerGradient(double progress) {
    final shift = -1.15 + 2.3 * progress;
    return LinearGradient(
      begin: Alignment(shift, -0.15),
      end: Alignment(shift + 1.4, 0.15),
      colors: rgbSpectrum,
      stops: rgbSpectrumStops,
    );
  }

  /// Two-stop slice of the spectrum for cards and icons.
  static List<Color> spectrumPair(int index, {int total = 4}) {
    final n = rgbSpectrum.length - 1;
    final step = (n ~/ total).clamp(1, n);
    final start = (index * step) % n;
    var end = (start + step) % n;
    if (end == start) end = (start + 1) % n;
    return [rgbSpectrum[start], rgbSpectrum[end]];
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
            ? const [Color(0xFF000000), Color(0xFF080808), Color(0xFF111111)]
            : const [Color(0xFFF5F7FB), Color(0xFFE5F5FA), Color(0xFFF0EAFB)],
      );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primary,
      secondary,
      Color(0xFFFF9B4A),
      accent,
    ],
    stops: [0.0, 0.38, 0.68, 1.0],
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
