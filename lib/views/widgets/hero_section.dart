import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/nav_provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'rgb_mesh_overlay.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _particleController;
  late final AnimationController _glowController;
  late final AnimationController _ringController;
  late final AnimationController _cameraController;

  final List<String> _roles = const [
    'Flutter Developer',
    'Cyber Security Researcher',
    'Ethical Hacker',
    'Mobile App Builder',
  ];
  int _roleIndex = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _cameraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat(reverse: true);

    _cycleRoles();
  }

  void _cycleRoles() {
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _roleIndex = (_roleIndex + 1) % _roles.length);
      _cycleRoles();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _ringController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.read<PortfolioProvider>();
    final nav = context.read<NavProvider>();
    final profile = portfolio.profile;
    final mobile = Responsive.isMobile(context);
    final stackedLayout = MediaQuery.sizeOf(context).width < 1200;
    final size = MediaQuery.of(context).size;

    final textColumn = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // ── "Available" badge ──────────────────────────────────────────
        FadeInDown(
          duration: const Duration(milliseconds: 700),
          child: _GlowBadge(),
        ),
        const SizedBox(height: 22),

        // ── Hi, I'm ───────────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 150),
          duration: const Duration(milliseconds: 700),
          child: Text(
            'Hi, I\'m',
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // ── Name with shimmer gradient ─────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 700),
          child: _AnimatedGradientName(name: profile.name),
        ),
        const SizedBox(height: 14),

        // ── Animated role switcher ─────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 350),
          duration: const Duration(milliseconds: 700),
          child: SizedBox(
            height: 36,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Row(
                key: ValueKey(_roleIndex),
                mainAxisSize: mobile ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment:
                    mobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _roles[_roleIndex],
                    textAlign: mobile ? TextAlign.center : TextAlign.start,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Summary ────────────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 450),
          duration: const Duration(milliseconds: 700),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              profile.summary,
              textAlign: mobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontSize: 15.5,
                height: 1.75,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ),
        ),
        const SizedBox(height: 34),

        // ── CTA Buttons ────────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 550),
          duration: const Duration(milliseconds: 700),
          child: Wrap(
            alignment: mobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 16,
            runSpacing: 12,
            children: [
              _PrimaryButton(
                label: 'View Projects',
                onTap: () => nav.scrollToSection('projects'),
              ),
              _OutlineButton(
                label: 'Contact Me',
                onTap: () => nav.scrollToSection('contact'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // ── Social Icons ───────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 650),
          duration: const Duration(milliseconds: 700),
          child: Wrap(
            alignment: mobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 14,
            children: [
              _SocialIcon(
                icon: FontAwesomeIcons.linkedinIn,
                onTap: () => portfolio.launchUrlString(profile.linkedInUrl),
              ),
              _SocialIcon(
                icon: FontAwesomeIcons.github,
                onTap: () => portfolio.launchUrlString(profile.githubUrl),
              ),
              _SocialIcon(
                icon: FontAwesomeIcons.instagram,
                onTap: () => portfolio.launchUrlString(profile.instagramUrl),
              ),
              _SocialIcon(
                icon: FontAwesomeIcons.envelope,
                onTap: portfolio.launchEmail,
              ),
            ],
          ),
        ),
      ],
    );

    final avatar = FadeIn(
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 900),
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final dy = (_floatController.value - 0.5) * 18;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: _AvatarBlock(
          imagePath: 'assets/images/wa9.jpeg',
          ringController: _ringController,
          glowController: _glowController,
        ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // ── Full-width banner background image ─────────────────────
          Positioned.fill(
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _cameraController,
                builder: (context, child) => Transform.scale(
                  scale: mobile
                      ? 1.02 + _cameraController.value * 0.06
                      : 1.04 + _cameraController.value * 0.12,
                  child: child,
                ),
                child: Image.asset(
                  'assets/images/wa8.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(gradient: AppColors.heroGradient),
                  ),
                ),
              ),
            ),
          ),

          // ── Dark overlay gradient ─────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF10070D).withValues(alpha: 0.94),
                    const Color(0xFF35121E).withValues(alpha: 0.76),
                    const Color(0xFF7A2632).withValues(alpha: 0.34),
                  ],
                ),
              ),
            ),
          ),

          // ── RGB mesh + dot pattern ───────────────────────────────
          const Positioned.fill(
            child: IgnorePointer(
              child: RgbMeshOverlay(strength: 0.38),
            ),
          ),

          // ── Bottom fade ────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // ── Floating orbs (decorative) ────────────────────────────
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(size.width, mobile ? 520.0 : 700.0),
                painter: _ParticlePainter(
                  progress: _particleController.value,
                ),
              );
            },
          ),

          // ── Main content ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.pagePadding(context),
              vertical: mobile ? 70 : 120,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context)),
                child: stackedLayout
                    ? Column(children: [
                        avatar,
                        const SizedBox(height: 44),
                        textColumn
                      ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 6, child: textColumn),
                          const SizedBox(width: 40),
                          Expanded(flex: 4, child: Center(child: avatar)),
                        ],
                      ),
              ),
            ),
          ),

          // ── Scroll down indicator ─────────────────────────────────
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(child: _ScrollDownArrow()),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Particle painter
// ═══════════════════════════════════════════════════════════════════════════
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_ParticleData> _particles = List.generate(
    18,
    (i) => _ParticleData(
      x: (i * 73.7 % 1.0),
      y: (i * 53.3 % 1.0),
      radius: 1.5 + (i % 4) * 1.5,
      speed: 0.3 + (i % 3) * 0.2,
      phase: i * 0.35,
    ),
  );

  const _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < _particles.length; i++) {
      final p = _particles[i];
      final angle = (progress * p.speed + p.phase) * 2 * math.pi;
      final dx = p.x * size.width + math.sin(angle) * 18;
      final dy = p.y * size.height + math.cos(angle) * 14;
      final hue = AppColors.rgbSpectrum[i % (AppColors.rgbSpectrum.length - 1)];
      paint.color = hue.withValues(alpha: 0.22 + 0.18 * math.sin(angle));
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _ParticleData {
  final double x, y, radius, speed, phase;
  const _ParticleData(
      {required this.x,
      required this.y,
      required this.radius,
      required this.speed,
      required this.phase});
}

// ═══════════════════════════════════════════════════════════════════════════
// Glowing "Available" badge
// ═══════════════════════════════════════════════════════════════════════════
class _GlowBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.45), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulsingDot(),
          const SizedBox(width: 8),
          Text(
            'Available for opportunities',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Animated gradient name (shimmer sweep)
// ═══════════════════════════════════════════════════════════════════════════
class _AnimatedGradientName extends StatefulWidget {
  final String name;
  const _AnimatedGradientName({required this.name});

  @override
  State<_AnimatedGradientName> createState() => _AnimatedGradientNameState();
}

class _AnimatedGradientNameState extends State<_AnimatedGradientName>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.shimmerGradient(_c.value).createShader(bounds),
          child: Text(
            widget.name,
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: mobile ? 42 : 68,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.05,
              letterSpacing: -1,
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Avatar with gyroscope/mouse-tracking 3D tilt + animated rings
// ═══════════════════════════════════════════════════════════════════════════
class _AvatarBlock extends StatefulWidget {
  final String imagePath;
  final AnimationController ringController;
  final AnimationController glowController;

  const _AvatarBlock({
    required this.imagePath,
    required this.ringController,
    required this.glowController,
  });

  @override
  State<_AvatarBlock> createState() => _AvatarBlockState();
}

class _AvatarBlockState extends State<_AvatarBlock>
    with SingleTickerProviderStateMixin {
  // Gyroscope / mouse tilt values
  double _rotX = 0; // tilt up/down
  double _rotY = 0; // tilt left/right
  double _glowX = 0.5; // specular highlight position X (0..1)
  double _glowY = 0.5; // specular highlight position Y (0..1)

  late final AnimationController _smoothController;
  late Animation<double> _rotXAnim;
  late Animation<double> _rotYAnim;
  double _targetX = 0;
  double _targetY = 0;

  bool _hover = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _smoothController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )
      ..addListener(() {
        setState(() {
          _rotX += (_targetX - _rotX) * 0.1;
          _rotY += (_targetY - _rotY) * 0.1;
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _smoothController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(event.position);
    final size = box.size;
    // Normalize to -1..1
    final nx = (local.dx / size.width - 0.5) * 2;
    final ny = (local.dy / size.height - 0.5) * 2;
    _targetX = ny * -18; // tilt up when mouse is at top
    _targetY = nx * 18; // tilt right when mouse is right
    _glowX = local.dx / size.width;
    _glowY = local.dy / size.height;
  }

  void _onExit(PointerEvent _) {
    _targetX = 0;
    _targetY = 0;
    _glowX = 0.5;
    _glowY = 0.5;
    setState(() => _hover = false);
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth =
        MediaQuery.sizeOf(context).width - Responsive.pagePadding(context) * 2;
    final maxSize = Responsive.isMobile(context) ? 230.0 : 330.0;
    final sz = (availableWidth - 52).clamp(140.0, maxSize).toDouble();

    return MouseRegion(
      key: _key,
      onHover: (e) {
        setState(() => _hover = true);
        _onHover(e);
      },
      onExit: _onExit,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(_rotX * math.pi / 180)
          ..rotateY(_rotY * math.pi / 180),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Spinning outer sweep ring ────────────────────────────
            AnimatedBuilder(
              animation: widget.ringController,
              builder: (_, __) => Transform.rotate(
                angle: widget.ringController.value * 2 * math.pi,
                child: Container(
                  width: sz + 52,
                  height: sz + 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.rgbSpectrum[0].withValues(alpha: 0.0),
                        AppColors.rgbSpectrum[1].withValues(alpha: 0.55),
                        AppColors.rgbSpectrum[4].withValues(alpha: 0.5),
                        AppColors.rgbSpectrum[6].withValues(alpha: 0.55),
                        AppColors.rgbSpectrum[7].withValues(alpha: 0.45),
                        AppColors.rgbSpectrum[0].withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Counter-spinning dashed ring ─────────────────────────
            AnimatedBuilder(
              animation: widget.ringController,
              builder: (_, __) => Transform.rotate(
                angle: -widget.ringController.value * 2 * math.pi * 0.7,
                child: Container(
                  width: sz + 26,
                  height: sz + 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // ── Glow pulse container ─────────────────────────────────
            AnimatedBuilder(
              animation: widget.glowController,
              builder: (_, child) => Container(
                width: sz + 10,
                height: sz + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                          alpha: 0.28 + 0.22 * widget.glowController.value),
                      blurRadius: 44 + 22 * widget.glowController.value,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withValues(
                          alpha: 0.15 + 0.15 * widget.glowController.value),
                      blurRadius: 64,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: child,
              ),
              child: Container(
                width: sz + 10,
                height: sz + 10,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ── Portrait ──────────────────────────────────
                      Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          size: 96,
                          color: AppColors.textMuted,
                        ),
                      ),

                      // ── Gyroscope specular highlight ───────────────
                      if (_hover)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(
                                  (_glowX - 0.5) * 2,
                                  (_glowY - 0.5) * 2,
                                ),
                                radius: 0.7,
                                colors: [
                                  Colors.white.withValues(alpha: 0.18),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Orbiting dot ─────────────────────────────────────────
            AnimatedBuilder(
              animation: widget.ringController,
              builder: (_, __) {
                final angle = widget.ringController.value * 2 * math.pi;
                final r = (sz + 40) / 2;
                return Transform.translate(
                  offset: Offset(
                    r * math.cos(angle),
                    r * math.sin(angle),
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.85),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── Second orbiting dot ───────────────────────────────────
            AnimatedBuilder(
              animation: widget.ringController,
              builder: (_, __) {
                final angle =
                    widget.ringController.value * 2 * math.pi + math.pi;
                final r = (sz + 40) / 2;
                return Transform.translate(
                  offset: Offset(
                    r * math.cos(angle),
                    r * math.sin(angle),
                  ),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.75),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── "Hover me" hint (disappears after first hover) ───────
            if (!_hover)
              Positioned(
                bottom: 4,
                child: AnimatedOpacity(
                  opacity: _hover ? 0 : 0.6,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mouse, size: 11, color: AppColors.primary),
                        const SizedBox(width: 5),
                        Text(
                          'Hover me',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

// ═══════════════════════════════════════════════════════════════════════════
// Scroll down bouncing arrow
// ═══════════════════════════════════════════════════════════════════════════
class _ScrollDownArrow extends StatefulWidget {
  @override
  State<_ScrollDownArrow> createState() => _ScrollDownArrowState();
}

class _ScrollDownArrowState extends State<_ScrollDownArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, 5 * _c.value),
        child: child,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SCROLL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Pulsing dot
// ═══════════════════════════════════════════════════════════════════════════
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.7, end: 1.3).animate(_c),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Primary button
// ═══════════════════════════════════════════════════════════════════════════
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          transform: Matrix4.identity()..scale(_hover ? 1.05 : 1.0),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.55),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Outline button
// ═══════════════════════════════════════════════════════════════════════════
class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          transform: Matrix4.identity()..scale(_hover ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: _hover
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: _hover
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Social icon
// ═══════════════════════════════════════════════════════════════════════════
class _SocialIcon extends StatefulWidget {
  final FaIconData icon;
  final VoidCallback onTap;
  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 46,
          height: 46,
          transform: Matrix4.identity()..scale(_hover ? 1.18 : 1.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _hover ? AppColors.accentGradient : null,
            color: _hover ? null : Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: _hover
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.2),
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 18,
              color:
                  _hover ? Colors.white : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
