// import 'package:flutter/material.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class PhotoSectionBackground extends StatefulWidget {
//   final String imagePath;
//   final Widget child;

//   const PhotoSectionBackground({
//     super.key,
//     required this.imagePath,
//     required this.child,
//   });

//   @override
//   State<PhotoSectionBackground> createState() => _PhotoSectionBackgroundState();
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
//     final mobile = MediaQuery.sizeOf(context).width < 700;

//     return VisibilityDetector(
//       key: _visibilityKey,
//       onVisibilityChanged: _handleVisibility,
//       child: Stack(
//         fit: StackFit.passthrough,
//         children: [
//           Positioned.fill(
//             child: ClipRect(
//               child: AnimatedBuilder(
//                 animation: _cameraController,
//                 builder: (context, child) {
//                   final progress = Curves.easeOutCubic.transform(
//                     _cameraController.value,
//                   );
//                   return Transform.translate(
//                     offset: Offset(0, (1 - progress) * 12),
//                     child: Transform.scale(
//                       scale: mobile
//                           ? 1.06 - progress * 0.06
//                           : 1.1 - progress * 0.1,
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Image.asset(
//                   widget.imagePath,
//                   fit: BoxFit.cover,
//                   alignment: mobile ? Alignment.center : Alignment.topCenter,
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: lightMode
//                       ? [
//                           Colors.white.withValues(alpha: 0.84),
//                           Colors.white.withValues(alpha: 0.9),
//                         ]
//                       : [
//                           Colors.black.withValues(alpha: 0.7),
//                           Colors.black.withValues(alpha: 0.82),
//                         ],
//                 ),
//               ),
//             ),
//           ),
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
//           widget.child,
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PhotoSectionBackground extends StatefulWidget {
  final String imagePath;
  final Widget child;

  const PhotoSectionBackground({
    super.key,
    required this.imagePath,
    required this.child, required Alignment alignment,
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

  @override
  void initState() {
    super.initState();

    _cameraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _handleVisibility(VisibilityInfo info) {
    if (_hasPlayed || info.visibleFraction < 0.08) return;

    _hasPlayed = true;
    _cameraController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final lightMode =
        Theme.of(context).brightness == Brightness.light;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final mobile = screenWidth < 700;
    final desktop = screenWidth >= 1024;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _handleVisibility,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Background image with responsive desktop fitting.
          Positioned.fill(
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _cameraController,
                builder: (context, child) {
                  final progress = Curves.easeOutCubic.transform(
                    _cameraController.value,
                  );

                  // Keep the desktop image closer to its original size.
                  final startScale = mobile
                      ? 1.04
                      : desktop
                          ? 1.02
                          : 1.05;

                  final endScale = mobile
                      ? 1.0
                      : desktop
                          ? 1.0
                          : 1.0;

                  final scale = startScale -
                      (startScale - endScale) * progress;

                  return Transform.translate(
                    offset: Offset(
                      0,
                      (1 - progress) * (mobile ? 8 : 5),
                    ),
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: desktop
                      ? Alignment.center
                      : mobile
                          ? Alignment.center
                          : Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),

          // Main overlay for text readability.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: lightMode
                      ? [
                          Colors.white.withValues(alpha: 0.84),
                          Colors.white.withValues(alpha: 0.90),
                        ]
                      : [
                          Colors.black.withValues(alpha: 0.70),
                          Colors.black.withValues(alpha: 0.82),
                        ],
                ),
              ),
            ),
          ),

          // Top and bottom blending gradients.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.18, 0.82, 1],
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

          // Foreground content.
          widget.child,
        ],
      ),
    );
  }
}
