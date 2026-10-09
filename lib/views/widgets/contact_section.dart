import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'hover_scale.dart';
import 'scroll_reveal.dart';
import 'photo_section_background.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final profile = portfolio.profile;
    final mobile = Responsive.isMobile(context);

    final contactCards = [
      (
        FontAwesomeIcons.envelope,
        'Email',
        profile.email,
        portfolio.launchEmail,
      ),
      (
        FontAwesomeIcons.phone,
        'Phone',
        profile.phone,
        portfolio.launchPhone,
      ),
      (
        FontAwesomeIcons.linkedinIn,
        'LinkedIn',
        'ajilesh-v-',
        () => portfolio.launchUrlString(profile.linkedInUrl),
      ),
      (
        FontAwesomeIcons.instagram,
        'Instagram',
        '@ajilesh_________',
        () => portfolio.launchUrlString(profile.instagramUrl),
      ),
      (
        FontAwesomeIcons.github,
        'GitHub',
        'View my repos',
        () => portfolio.launchUrlString(profile.githubUrl),
      ),
    ];

    return PhotoSectionBackground(
      imagePath: 'assets/images/wa4.jpeg',
      alignment: Alignment.topCenter,
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
                // const SectionTitle(
                //   // kicker: 'Get In Touch',
                //   // title: 'Let\'s Build Something Great',
                // ),
                ScrollReveal(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      'Open to freelance projects, full-time roles, and interesting '
                      'collaborations across Flutter development and cyber '
                      'security research. Reach out through any channel below.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    for (int i = 0; i < contactCards.length; i++)
                      ScrollReveal(
                        delay: Duration(milliseconds: 90 * i),
                        child: HoverScale(
                          onTap: contactCards[i].$4,
                          child: Container(
                            width: mobile ? double.infinity : 230,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      contactCards[i].$1,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contactCards[i].$2,
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        contactCards[i].$3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
