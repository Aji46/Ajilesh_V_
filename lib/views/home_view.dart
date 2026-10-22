// // import 'package:ajilesh_portfolio/views/widgets/hireme.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:visibility_detector/visibility_detector.dart';
// // import '../controllers/nav_provider.dart';
// // import '../controllers/theme_provider.dart';
// // import 'widgets/cursor_widget.dart';
// // import 'widgets/navbar_widget.dart';
// // import 'widgets/hero_section.dart';
// // import 'widgets/about_section.dart';
// // import 'widgets/skills_section.dart';
// // import 'widgets/experience_section.dart';
// // import 'widgets/projects_section.dart';
// // import 'widgets/gallery_section.dart';
// // import 'widgets/education_section.dart';
// // import 'widgets/contact_section.dart';
// // import 'widgets/footer_widget.dart';
// // import 'widgets/portfolio_assistant.dart';
// // import 'widgets/scroll_reveal.dart';
// // import 'widgets/photo_section_background.dart';

// // /// VIEW LAYER (V in MVC)
// // /// Composes every section, wraps each one in a VisibilityDetector so the
// // /// navbar can auto-highlight the section currently on screen, and attaches
// // /// the GlobalKeys the NavProvider uses for smooth "scroll to section".
// // class HomeView extends StatelessWidget {
// //   const HomeView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final nav = context.read<NavProvider>();
// //     context.watch<ThemeProvider>();

// //     Widget trackedSection(String key, Widget child) {
// //       return VisibilityDetector(
// //         key: Key('track_$key'),
// //         onVisibilityChanged: (info) {
// //           if (info.visibleFraction > 0.45) {
// //             nav.setActiveSection(key);
// //           }
// //         },
// //         child: Container(key: nav.sectionKeys[key], child: child),
// //       );
// //     }

// //     return CustomCursorOverlay(
// //       child: Scaffold(
// //         floatingActionButton: const PortfolioAssistantButton(),
// //         body: Column(
// //           children: [
// //             const NavbarWidget(),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 controller: nav.scrollController,
// //                 child: Column(
// //                   children: [
// //                     trackedSection('home', const HeroSection()),
// //                     trackedSection('about', const AboutSection()),
// //                     trackedSection('skills', const SkillsSection()),
// //                     trackedSection('experience', const ExperienceSection()),
// //                     trackedSection('projects', const ProjectsSection()),
// //                     trackedSection('gallery', const GallerySection()),
// //                     trackedSection('education', const EducationSection()),
// //                     trackedSection('hire', const HireMePage()),
// //                     trackedSection('contact', const ContactSection()),
// //                     const ScrollReveal(
// //                       child: PhotoSectionBackground(
// //                         imagePath: 'assets/images/wa6.jpeg',
// //                         alignment: Alignment.center,
// //                         child: FooterWidget(),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:ajilesh_portfolio/views/widgets/closing_shot_background.dart';
// import 'package:ajilesh_portfolio/views/widgets/hireme.dart';
// import 'package:ajilesh_portfolio/views/widgets/photo_section_background.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// import '../controllers/nav_provider.dart';
// import '../controllers/theme_provider.dart';

// import 'widgets/cursor_widget.dart';
// import 'widgets/navbar_widget.dart';
// import 'widgets/hero_section.dart';
// import 'widgets/about_section.dart';
// import 'widgets/skills_section.dart';
// import 'widgets/experience_section.dart';
// import 'widgets/projects_section.dart';
// import 'widgets/gallery_section.dart';
// import 'widgets/education_section.dart';
// import 'widgets/contact_section.dart';
// import 'widgets/footer_widget.dart';
// import 'widgets/portfolio_assistant.dart';
// import 'widgets/scroll_reveal.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final nav = context.read<NavProvider>();
//     final themeProvider = context.watch<ThemeProvider>();

//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     Widget trackedSection(String sectionKey, Widget child) {
//       return VisibilityDetector(
//         key: Key('track_$sectionKey'),
//         onVisibilityChanged: (info) {
//           if (info.visibleFraction > 0.45) {
//             nav.setActiveSection(sectionKey);
//           }
//         },
//         child: Container(
//           key: nav.sectionKeys[sectionKey],
//           child: child,
//         ),
//       );
//     }

