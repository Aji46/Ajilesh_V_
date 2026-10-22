import 'package:flutter/material.dart';

class MouseParallaxBackground extends StatefulWidget {
  final String imagePath;
  final double intensity;
  final double zoom;
  final Widget? child;

  const MouseParallaxBackground({
    super.key,
    required this.imagePath,
    this.intensity = 22,
    this.zoom = 1.12,
    this.child,
  });

  @override
  State<MouseParallaxBackground> createState() =>
      _MouseParallaxBackgroundState();
}

class _MouseParallaxBackgroundState
    extends State<MouseParallaxBackground> {
  double mouseX = 0;
  double mouseY = 0;

  bool isHovering = false;

  void _onPointerMove(PointerEvent event, Size size) {
    setState(() {
      mouseX = ((event.localPosition.dx / size.width) - 0.5) * 2;
      mouseY = ((event.localPosition.dy / size.height) - 0.5) * 2;
      isHovering = true;
    });
  }

  void _onPointerExit(PointerEvent event) {
    setState(() {
      mouseX = 0;
      mouseY = 0;
      isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return MouseRegion(
          onHover: (event) => _onPointerMove(event, size),
          onExit: _onPointerExit,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  transformAlignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(
                      -mouseX * widget.intensity,
                      -mouseY * widget.intensity,
                    )
                    ..scale(isHovering ? widget.zoom : 1.04),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.high,
                  ),
                ),

                // Dark cinematic overlay.
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF080B16)
                            .withValues(alpha: 0.30),
                        const Color(0xFF080B16)
                            .withValues(alpha: 0.12),
                        const Color(0xFF080B16)
                            .withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),

                if (widget.child != null) widget.child!,
              ],
            ),
          ),
        );
      },
    );
  }
}