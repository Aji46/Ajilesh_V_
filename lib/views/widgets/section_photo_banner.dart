import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'scroll_reveal.dart';

class SectionPhotoBanner extends StatefulWidget {
  final String imagePath;
  final String eyebrow;
  final String title;
  final String description;
  final Alignment imageAlignment;
  final bool fullHeightImage;
  final double? customHeight;

  const SectionPhotoBanner({
    super.key,
    required this.imagePath,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.imageAlignment = Alignment.center,
    this.fullHeightImage = false,
    this.customHeight,
  });

  @override
  State<SectionPhotoBanner> createState() => _SectionPhotoBannerState();
}

class _SectionPhotoBannerState extends State<SectionPhotoBanner> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    Widget buildImageCard({required double width, required double height}) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: _hovered ? 28 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Zoom animation on hover
                AnimatedScale(
                  scale: _hovered ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    alignment: widget.imageAlignment,
                    semanticLabel: widget.title,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                // Subtle gradient overlay at bottom
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                ),
                // Corner badge hint
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: AnimatedOpacity(
                    opacity: _hovered ? 1.0 : 0.7,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _hovered ? Icons.zoom_in : Icons.photo_camera,
                            size: 13,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _hovered ? 'Zoomed' : 'Featured',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final copy = Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            widget.eyebrow.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.title,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: mobile ? 22 : 28,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.description,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.5,
            height: 1.65,
          ),
        ),
      ],
    );

    return ScrollReveal(
      delay: const Duration(milliseconds: 120),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isStacked = constraints.maxWidth < 820;

            if (isStacked) {
              final cardWidth = constraints.maxWidth;
              final cardHeight = widget.customHeight ??
                  (widget.fullHeightImage ? 360.0 : 280.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: buildImageCard(
                      width: cardWidth,
                      height: cardHeight,
                    ),
                  ),
                  const SizedBox(height: 22),
                  copy,
                ],
              );
            }

            final cardWidth = widget.fullHeightImage
                ? (constraints.maxWidth * 0.38).clamp(280.0, 360.0)
                : (constraints.maxWidth * 0.42).clamp(300.0, 420.0);
            final cardHeight = widget.customHeight ??
                (widget.fullHeightImage ? 420.0 : 310.0);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildImageCard(width: cardWidth, height: cardHeight),
                const SizedBox(width: 36),
                Expanded(child: copy),
              ],
            );
          },
        ),
      ),
    );
  }
}
