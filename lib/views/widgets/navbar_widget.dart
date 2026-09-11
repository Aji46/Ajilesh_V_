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
    final mobile = Responsive.isMobile(context) || Responsive.isTablet(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: AppColors.background.withValues(alpha: 0.92),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.pagePadding(context),
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
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
          if (mobile)
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              child: nav.mobileMenuOpen
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
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
    return IconButton(
      tooltip: theme.isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: theme.toggleTheme,
      icon: Icon(
        theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.accentGradient.createShader(bounds),
        child: const Text(
          'AV.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
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

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _hover;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          alignment: widget.fullWidth ? Alignment.center : null,
          margin: EdgeInsets.symmetric(
            horizontal: widget.fullWidth ? 0 : 14,
            vertical: widget.fullWidth ? 10 : 0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: active ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
