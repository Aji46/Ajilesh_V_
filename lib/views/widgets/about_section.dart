import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'scroll_reveal.dart';
import 'section_photo_banner.dart';
import 'section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final profile = portfolio.profile;
    final mobile = Responsive.isMobile(context);

    final stats = [
      ('2+', 'Years\nExperience'),
      ('5+', 'Projects\nCompleted'),
      ('2', 'Apps on\nAmazon'),
      ('CEH', 'Ethical\nHacker'),
    ];

    final facts = [
      ('Name', profile.name),
      ('Role', 'Flutter Developer'),
      ('Focus', 'Cyber Security Research'),
      ('Email', profile.email),
      ('Phone', profile.phone),
      ('Based in', 'Kerala, India'),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(kicker: 'About Me', title: 'Who I Am'),
              const SectionPhotoBanner(
                imagePath: 'assets/images/wa8.jpeg',
                eyebrow: 'Life in frames',
                title: 'Curiosity goes beyond the screen.',
                description: 'A few moments from outside the editor.',
                imageAlignment: Alignment.topCenter,
              ),

              // ── Stats row ────────────────────────────────────────────
              ScrollReveal(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: stats
                        .map((s) => _StatCard(value: s.$1, label: s.$2))
                        .toList(),
                  ),
                ),
              ),

              // ── Content row ──────────────────────────────────────────
              mobile
                  ? Column(
                      children: [
                        _AboutText(profile: profile),
                        const SizedBox(height: 30),
                        _FactsGrid(facts: facts),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _AboutText(profile: profile)),
                        const SizedBox(width: 50),
                        Expanded(flex: 5, child: _FactsGrid(facts: facts)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: _hover ? AppColors.accentGradient : null,
          color: _hover ? null : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hover ? Colors.transparent : AppColors.divider,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: TextStyle(
                color: _hover ? Colors.white : AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hover
                    ? Colors.white.withValues(alpha: 0.85)
                    : AppColors.textMuted,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  final dynamic profile;
  const _AboutText({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      delay: const Duration(milliseconds: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.summary,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.95,
            ),
          ),
          const SizedBox(height: 28),
          // ── Download CV button ─────────────────────────────────────
          _GlowButton(
            label: 'Download CV',
            icon: Icons.download_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _GlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GlowButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: _hover ? AppColors.accentGradient : null,
            color: _hover ? null : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hover
                  ? Colors.transparent
                  : AppColors.primary.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: _hover ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hover ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactsGrid extends StatelessWidget {
  final List<(String, String)> facts;
  const _FactsGrid({required this.facts});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            for (int i = 0; i < facts.length; i++) ...[
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 90,
                    child: Text(
                      facts[i].$1,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      facts[i].$2,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              if (i != facts.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(color: AppColors.divider, height: 1),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
