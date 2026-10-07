import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Soft RGB mesh + fine dot pattern for hero / section backgrounds.
class RgbMeshOverlay extends StatefulWidget {
  final double strength;

  const RgbMeshOverlay({super.key, this.strength = 1.0});

  @override
  State<RgbMeshOverlay> createState() => _RgbMeshOverlayState();
}

class _RgbMeshOverlayState extends State<RgbMeshOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _RgbMeshPainter(
          progress: _controller.value,
          strength: widget.strength,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _RgbMeshPainter extends CustomPainter {
  final double progress;
  final double strength;

  const _RgbMeshPainter({
    required this.progress,
    required this.strength,
  });

  static const _red = Color(0xFFEF4444);
  static const _green = Color(0xFF22C55E);
  static const _blue = Color(0xFF3B82F6);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final t = progress * 2 * math.pi;
    final s = strength.clamp(0.0, 1.5);

    _drawOrb(
      canvas,
      color: _red,
      center: Offset(
        size.width * (0.22 + 0.06 * math.sin(t * 0.7)),
        size.height * (0.28 + 0.05 * math.cos(t * 0.5)),
      ),
      radius: size.shortestSide * 0.42,
      alpha: 0.11 * s,
    );
    _drawOrb(
      canvas,
      color: _green,
      center: Offset(
        size.width * (0.78 + 0.05 * math.cos(t * 0.6)),
        size.height * (0.62 + 0.06 * math.sin(t * 0.45)),
      ),
      radius: size.shortestSide * 0.38,
      alpha: 0.09 * s,
    );
    _drawOrb(
      canvas,
      color: _blue,
      center: Offset(
        size.width * (0.52 + 0.07 * math.sin(t * 0.55 + 1.2)),
        size.height * (0.18 + 0.04 * math.cos(t * 0.8)),
      ),
      radius: size.shortestSide * 0.36,
      alpha: 0.1 * s,
    );

    _drawSpectrumWash(canvas, size, s);
    _drawRgbDotGrid(canvas, size, s);
  }

  void _drawOrb(
    Canvas canvas, {
    required Color color,
    required Offset center,
    required double radius,
    required double alpha,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * 0.35),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  void _drawSpectrumWash(Canvas canvas, Size size, double s) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1 + 2 * progress, -0.5),
        end: Alignment(1 + 2 * progress, 0.5),
        colors: AppColors.rgbSpectrum
            .map((c) => c.withValues(alpha: 0.045 * s))
            .toList(),
        stops: AppColors.rgbSpectrumStops,
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawRgbDotGrid(Canvas canvas, Size size, double s) {
    const spacing = 28.0;
    const dotRadius = 0.65;
    const channels = [_red, _green, _blue];

    final paint = Paint()..style = PaintingStyle.fill;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final channel = (col + row) % 3;
        final pulse =
            0.55 + 0.45 * math.sin(tOffset(col, row) + progress * 2 * math.pi);
        paint.color = channels[channel].withValues(alpha: 0.035 * s * pulse);
        canvas.drawCircle(
          Offset(col * spacing + (row.isOdd ? spacing * 0.5 : 0), row * spacing),
          dotRadius,
          paint,
        );
      }
    }
  }

  double tOffset(int col, int row) => (col * 0.7 + row * 0.9) % (2 * math.pi);

  @override
  bool shouldRepaint(_RgbMeshPainter old) =>
      old.progress != progress || old.strength != strength;
}
