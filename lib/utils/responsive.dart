import 'package:flutter/material.dart';

/// Simple breakpoint helper used across the site so every section adapts
/// nicely between mobile, tablet, and desktop widths.
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 700 && w < 1100;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  /// Horizontal page padding that grows with screen size.
  static double pagePadding(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 48;
    return 96;
  }

  /// Caps content width on very large screens so text doesn't stretch edge
  /// to edge.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > 1300 ? 1200 : w;
  }
}
