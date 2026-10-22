
import 'package:ajilesh_portfolio/controllers/nav_provider.dart';
import 'package:ajilesh_portfolio/views/widgets/mouse_parallax_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'hover_scale.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<PortfolioProvider>().skillCategories;

    final mobile = Responsive.isMobile(context);
    final nav = context.read<NavProvider>();
    final tablet = Responsive.isTablet(context);
    final columns = mobile ? 1 : (tablet ? 2 : 4);

    return Stack(
      children: [
        // // ── Full-section background image ──────────────────────
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/wa9.jpeg',
        //     fit: BoxFit.cover,
        //     alignment: Alignment.topCenter,
        //     errorBuilder: (_, __, ___) {
        //       return Container(
        //         decoration: BoxDecoration(
        //           gradient: AppColors.heroGradient,
        //         ),
        //       );
        //     },
        //   ),
        // ),

        Positioned.fill(
  child: ClipRect(
    child: AnimatedBuilder(
      animation: nav.scrollController,
      builder: (context, child) {
        final controller = nav.scrollController;

        final maxScroll = controller.hasClients
            ? controller.position.maxScrollExtent
            : 0.0;

        final offset = controller.hasClients
            ? controller.offset
            : 0.0;

        final progress = maxScroll > 0
            ? (offset / maxScroll).clamp(0.0, 1.0)
            : 0.0;

        final scale = 1.0 + (progress * 0.5);

        final verticalTravel = -50.0 * progress;
        final horizontalTravel = 20.0 * progress;

        return Transform.translate(
          offset: Offset(
            horizontalTravel,
            verticalTravel,
          ),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: Stack(
  children: [
    Positioned.fill(
      child: MouseParallaxBackground(
        imagePath: 'assets/images/cinematic.gif',
        intensity: 25,
        zoom: 1.12,
      ),
    ),

    // Keep your existing Skills section content here.
  ],
)
    ),
  ),
),

        // ── Dark overlay ───────────────────────────────────────
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0E1A)
                      .withValues(alpha: 0.93),
                  const Color(0xFF0A0E1A)
                      .withValues(alpha: 0.86),
                  const Color(0xFF0A0E1A)
                      .withValues(alpha: 0.94),
                ],
              ),
            ),
          ),
        ),

        // ── Bottom fade into the next section ──────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 140,
          child: IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF0A0E1A),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Skills content ────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.pagePadding(context),
              vertical: mobile ? 60 : 100,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      kicker: 'What I Work With',
                      title: 'Skills & Toolbox',
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 220,
                      ),
                      itemBuilder: (context, i) {
                        final cat = categories[i];

                        return ScrollReveal(
                          delay: Duration(
                            milliseconds: 70 * (i % columns),
                          ),
                          child: HoverScale(
                            glowColor: AppColors.primary,
                            child: _SkillCard(
                              title: cat.title,
                              icon: cat.icon,
                              items: cat.items,
                              index: i,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Skill Card
// ═══════════════════════════════════════════════════════════════

class _SkillCard extends StatefulWidget {
  final String title;
  final FaIconData icon;
  final List<String> items;
  final int index;

  const _SkillCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.index,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final grad = AppColors.accentPair(widget.index);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Slight transparency allows the background to feel
          // connected to the skill cards.
          color: AppColors.surfaceLight.withValues(
            alpha: _hover ? 0.97 : 0.90,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hover
                ? grad[0].withValues(alpha: 0.7)
                : AppColors.divider.withValues(alpha: 0.8),
            width: _hover ? 1.5 : 1,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: grad[0].withValues(alpha: 0.25),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box with gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: grad),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _hover
                    ? [
                        BoxShadow(
                          color: grad[0].withValues(alpha: 0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: FaIcon(
                  widget.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Skill category title
            Text(
              widget.title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),

            const SizedBox(height: 10),

            // Skill tags
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final item in widget.items)
                    AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _hover
                            ? grad[0].withValues(alpha: 0.12)
                            : AppColors.background.withValues(
                                alpha: 0.85,
                              ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _hover
                              ? grad[0].withValues(alpha: 0.4)
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: _hover
                              ? grad[0]
                              : AppColors.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
