import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/nav_provider.dart';
import '../../controllers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  static const _items = [
    ['home', 'Home'],
    ['about', 'About'],
    ['skills', 'Skills'],
    ['experience', 'Experience'],
    ['projects', 'Projects'],
    ['gallery', 'Gallery'],
    ['education', 'Education'],
    ['hire', 'Hire Me'],
    ['contact', 'Contact'],
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final mobile = MediaQuery.sizeOf(context).width < 1280;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.15), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.pagePadding(context),
              vertical: 14,
            ),
            child: Row(
              children: [
                _Logo(onTap: () => nav.scrollToSection('home')),
                const Spacer(),
                if (!mobile)
                  Row(
                    children: [
                      for (final item in _items)
                        _NavLink(
                          label: item[1],
                          isActive: nav.activeSection == item[0],
                          onTap: () => nav.scrollToSection(item[0]),
                        ),
                      const SizedBox(width: 8),
                      const _ThemeToggle(),
                    ],
                  )
                else
                  Row(
                    children: [
                      const _ThemeToggle(),
                      IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              RotationTransition(
                                  turns: Tween(begin: 0.0, end: 0.25)
                                      .animate(anim),
                                  child: FadeTransition(
                                      opacity: anim, child: child)),
                          child: Icon(
                            nav.mobileMenuOpen ? Icons.close : Icons.menu,
                            key: ValueKey(nav.mobileMenuOpen),
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onPressed: nav.toggleMobileMenu,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // ── Mobile slide-down menu ────────────────────────────────────
          if (mobile)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: nav.mobileMenuOpen
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.surface,
                            AppColors.background,
                          ],
                        ),
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.divider, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          for (final item in _items)
                            _NavLink(
                              label: item[1],
                              isActive: nav.activeSection == item[0],
                              onTap: () => nav.scrollToSection(item[0]),
                              fullWidth: true,
                            ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceLight,
      ),
      child: IconButton(
        tooltip: theme.isDark ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: theme.toggleTheme,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            key: ValueKey(theme.isDark),
            color: AppColors.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  bool _hover = false;
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.shimmerGradient(_c.value).createShader(bounds),
              child: const Text(
                'AV.',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool fullWidth;

  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  bool _hover = false;
  late final AnimationController _underlineC = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  @override
  void dispose() {
    _underlineC.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NavLink old) {
    super.didUpdateWidget(old);
    if (widget.isActive) {
      _underlineC.forward();
    } else if (!_hover) {
      _underlineC.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _hover;

    if (active && !_underlineC.isCompleted) {
      _underlineC.forward();
    } else if (!active && !_underlineC.isDismissed) {
      _underlineC.reverse();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          alignment: widget.fullWidth ? Alignment.center : null,
          margin: EdgeInsets.symmetric(
            horizontal: widget.fullWidth ? 0 : 2,
            vertical: widget.fullWidth ? 8 : 0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.fullWidth ? 0 : 12,
            vertical: widget.fullWidth ? 10 : 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: active ? 0.3 : 0,
                ),
                child: Text(widget.label),
              ),
              if (!widget.fullWidth) ...[
                const SizedBox(height: 3),
                AnimatedBuilder(
                  animation: _underlineC,
                  builder: (_, __) => Container(
                    height: 2,
                    width: 28 * _underlineC.value,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
