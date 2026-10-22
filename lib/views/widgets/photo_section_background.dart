// import 'package:flutter/material.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class PhotoSectionBackground extends StatefulWidget {
//   final String imagePath;
//   final Widget child;
//   final Alignment alignment;

//   const PhotoSectionBackground({
//     super.key,
//     required this.imagePath,
//     required this.child,
//     this.alignment = Alignment.topCenter,
//   });

//   @override
//   State<PhotoSectionBackground> createState() =>
//       _PhotoSectionBackgroundState();
// }

// class _PhotoSectionBackgroundState extends State<PhotoSectionBackground>
//     with SingleTickerProviderStateMixin {
//   final Key _visibilityKey = UniqueKey();

//   late final AnimationController _cameraController;
//   bool _hasPlayed = false;

//   @override
//   void initState() {
//     super.initState();
//     _cameraController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }

//   void _handleVisibility(VisibilityInfo info) {
//     if (_hasPlayed || info.visibleFraction < 0.08) return;
//     _hasPlayed = true;
//     _cameraController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lightMode = Theme.of(context).brightness == Brightness.light;
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final mobile = screenWidth < 700;
//     final desktop = screenWidth >= 1024;

//     return VisibilityDetector(
//       key: _visibilityKey,
//       onVisibilityChanged: _handleVisibility,
//       child: Stack(
//         fit: StackFit.passthrough,
//         children: [
//           // Background image with responsive zoom animation.
//           Positioned.fill(
//             child: ClipRect(
//               child: AnimatedBuilder(
//                 animation: _cameraController,
//                 builder: (context, child) {
//                   final progress = Curves.easeOutCubic.transform(
//                     _cameraController.value,
//                   );

//                   final startScale = mobile ? 1.06 : desktop ? 1.03 : 1.05;
//                   const endScale = 1.0;
//                   final scale = startScale - (startScale - endScale) * progress;

//                   return Transform.translate(
//                     offset: Offset(
//                       0,
//                       (1 - progress) * (mobile ? 8 : 4),
//                     ),
//                     child: Transform.scale(
//                       scale: scale,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Image.asset(
//                   widget.imagePath,
//                   width: double.infinity,
//                   height: double.infinity,
//                   fit: BoxFit.cover,
//                   alignment: widget.alignment,
//                   filterQuality: FilterQuality.high,
//                 ),
//               ),
//             ),
//           ),

//           // Main overlay for text readability.
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: lightMode
//                       ? [
//                           Colors.white.withValues(alpha: 0.86),
//                           Colors.white.withValues(alpha: 0.92),
//                         ]
//                       : [
//                           Colors.black.withValues(alpha: 0.76),
//                           Colors.black.withValues(alpha: 0.86),
//                         ],
//                 ),
//               ),
//             ),
//           ),

//           // Top and bottom blending gradients.
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: const [0, 0.18, 0.82, 1],
//                   colors: lightMode
//                       ? [
//                           Colors.white.withValues(alpha: 0.96),
//                           Colors.white.withValues(alpha: 0),
//                           Colors.white.withValues(alpha: 0),
//                           Colors.white.withValues(alpha: 0.96),
//                         ]
//                       : [
//                           Colors.black.withValues(alpha: 0.96),
//                           Colors.black.withValues(alpha: 0),
//                           Colors.black.withValues(alpha: 0),
//                           Colors.black.withValues(alpha: 0.96),
//                         ],
//                 ),
//               ),
//             ),
//           ),

//           // Foreground content.
//           widget.child,
//         ],
//       ),
//     );
//   }
// }



