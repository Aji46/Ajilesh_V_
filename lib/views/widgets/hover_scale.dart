import 'package:flutter/material.dart';

/// Wraps [child] with a subtle hover/press "lift" animation — scales up
/// slightly and adds a glow shadow. Works with mouse (web/desktop) via
/// MouseRegion, and gracefully does nothing extra on touch devices.
class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final Color glowColor;
  final VoidCallback? onTap;

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.04,
    this.glowColor = const Color(0xFF00B4D8),
    this.onTap,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovering ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.35),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
