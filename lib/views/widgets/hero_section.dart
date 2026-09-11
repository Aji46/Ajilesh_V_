import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/nav_provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.read<PortfolioProvider>();
    final nav = context.read<NavProvider>();
    final profile = portfolio.profile;
    final mobile = Responsive.isMobile(context);

    final textColumn = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 700),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulsingDot(),
                SizedBox(width: 8),
                Text(
                  'Available for opportunities',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        FadeInUp(
          delay: const Duration(milliseconds: 150),
          duration: const Duration(milliseconds: 700),
          child: Text(
            'Hi, I\'m',
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeInUp(
          delay: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 700),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.accentGradient.createShader(bounds),
            child: Text(
              profile.name,
              textAlign: mobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontSize: mobile ? 42 : 64,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.05,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeInUp(
          delay: const Duration(milliseconds: 350),
          duration: const Duration(milliseconds: 700),
          child: SizedBox(
            height: 34,
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
              child: Text(
                _roles[_roleIndex],
                key: ValueKey(_roleIndex),
                textAlign: mobile ? TextAlign.center : TextAlign.start,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 450),
          duration: const Duration(milliseconds: 700),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              profile.summary,
              textAlign: mobile ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                fontSize: 15.5,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
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
        const SizedBox(height: 34),
        FadeInUp(
          delay: const Duration(milliseconds: 650),
          duration: const Duration(milliseconds: 700),
          child: Wrap(
            alignment: mobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 16,
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
          final dy = (_floatController.value - 0.5) * 16;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: _AvatarBlock(imagePath: profile.profileImage),
      ),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: mobile ? 60 : 110,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: mobile
              ? Column(children: [avatar, const SizedBox(height: 40), textColumn])
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
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  final String imagePath;
  const _AvatarBlock({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.isMobile(context) ? 220.0 : 320.0;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 60,
            spreadRadius: 6,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: AppColors.surface,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.person,
              size: 96,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

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
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          transform: Matrix4.identity()..scale(_hover ? 1.04 : 1.0),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

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
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          transform: Matrix4.identity()..scale(_hover ? 1.04 : 1.0),
          decoration: BoxDecoration(
            color: _hover ? AppColors.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1.4),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

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
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          transform: Matrix4.identity()..scale(_hover ? 1.15 : 1.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover ? AppColors.primary : AppColors.surfaceLight,
            border: Border.all(color: AppColors.divider),
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 18,
              color: _hover ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