import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PhotoSectionBackground extends StatefulWidget {
  final String imagePath;
  final Widget child;
  final Alignment alignment;

  const PhotoSectionBackground({
    super.key,
    required this.imagePath,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  @override
  State<PhotoSectionBackground> createState() =>
      _PhotoSectionBackgroundState();
}

class _PhotoSectionBackgroundState extends State<PhotoSectionBackground>
    with SingleTickerProviderStateMixin {
  final Key _visibilityKey = UniqueKey();

  late final AnimationController _cameraController;

  bool _hasPlayed = false;
  bool _processing = false;
  double _interactiveScale = 1.0;
  double _dragDistance = 0;

  final List<int> _pendingDirections = [];

  static const Duration _zoomDuration =
      Duration(milliseconds: 650);

  static const double _minZoom = 0.85;
  static const double _maxZoom = 1.55;
  static const double _zoomStep = 0.15;

  @override
  void initState() {
    super.initState();

    _cameraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Play the cinematic entrance once when the section appears.
  void _handleVisibility(VisibilityInfo info) {
    if (_hasPlayed || info.visibleFraction < 0.08) return;

    _hasPlayed = true;
    _cameraController.forward();
  }

  // Mouse wheel: down zooms in, up zooms out.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    final delta = event.scrollDelta.dy;

    if (delta.abs() < 1) return;

    _enqueueDirection(delta > 0 ? 1 : -1);
  }

  void _enqueueDirection(int direction) {
    if (!mounted) return;

    // Keep rapid input responsive without an unlimited queue.
    if (_pendingDirections.length >= 4) {
      _pendingDirections.removeAt(0);
    }

    _pendingDirections.add(direction);
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_processing || !mounted) return;

    _processing = true;

    try {
      while (_pendingDirections.isNotEmpty && mounted) {
        final direction = _pendingDirections.removeAt(0);

        final nextScale = (_interactiveScale +
                direction * _zoomStep)
            .clamp(_minZoom, _maxZoom)
            .toDouble();

        if (!mounted) break;

        setState(() {
          _interactiveScale = nextScale;
        });

        await Future<void>.delayed(_zoomDuration);
      }
    } finally {
      _processing = false;

      if (mounted && _pendingDirections.isNotEmpty) {
        unawaited(_processQueue());
      }
    }
  }

  // Mobile swipe handling.
  void _onVerticalDragStart(DragStartDetails details) {
    _dragDistance = 0;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dy;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    const distanceThreshold = 45.0;
    const velocityThreshold = 180.0;

    final velocity = details.primaryVelocity ?? 0;

    if (_dragDistance < -distanceThreshold ||
        velocity < -velocityThreshold) {
      // Swipe up: zoom in.
      _enqueueDirection(1);
    } else if (_dragDistance > distanceThreshold ||
        velocity > velocityThreshold) {
      // Swipe down: zoom out.
      _enqueueDirection(-1);
    }

    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    final lightMode =
        Theme.of(context).brightness == Brightness.light;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final mobile = screenWidth < 700;
    final desktop = screenWidth >= 1024;

    final initialScale = mobile
        ? 1.12
        : desktop
            ? 1.08
            : 1.10;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _handleVisibility,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: _onPointerSignal,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // ── Cinematic background image ─────────────────────
            Positioned.fill(
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: _cameraController,
                  builder: (context, child) {
                    final progress =
                        Curves.easeInOutCubic.transform(
                      _cameraController.value,
                    );

                    // Entrance: start zoomed in, then pull back.
                    final entranceScale = initialScale -
                        (initialScale - 1.0) * progress;

                    // Subtle camera drift for a cinematic feel.
                    final verticalDrift =
                        (1.0 - progress) * (mobile ? 12.0 : 7.0);

                    return Transform.translate(
                      offset: Offset(0, verticalDrift),
                      child: Transform.scale(
                        scale: entranceScale,
                        child: child,
                      ),
                    );
                  },
                  child: AnimatedScale(
                    scale: _interactiveScale,
                    duration: _zoomDuration,
                    curve: Curves.easeInOutCubic,
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      alignment: widget.alignment,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) {
                        return const ColoredBox(
                          color: Color(0xFF0A0E1A),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            

            // ── Theme-aware readability overlay ───────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: lightMode
                          ? [
                              Colors.white.withValues(alpha: 0.86),
                              Colors.white.withValues(alpha: 0.92),
                            ]
                          : [
                              Colors.black.withValues(alpha: 0.76),
                              Colors.black.withValues(alpha: 0.86),
                            ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Top and bottom blending ────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.18, 0.82, 1.0],
                      colors: lightMode
                          ? [
                              Colors.white.withValues(alpha: 0.96),
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.96),
                            ]
                          : [
                              Colors.black.withValues(alpha: 0.96),
                              Colors.black.withValues(alpha: 0),
                              Colors.black.withValues(alpha: 0),
                              Colors.black.withValues(alpha: 0.96),
                            ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Foreground content stays unchanged ─────────────
            widget.child,

            // ── Zoom gesture area ─────────────────────────────
            // Kept behind foreground content so buttons and links
            // in widget.child remain interactive.
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
