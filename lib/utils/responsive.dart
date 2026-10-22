import 'package:flutter/material.dart';

/// Simple breakpoint helper used across the site so every section adapts
/// nicely between mobile, tablet, and desktop widths.
class Responsive {
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 400;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 700;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 700 && w < 1050;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1050;

  /// Checks if columns should stack vertically to prevent overflow
  static bool isStacked(BuildContext context, [double breakpoint = 980]) =>
      MediaQuery.sizeOf(context).width < breakpoint;

  /// Responsive avatar diameter that prevents overflow across all devices
  static double avatarSize(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 380) return (w - 70) * 0.72;
    if (w < 700) return 220;
    if (w < 1050) return 250;
    return 310;
  }

  /// Horizontal page padding that grows with screen size.
  static double pagePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 400) return 16;
    if (w < 700) return 20;
    if (w < 1050) return 40;
    return 80;
  }

  /// Caps content width on very large screens so text doesn't stretch edge
  /// to edge.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w > 1300 ? 1200 : w;
  }
}
