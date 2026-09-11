import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// CONTROLLER LAYER
/// Handles the light/dark theme toggle shown in the navbar.
/// (The site is designed primarily for dark mode, but this demonstrates
/// Provider-driven state that rebuilds the tree reactively.)
class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  ThemeProvider() {
    AppColors.setDarkMode(_isDark);
  }

  void toggleTheme() {
    _isDark = !_isDark;
    AppColors.setDarkMode(_isDark);
    notifyListeners();
  }
}
