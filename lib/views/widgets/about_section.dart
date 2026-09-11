import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final profile = portfolio.profile;
    final mobile = Responsive.isMobile(context);

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
        vertical: 90,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(kicker: 'About Me', title: 'Who I Am'),
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

class _AboutText extends StatelessWidget {
  final dynamic profile;
  const _AboutText({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      delay: const Duration(milliseconds: 100),
      child: Text(
        profile.summary,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          height: 1.9,
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
      delay: const Duration(milliseconds: 220),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            for (int i = 0; i < facts.length; i++) ...[
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      facts[i].$1,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      facts[i].$2,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (i != facts.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.divider, height: 1),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
