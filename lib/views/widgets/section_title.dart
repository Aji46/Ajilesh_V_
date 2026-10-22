// import 'package:flutter/material.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/responsive.dart';
// import 'scroll_reveal.dart';

// class SectionTitle extends StatelessWidget {
//   final String kicker;
//   final String title;
//   final bool center;

//   const SectionTitle({
//     super.key,
//     required this.kicker,
//     required this.title,
//     this.center = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final mobile = Responsive.isMobile(context);
//     return ScrollReveal(
//       child: Column(
//         crossAxisAlignment:
//             center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
//         children: [
//           // ── Kicker chip ──────────────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(
//                   color: AppColors.primary.withValues(alpha: 0.3)),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColors.accent,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   kicker.toUpperCase(),
//                   style: const TextStyle(
//                     color: AppColors.primary,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),

//           // ── Main title ───────────────────────────────────────────────
//           Text(
//             title,
//             textAlign: center ? TextAlign.center : TextAlign.start,
//             style: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: mobile ? 30 : 42,
//               fontWeight: FontWeight.w900,
//               height: 1.15,
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 16),

//           // ── Animated gradient underline ──────────────────────────────
//           if (!center)
//             TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0, end: 80),
//               duration: const Duration(milliseconds: 1000),
//               curve: Curves.easeOutCubic,
//               builder: (context, width, _) => Stack(
//                 children: [
//                   // base line
//                   Container(
//                     height: 3,
//                     width: double.infinity,
//                     color: AppColors.divider,
//                   ),
//                   // animated fill
//                   Container(
//                     height: 3,
//                     width: width,
//                     decoration: BoxDecoration(
//                       gradient: AppColors.accentGradient,
//                       borderRadius: BorderRadius.circular(3),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primary.withValues(alpha: 0.5),
//                           blurRadius: 8,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }
// }



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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/wa9.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                      ),
                    );
                  },
                ),
              ),

              // Dark overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFF0A0E1A)
                            .withValues(alpha: 0.96),
                        const Color(0xFF0A0E1A)
                            .withValues(alpha: 0.88),
                        const Color(0xFF0A0E1A)
                            .withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom fade
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
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

              // Main title content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? 20 : 40,
                  vertical: mobile ? 32 : 44,
                ),
                child: Column(
                  crossAxisAlignment: center
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    // Kicker chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.primary
                              .withValues(alpha: 0.45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.12),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            kicker.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Main heading
                    Text(
                      title,
                      textAlign:
                          center ? TextAlign.center : TextAlign.start,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: mobile ? 30 : 42,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -0.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 16,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Animated gradient underline
                    if (!center)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 80),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (context, width, _) {
                          return Stack(
                            children: [
                              Container(
                                height: 3,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius:
                                      BorderRadius.circular(3),
                                ),
                              ),
                              Container(
                                height: 3,
                                width: width,
                                decoration: BoxDecoration(
                                  gradient:
                                      AppColors.accentGradient,
                                  borderRadius:
                                      BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.55),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
