import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'scroll_reveal.dart';

class SectionTitle extends StatelessWidget {
  final String kicker;
  final String title;
  final bool center;

  const SectionTitle({
    super.key,
    required this.kicker,
    required this.title,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return ScrollReveal(
      child: Column(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            kicker.toUpperCase(),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: mobile ? 28 : 38,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 64),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, width, _) => Container(
              height: 4,
              width: width,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
