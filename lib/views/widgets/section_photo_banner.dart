import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'scroll_reveal.dart';

class SectionPhotoBanner extends StatelessWidget {
  final String imagePath;
  final String eyebrow;
  final String title;
  final String description;
  final Alignment imageAlignment;
  final bool fullHeightImage;

  const SectionPhotoBanner({
    super.key,
    required this.imagePath,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.imageAlignment = Alignment.center,
    this.fullHeightImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        alignment: imageAlignment,
        semanticLabel: title,
      ),
    );

    final copy = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: mobile ? 23 : 30,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.65,
          ),
        ),
      ],
    );

    return ScrollReveal(
      delay: const Duration(milliseconds: 120),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (fullHeightImage) {
              final imageWidth = mobile
                  ? (constraints.maxWidth < 260 ? constraints.maxWidth : 260.0)
                  : (constraints.maxWidth * 0.36 < 340
                      ? constraints.maxWidth * 0.36
                      : 340.0);
              final imageHeight = imageWidth * 16 / 9;
              final shadedImage = ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        alignment: imageAlignment,
                        semanticLabel: title,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              if (mobile) {
                return Column(
                  children: [
                    Center(child: shadedImage),
                    const SizedBox(height: 20),
                    copy,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  shadedImage,
                  const SizedBox(width: 32),
                  Expanded(child: copy),
                ],
              );
            }

            if (mobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 210, child: image),
                  const SizedBox(height: 20),
                  copy,
                ],
              );
            }

            return Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.38,
                  height: 230,
                  child: image,
                ),
                const SizedBox(width: 30),
                Expanded(child: copy),
              ],
            );
          },
        ),
      ),
    );
  }
}
