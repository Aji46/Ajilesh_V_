import 'package:flutter/material.dart';

/// CONTROLLER LAYER (C in MVC)
/// Owns the scroll controller + section keys so the navbar can smoothly
/// scroll to, and highlight, the currently visible section.
class NavProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'gallery': GlobalKey(),
    'education': GlobalKey(),
    'contact': GlobalKey(),
    'hire': GlobalKey(),
  };

  String _activeSection = 'home';
  String get activeSection => _activeSection;

  bool _mobileMenuOpen = false;
  bool get mobileMenuOpen => _mobileMenuOpen;

  void toggleMobileMenu() {
    _mobileMenuOpen = !_mobileMenuOpen;
    notifyListeners();
  }

  void closeMobileMenu() {
    if (_mobileMenuOpen) {
      _mobileMenuOpen = false;
      notifyListeners();
    }
  }

  void setActiveSection(String key) {
    if (_activeSection != key) {
      _activeSection = key;
      notifyListeners();
    }
  }

  void scrollToSection(String key) {
    closeMobileMenu();
    final ctx = sectionKeys[key]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
      setActiveSection(key);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
