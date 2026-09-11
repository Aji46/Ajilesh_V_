import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'hover_scale.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final education = portfolio.education;
    final certificates = portfolio.certificates;
    final mobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
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
              const SectionTitle(
                kicker: 'Background',
                title: 'Education & Certificates',
              ),
              mobile
                  ? Column(
                      children: [
                        _EducationColumn(education: education),
                        const SizedBox(height: 40),
                        _CertificatesColumn(certificates: certificates),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _EducationColumn(education: education)),
                        const SizedBox(width: 40),
                        Expanded(
                            child: _CertificatesColumn(
                                certificates: certificates)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationColumn extends StatelessWidget {
  final List education;
  const _EducationColumn({required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ColumnHeader(icon: FontAwesomeIcons.graduationCap, label: 'Education'),
        const SizedBox(height: 18),
        for (int i = 0; i < education.length; i++)
          ScrollReveal(
            delay: Duration(milliseconds: 100 * i),
            child: HoverScale(
              scale: 1.02,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education[i].qualification,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      education[i].institution,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      education[i].duration,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CertificatesColumn extends StatelessWidget {
  final List certificates;
  const _CertificatesColumn({required this.certificates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ColumnHeader(
            icon: FontAwesomeIcons.certificate, label: 'Certificates'),
        const SizedBox(height: 18),
        for (int i = 0; i < certificates.length; i++)
          ScrollReveal(
            delay: Duration(milliseconds: 100 * i),
            child: HoverScale(
              scale: 1.02,
              glowColor: AppColors.accent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificates[i].title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      certificates[i].issuer,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      certificates[i].duration,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                    if (certificates[i].certificateNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Cert #: ${certificates[i].certificateNumber}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  final FaIconData icon;
  final String label;
  const _ColumnHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: FaIcon(icon, size: 17, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
