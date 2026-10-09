import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'hover_scale.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';
import 'photo_section_background.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<PortfolioProvider>().skillCategories;
    final mobile = Responsive.isMobile(context);
    final tablet = Responsive.isTablet(context);
    final columns = mobile ? 1 : (tablet ? 2 : 4);

    return PhotoSectionBackground(
      imagePath: 'assets/images/wa7.jpeg',
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
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
                const SectionTitle(
                  kicker: 'What I Work With',
                  title: 'Skills & Toolbox',
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 220,
                  ),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return ScrollReveal(
                      delay: Duration(milliseconds: 70 * (i % columns)),
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
    );
  }
}

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

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final grad = AppColors.spectrumPair(widget.index);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hover ? grad[0].withValues(alpha: 0.5) : AppColors.divider,
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
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon box with gradient ──────────────────────────────
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

            // ── Title ───────────────────────────────────────────────
            Text(
              widget.title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 10),

            // ── Tags ────────────────────────────────────────────────
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final item in widget.items)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _hover
                            ? grad[0].withValues(alpha: 0.1)
                            : AppColors.background,
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
                          color: _hover ? grad[0] : AppColors.textSecondary,
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
