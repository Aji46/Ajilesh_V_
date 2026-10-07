import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Custom glowing cursor with a trailing ripple — web only.
/// Wrap your top-level widget with this to overlay the cursor on the entire app.
class CustomCursorOverlay extends StatefulWidget {
  final Widget child;
  const CustomCursorOverlay({super.key, required this.child});

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay>
    with TickerProviderStateMixin {
  Offset _cursor = Offset.zero;
  Offset _ring = Offset.zero;
  bool _visible = false;

  // Trail history
  final List<_TrailPoint> _trail = [];
  static const int _trailLength = 18;

  late final AnimationController _ringController;
  late final AnimationController _trailController;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _trailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60fps
    )..addListener(_updateRing)
      ..repeat();
  }

  void _updateRing() {
    if (!mounted) return;
    // Lerp the ring toward the cursor for a smooth lag
    final dx = _cursor.dx - _ring.dx;
    final dy = _cursor.dy - _ring.dy;
    _ring = Offset(_ring.dx + dx * 0.14, _ring.dy + dy * 0.14);

    // Update trail
    if (_visible && _trail.isNotEmpty) {
      final last = _trail.last;
      final dist = (_cursor - last.position).distance;
      if (dist > 4) {
        _trail.add(_TrailPoint(_cursor, DateTime.now()));
        if (_trail.length > _trailLength) _trail.removeAt(0);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ringController.dispose();
    _trailController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    _cursor = event.localPosition;
    if (!_visible) {
      setState(() => _visible = true);
      if (_trail.isEmpty) _ring = _cursor;
    }
    _trail.add(_TrailPoint(_cursor, DateTime.now()));
    if (_trail.length > _trailLength) _trail.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Hide the system cursor and replace with ours
      cursor: SystemMouseCursors.none,
      onHover: _onHover,
      onExit: (_) => setState(() => _visible = false),
      child: Stack(
        children: [
          widget.child,
          if (_visible) ...[
            // ── Comet trail ─────────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _TrailPainter(trail: List.from(_trail)),
                ),
              ),
            ),

            // ── Outer ring (lags behind) ─────────────────────────────
            Positioned(
              left: _ring.dx - 22,
              top: _ring.dy - 22,
              child: IgnorePointer(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00B4D8).withValues(alpha: 0.7),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B4D8).withValues(alpha: 0.25),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Inner glow dot (follows cursor exactly) ──────────────
            Positioned(
              left: _cursor.dx - 5,
              top: _cursor.dy - 5,
              child: IgnorePointer(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF00F5A0),
                        Color(0xFF00B4D8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F5A0).withValues(alpha: 0.9),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrailPoint {
  final Offset position;
  final DateTime time;
  const _TrailPoint(this.position, this.time);
}

class _TrailPainter extends CustomPainter {
  final List<_TrailPoint> trail;
  const _TrailPainter({required this.trail});

  @override
  void paint(Canvas canvas, Size size) {
    if (trail.length < 2) return;

    final now = DateTime.now();

    for (int i = 1; i < trail.length; i++) {
      final t = i / trail.length; // 0..1 (older → newer)
      final age = now.difference(trail[i].time).inMilliseconds;
      final ageFade = (1.0 - (age / 300.0)).clamp(0.0, 1.0);

      final spectrum = AppColors.rgbSpectrum;
      final from = spectrum[(i - 1) % (spectrum.length - 1)];
      final to = spectrum[i % (spectrum.length - 1)];
      final paint = Paint()
        ..color = Color.lerp(
          from.withValues(alpha: 0),
          to.withValues(alpha: 0.55 * ageFade),
          t,
        )!
        ..strokeWidth = (1.0 + 4.0 * t) * ageFade
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(trail[i - 1].position, trail[i].position, paint);
    }
  }

  @override
  bool shouldRepaint(_TrailPainter old) => true;
}