//     return CustomCursorOverlay(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         floatingActionButton: const PortfolioAssistantButton(),
//         body: Stack(
//           children: [
//             // One continuous background behind the entire portfolio.
//             Positioned.fill(
//               child: AnimatedBuilder(
//                 animation: nav.scrollController,
//                 builder: (context, child) {
//                   final controller = nav.scrollController;

//                   final maxScroll = controller.hasClients
//                       ? controller.position.maxScrollExtent
//                       : 0.0;

//                   final offset =
//                       controller.hasClients ? controller.offset : 0.0;

//                   final progress = maxScroll > 0
//                       ? (offset / maxScroll).clamp(0.0, 1.0)
//                       : 0.0;

//                   // Gradually zoom and travel as the user scrolls.
//                   final scale = 1.08 + (progress * 0.24);
//                   final verticalTravel = -65.0 * progress;
//                   final horizontalTravel = 18.0 * progress;

//                   return ClipRect(
//                     child: Transform.translate(
//                       offset: Offset(
//                         horizontalTravel,
//                         verticalTravel,
//                       ),
//                       child: Transform.scale(
//                         scale: scale,
//                         alignment: Alignment.topCenter,
//                         child: Image.asset(
//                           'assets/images/wa9.jpeg',
//                           fit: BoxFit.cover,
//                           alignment: Alignment.topCenter,
//                           width: double.infinity,
//                           height: double.infinity,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const ColoredBox(
//                               color: Color(0xFF10131C),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Readability overlay; the image remains visible underneath.
//             Positioned.fill(
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 350),
//                 color: isDark
//                     ? Colors.black.withValues(alpha: 0.60)
//                     : Colors.white.withValues(alpha: 0.72),
//               ),
//             ),

//             // Subtle cinematic gradient over the full background.
//             Positioned.fill(
//               child: IgnorePointer(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: isDark
//                           ? [
//                               Colors.black.withValues(alpha: 0.12),
//                               Colors.transparent,
//                               Colors.black.withValues(alpha: 0.40),
//                             ]
//                           : [
//                               Colors.white.withValues(alpha: 0.18),
//                               Colors.transparent,
//                               Colors.white.withValues(alpha: 0.28),
//                             ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Foreground content.
//             Column(
//               children: [
//                 const NavbarWidget(),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     controller: nav.scrollController,
//                     physics: const ClampingScrollPhysics(),
//                     child: Column(
//                       children: [
//                         trackedSection(
//                           'home',
//                           PhotoSectionBackground(
//                             imagePath: 'assets/images/wa9.jpeg',
//                             child: const HeroSection(),
//                           ),
//                         ),
//                         trackedSection(
//                           'about',
//                           PhotoSectionBackground(
//                               imagePath: 'assets/images/wa5.jpeg',
//                               child: const AboutSection()),
//                         ),
//                     trackedSection(
//   'skills',
//   PhotoSectionBackground(
//     imagePath: 'assets/images/wa2.jpeg',
//     child: const SkillsSection(),
//   ),
// ),
//                         trackedSection(
//                           'experience',
//                           PhotoSectionBackground(
//                             imagePath: 'assets/images/wa6.jpeg',
//                             child: const ExperienceSection(),
//                           ),
//                         ),
//                 trackedSection(
//   'projects',
//   PhotoSectionBackground(
//     imagePath: 'assets/images/wa7.jpeg',
//     child: const ProjectsSection(),
//   ),
// ),
//                         trackedSection(
//                           'gallery',
//                           PhotoSectionBackground(
//                             imagePath: 'assets/images/wa5.jpeg',
//                             child: const GallerySection(),
//                           ),
//                         ),
//                         trackedSection(
//                           'education',
//                           PhotoSectionBackground(
//                             imagePath: 'assets/images/wa3.jpeg',
//                             child: const EducationSection(),
//                           ),
//                         ),
//                         trackedSection(
//                           'hire',
//                           PhotoSectionBackground(
//                             imagePath: 'assets/images/wa1.jpeg',
//                             child: const HireMePage(),
//                           ),
//                         ),
//                      trackedSection(
//   'contact',
//   PhotoSectionBackground(
//     imagePath: 'assets/images/wa9.jpeg',
//     alignment: Alignment.center,
//     child: const ContactSection(),
//   ),
// ),
//                         const ScrollReveal(
//                           child: FooterWidget(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
