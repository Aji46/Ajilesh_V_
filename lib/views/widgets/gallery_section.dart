import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';
import 'hover_scale.dart';
import 'scroll_reveal.dart';
import 'section_title.dart';
import 'photo_section_background.dart';

/// "A few more images of me" — an animated photo gallery with a
/// hero-animation lightbox. Swap the placeholder files in
/// assets/images/gallery_*.png with real photos whenever you're ready;
/// no code changes needed as long as the filenames stay the same.
class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.watch<PortfolioProvider>().profile.galleryImages;
    final mobile = Responsive.isMobile(context);
    final tablet = Responsive.isTablet(context);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 380 ? 1 : (mobile ? 2 : (tablet ? 3 : 4));

    return PhotoSectionBackground(
      imagePath: 'assets/images/wa1.jpeg',
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
                const SectionTitle(kicker: 'Snapshots', title: 'Gallery'),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, i) {
                    final tag = 'gallery_$i';
                    return ScrollReveal(
                      delay: Duration(milliseconds: 80 * i),
                      child: HoverScale(
                        scale: 1.05,
                        onTap: () => _openLightbox(context, images, i, tag),
                        child: Hero(
                          tag: tag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.divider),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                images[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceLight,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.image,
                                      color: AppColors.textMuted, size: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                ScrollReveal(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Tap a photo to view it full-screen.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLightbox(
    BuildContext context,
    List<String> images,
    int index,
    String tag,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, anim, __) => FadeTransition(
          opacity: anim,
          child: _Lightbox(images: images, initialIndex: index),
        ),
      ),
    );
  }
}

class _Lightbox extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _Lightbox({required this.images, required this.initialIndex});

  @override
  State<_Lightbox> createState() => _LightboxState();
}

class _LightboxState extends State<_Lightbox> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'gallery_$_index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.images[_index],
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image,
                      color: AppColors.textMuted,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (widget.images.length > 1) ...[
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 36),
                    onPressed: () => setState(() {
                      _index = (_index - 1 + widget.images.length) %
                          widget.images.length;
                    }),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right,
                        color: Colors.white, size: 36),
                    onPressed: () => setState(() {
                      _index = (_index + 1) % widget.images.length;
                    }),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
