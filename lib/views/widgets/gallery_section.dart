import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'photo_section_background.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';

class StoryScene {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Alignment alignment;
  final FaIconData icon;
  final Color color;
  final String tag;

  const StoryScene({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.alignment,
    required this.icon,
    required this.color,
    required this.tag,
  });
}

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  bool _storyMode = true;

  static const List<StoryScene> _scenes = [
    StoryScene(
      title: 'Crafting Digital Experiences',
      subtitle: 'Mobile & Web Development',
      description:
          'Passionate Flutter mobile app developer dedicated to creating intuitive, efficient, and beautifully designed user experiences.',
      imagePath: 'assets/images/wa4.jpeg',
      alignment: Alignment(0.0, -0.32),
      icon: FontAwesomeIcons.flutter,
      color: Color(0xFF00B4D8),
      tag: 'Development',
    ),
    StoryScene(
      title: 'Software Consulting & R&D',
      subtitle: 'Datamate Info Solutions',
      description:
          'Building enterprise software, conducting research, and collaborating with cross-functional teams to solve real-world problems.',
      imagePath: 'assets/images/wa1.jpeg',
      alignment: Alignment(0.0, -0.60),
      icon: FontAwesomeIcons.briefcase,
      color: Color(0xFF7209B7),
      tag: 'Experience',
    ),
    StoryScene(
      title: 'Creative Lens & Pixel Focus',
      subtitle: 'Attention to Visual Detail',
      description:
          'Approaching code like cinematography: obsessed with visual balance, responsive proportions, micro-interactions, and aesthetics.',
      imagePath: 'assets/images/wa9.jpeg',
      alignment: Alignment(0.18, -0.42),
      icon: FontAwesomeIcons.cameraRetro,
      color: Color(0xFFFFB703),
      tag: 'Creative',
    ),
    StoryScene(
      title: 'Unstoppable Drive & Agility',
      subtitle: 'Taking the Leap',
      description:
          'Fearless about learning complex frameworks, mastering new paradigms, and taking bold technological leaps.',
      imagePath: 'assets/images/wa2.jpeg',
      alignment: Alignment(0.0, -0.15),
      icon: FontAwesomeIcons.bolt,
      color: Color(0xFFEF476F),
      tag: 'Energy',
    ),
    StoryScene(
      title: 'Cyber Security Research',
      subtitle: 'Certified Ethical Hacker Mindset',
      description:
          'Combining defensive secure coding practices with proactive vulnerability assessments to build trustworthy software.',
      imagePath: 'assets/images/wa7.jpeg',
      alignment: Alignment(0.0, -0.28),
      icon: FontAwesomeIcons.shieldHalved,
      color: Color(0xFF06D6A0),
      tag: 'Security',
    ),
    StoryScene(
      title: 'Breathe, Reflect & Flow',
      subtitle: 'Clarity in Nature',
      description:
          'Taking time to step outside the editor, recharge in the hills, and return with fresh problem-solving perspectives.',
      imagePath: 'assets/images/wa3.jpeg',
      alignment: Alignment(0.0, -0.10),
      icon: FontAwesomeIcons.mountainSun,
      color: Color(0xFF48CAE4),
      tag: 'Clarity',
    ),
    StoryScene(
      title: 'Life Outside the IDE',
      subtitle: 'Culture & Personal Growth',
      description:
          'Curiosity extends far beyond the screen into street style, exploration, personal growth, and continuous learning.',
      imagePath: 'assets/images/wa8.jpeg',
      alignment: Alignment(0.0, -0.65),
      icon: FontAwesomeIcons.compass,
      color: Color(0xFF9D4EDD),
      tag: 'Lifestyle',
    ),
    StoryScene(
      title: 'Vision for the Future',
      subtitle: 'Collaborations & Horizons',
      description:
          'Ready to architect impactful solutions, scale global applications, and push the boundaries of digital engineering.',
      imagePath: 'assets/images/wa6.jpeg',
      alignment: Alignment(0.0, 0.05),
      icon: FontAwesomeIcons.rocket,
      color: Color(0xFF3A86FF),
      tag: 'Horizons',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PhotoSectionBackground(
      imagePath: 'assets/images/wa3.jpeg',
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.pagePadding(context),
          vertical: 90,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: SectionTitle(
                        kicker: 'Visual Journey',
                        title: 'Snapshots & Zoom Story',
                      ),
                    ),
                    // ── View mode toggle ──────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ToggleTab(
                            icon: Icons.zoom_in,
                            label: 'Zoom Story',
                            active: _storyMode,
                            onTap: () => setState(() => _storyMode = true),
                          ),
                          _ToggleTab(
                            icon: Icons.grid_view_rounded,
                            label: 'Grid',
                            active: !_storyMode,
                            onTap: () => setState(() => _storyMode = false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _storyMode
                      ? _InteractiveZoomStoryViewer(
                          key: const ValueKey('zoom_story'),
                          scenes: _scenes,
                          onOpenLightbox: (index) =>
                              _openLightbox(context, index),
                        )
                      : _GalleryGridView(
                          key: const ValueKey('gallery_grid'),
                          scenes: _scenes,
                          onOpenLightbox: (index) =>
                              _openLightbox(context, index),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: const Color(0xEB000000),
        pageBuilder: (context, anim, _) => FadeTransition(
          opacity: anim,
          child: _ZoomLightbox(scenes: _scenes, initialIndex: index),
        ),
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isSmallMobile(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: mobile ? 10 : 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: active ? AppColors.accentGradient : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: active ? Colors.white : AppColors.textMuted,
            ),
            if (!mobile) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Interactive Zoom Story Viewer (wheel scroll + drag + zoom animation)
// ═══════════════════════════════════════════════════════════════════════════
class _InteractiveZoomStoryViewer extends StatefulWidget {
  final List<StoryScene> scenes;
  final void Function(int) onOpenLightbox;

  const _InteractiveZoomStoryViewer({
    super.key,
    required this.scenes,
    required this.onOpenLightbox,
  });

  @override
  State<_InteractiveZoomStoryViewer> createState() =>
      _InteractiveZoomStoryViewerState();
}

class _InteractiveZoomStoryViewerState
    extends State<_InteractiveZoomStoryViewer> {
  int _currentIndex = 0;
  double _zoomScale = 1.0;
  bool _processing = false;
  final List<int> _pendingDirections = [];
  double _dragDistance = 0;
  bool _isHoveringStory = false;

  static const Duration _zoomDuration = Duration(milliseconds: 450);

  StoryScene get _scene => widget.scenes[_currentIndex];

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final delta = event.scrollDelta.dy;
    if (delta.abs() < 1) return;
    _enqueueDirection(delta > 0 ? 1 : -1);
  }

  void _enqueueDirection(int direction) {
    if (!mounted) return;
    if (_pendingDirections.length >= 3) {
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
        if (direction > 0) {
          await _zoomIn();
        } else {
          await _zoomOut();
        }
      }
    } finally {
      _processing = false;
      if (mounted && _pendingDirections.isNotEmpty) {
        _processQueue();
      }
    }
  }

  Future<void> _zoomIn() async {
    if (!mounted) return;
    if (_currentIndex >= widget.scenes.length - 1) {
      await _animateScale(1.15);
      await _animateScale(1.0);
      return;
    }
    await _animateScale(1.6);
    if (!mounted) return;
    setState(() {
      _currentIndex++;
      _zoomScale = 1.6;
    });
    await _animateScale(1.0);
  }

  Future<void> _zoomOut() async {
    if (!mounted) return;
    if (_currentIndex <= 0) {
      await _animateScale(0.88);
      await _animateScale(1.0);
      return;
    }
    await _animateScale(0.72);
    if (!mounted) return;
    setState(() {
      _currentIndex--;
      _zoomScale = 0.72;
    });
    await _animateScale(1.0);
  }

  Future<void> _animateScale(double target) async {
    if (!mounted) return;
    setState(() => _zoomScale = target);
    await Future<void>.delayed(_zoomDuration);
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _dragDistance = 0;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.delta.dy;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    const distanceThreshold = 40.0;
    const velocityThreshold = 150.0;
    final velocity = details.primaryVelocity ?? 0;

    if (_dragDistance < -distanceThreshold || velocity < -velocityThreshold) {
      _enqueueDirection(1);
    } else if (_dragDistance > distanceThreshold ||
        velocity > velocityThreshold) {
      _enqueueDirection(-1);
    }
    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    final scene = _scene;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final mobile = screenWidth < 700;
    final height = mobile ? 460.0 : 540.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringStory = true),
      onExit: (_) => setState(() => _isHoveringStory = false),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: scene.color.withValues(alpha: 0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: scene.color.withValues(alpha: 0.22),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerSignal: _onPointerSignal,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Zooming Picture Background ─────────────────────
                  ClipRect(
                    child: AnimatedScale(
                      scale: _zoomScale,
                      duration: _zoomDuration,
                      curve: Curves.easeInOutCubic,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Image.asset(
                          scene.imagePath,
                          key: ValueKey(scene.imagePath),
                          fit: BoxFit.cover,
                          alignment: scene.alignment,
                          width: double.infinity,
                          height: double.infinity,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: scene.color,
                            child: const Center(
                              child: Icon(Icons.image,
                                  size: 64, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Cinematic Vignette Gradient Overlays ──────────
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.35, 0.7, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.75),
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.65),
                            Colors.black.withValues(alpha: 0.94),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Top Bar Controls ───────────────────────────────
                  Positioned(
                    top: 18,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: scene.color.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(scene.icon,
                                  size: 13, color: scene.color),
                              const SizedBox(width: 8),
                              Text(
                                scene.tag.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Lightbox full screen button
                        IconButton(
                          tooltip: 'View Full Screen (Interactive Lightbox)',
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Colors.black.withValues(alpha: 0.6),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          icon: const Icon(Icons.fullscreen,
                              color: Colors.white, size: 20),
                          onPressed: () =>
                              widget.onOpenLightbox(_currentIndex),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            '${_currentIndex + 1} / ${widget.scenes.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom Content & Controls ──────────────────────
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated text description
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.15),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey(_currentIndex),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                scene.subtitle,
                                style: TextStyle(
                                  color: scene.color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                scene.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mobile ? 22 : 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 580),
                                child: Text(
                                  scene.description,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                    height: 1.55,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Scene Progress Bars
                        Row(
                          children: List.generate(widget.scenes.length, (i) {
                            final isActive = i == _currentIndex;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _currentIndex = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: isActive ? 5 : 3,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: i <= _currentIndex
                                        ? scene.color
                                        : Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: scene.color.withValues(
                                                  alpha: 0.8),
                                              blurRadius: 8,
                                            ),
                                          ]
                                        : [],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 14),

                        // Interactive Control Buttons & Wheel Hint
                        Row(
                          children: [
                            _StoryButton(
                              icon: Icons.zoom_out,
                              label: 'Zoom Out',
                              tooltip: 'Previous photo (Scroll Up)',
                              color: scene.color,
                              onTap: () => _enqueueDirection(-1),
                            ),
                            const SizedBox(width: 10),
                            _StoryButton(
                              icon: Icons.zoom_in,
                              label: 'Zoom In',
                              tooltip: 'Next photo (Scroll Down)',
                              color: scene.color,
                              onTap: () => _enqueueDirection(1),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isHoveringStory
                                        ? Icons.mouse
                                        : Icons.touch_app,
                                    size: 13,
                                    color: scene.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    mobile
                                        ? 'SWIPE TO ZOOM'
                                        : 'SCROLL WHEEL TO ZOOM',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(_zoomScale * 100).round()}%',
                                    style: TextStyle(
                                      color: scene.color,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _StoryButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  State<_StoryButton> createState() => _StoryButtonState();
}

class _StoryButtonState extends State<_StoryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _hover
                  ? widget.color.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hover
                    ? widget.color
                    : widget.color.withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Gallery Grid View (Masonry layout with focal alignment & zoom on hover)
// ═══════════════════════════════════════════════════════════════════════════
class _GalleryGridView extends StatelessWidget {
  final List<StoryScene> scenes;
  final void Function(int) onOpenLightbox;

  const _GalleryGridView({
    super.key,
    required this.scenes,
    required this.onOpenLightbox,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 550 ? 1 : (width < 900 ? 2 : (width < 1200 ? 3 : 4));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scenes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, i) {
            final scene = scenes[i];
            return ScrollReveal(
              delay: Duration(milliseconds: 60 * i),
              child: _GalleryGridCard(
                scene: scene,
                onTap: () => onOpenLightbox(i),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.touch_app, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              'Tap any image to open the Interactive Zoom & Pan Lightbox.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GalleryGridCard extends StatefulWidget {
  final StoryScene scene;
  final VoidCallback onTap;

  const _GalleryGridCard({
    required this.scene,
    required this.onTap,
  });

  @override
  State<_GalleryGridCard> createState() => _GalleryGridCardState();
}

class _GalleryGridCardState extends State<_GalleryGridCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover
                  ? widget.scene.color
                  : AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? widget.scene.color.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.25),
                blurRadius: _hover ? 22 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Zoom animation on hover
                AnimatedScale(
                  scale: _hover ? 1.09 : 1.0,
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.scene.imagePath,
                    fit: BoxFit.cover,
                    alignment: widget.scene.alignment,
                    filterQuality: FilterQuality.high,
                  ),
                ),

                // Dark gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.45, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // Corner Tag Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.scene.color.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      widget.scene.tag.toUpperCase(),
                      style: TextStyle(
                        color: widget.scene.color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                // Zoom Icon Hint
                Positioned(
                  top: 12,
                  right: 12,
                  child: AnimatedOpacity(
                    opacity: _hover ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.scene.color.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.zoom_in,
                          size: 15, color: Colors.white),
                    ),
                  ),
                ),

                // Bottom Title & Description
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.scene.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.scene.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Interactive Zoom & Pan Lightbox
// ═══════════════════════════════════════════════════════════════════════════
class _ZoomLightbox extends StatefulWidget {
  final List<StoryScene> scenes;
  final int initialIndex;

  const _ZoomLightbox({
    required this.scenes,
    required this.initialIndex,
  });

  @override
  State<_ZoomLightbox> createState() => _ZoomLightboxState();
}

class _ZoomLightboxState extends State<_ZoomLightbox> {
  late int _index = widget.initialIndex;
  final TransformationController _transformController =
      TransformationController();
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformController.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    setState(() {
      _currentScale = _transformController.value.getMaxScaleOnAxis();
    });
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _zoomInStep() {
    final nextScale = (_currentScale * 1.35).clamp(1.0, 4.0);
    _transformController.value =
        Matrix4.diagonal3Values(nextScale, nextScale, 1.0);
  }

  void _zoomOutStep() {
    final nextScale = (_currentScale / 1.35).clamp(1.0, 4.0);
    _transformController.value =
        Matrix4.diagonal3Values(nextScale, nextScale, 1.0);
  }

  void _nextPhoto() {
    _resetZoom();
    setState(() {
      _index = (_index + 1) % widget.scenes.length;
    });
  }

  void _prevPhoto() {
    _resetZoom();
    setState(() {
      _index = (_index - 1 + widget.scenes.length) % widget.scenes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scene = widget.scenes[_index];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Interactive Pan & Zoom viewer
            Center(
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 1.0,
                maxScale: 4.5,
                clipBehavior: Clip.none,
                child: Hero(
                  tag: 'gallery_$_index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      scene.imagePath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image,
                        color: AppColors.textMuted,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top Bar
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: scene.color.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(scene.icon, size: 13, color: scene.color),
                        const SizedBox(width: 8),
                        Text(
                          scene.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_index + 1} of ${widget.scenes.length}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close (Esc)',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.7),
                    ),
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Navigation Arrows
            if (widget.scenes.length > 1) ...[
              Positioned(
                left: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 32),
                    onPressed: _prevPhoto,
                  ),
                ),
              ),
              Positioned(
                right: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.chevron_right,
                        color: Colors.white, size: 32),
                    onPressed: _nextPhoto,
                  ),
                ),
              ),
            ],

            // Bottom Zoom Toolbar
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Zoom Out',
                        icon: const Icon(Icons.remove,
                            color: Colors.white, size: 20),
                        onPressed: _zoomOutStep,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(_currentScale * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: 'Zoom In',
                        icon:
                            const Icon(Icons.add, color: Colors.white, size: 20),
                        onPressed: _zoomInStep,
                      ),
                      if (_currentScale > 1.05) ...[
                        const SizedBox(width: 6),
                        TextButton(
                          onPressed: _resetZoom,
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
