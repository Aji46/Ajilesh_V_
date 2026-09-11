import 'package:ajilesh_portfolio/views/widgets/hireme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../controllers/nav_provider.dart';
import '../controllers/theme_provider.dart';
import 'widgets/navbar_widget.dart';
import 'widgets/hero_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/gallery_section.dart';
import 'widgets/education_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/footer_widget.dart';

/// VIEW LAYER (V in MVC)
/// Composes every section, wraps each one in a VisibilityDetector so the
/// navbar can auto-highlight the section currently on screen, and attaches
/// the GlobalKeys the NavProvider uses for smooth "scroll to section".
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavProvider>();
    context.watch<ThemeProvider>();

    Widget trackedSection(String key, Widget child) {
      return VisibilityDetector(
        key: Key('track_$key'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.45) {
            nav.setActiveSection(key);
          }
        },
        child: Container(key: nav.sectionKeys[key], child: child),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const NavbarWidget(),
          Expanded(
            child: SingleChildScrollView(
              controller: nav.scrollController,
              child: Column(
                children: [
                  trackedSection('home', HeroSection()),
                  trackedSection('about', AboutSection()),
                  trackedSection('skills', SkillsSection()),
                  trackedSection('experience', ExperienceSection()),
                  trackedSection('projects', ProjectsSection()),
                  trackedSection('gallery', GallerySection()),
                  trackedSection('education', EducationSection()),
                  trackedSection('hire', HireMePage()),
                  trackedSection('contact', ContactSection()),

                  FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
