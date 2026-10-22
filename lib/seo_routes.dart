// lib/seo_routes.dart
//
// PURE DART — no Flutter imports. This file is shared by:
//   • lib/main.dart        (the running app: meta tags + semantic mirror)
//   • bin/prerender.dart   (static HTML for every route, no server needed)
//
// One source of truth: the page text, skills, journey and projects live here,
// so what Google reads and what visitors see can never drift apart.

import 'package:esen_seo/core.dart';

/// Your live domain, no trailing slash.
const siteBase = 'https://ajilesh.in';

// ───────────────────────── shared content ─────────────────────────

const heroIntro =
    'I build fast, polished Flutter apps — from Firebase-backed marketplaces to offline-first tools — with a security researcher’s eye for how things break.';

const aboutText =
    'Passionate and dedicated Flutter mobile app developer specializing in creating efficient, user-friendly applications. Proficient in Dart and well-versed in UI/UX design principles, with a commitment to staying ahead in the rapidly evolving mobile landscape. I aim to deliver impactful solutions that exceed expectations through innovation and collaboration.';

const aboutBadges = <String>[
  'Certified Ethical Hacker',
  'Certified Penetration Tester',
  '2 apps on Amazon Appstore',
  'Brototype · Flutter 2023–24',
];

const skillGroups = <String, List<String>>{
  'Language': ['Dart'],
  'Framework': ['Flutter'],
  'State management': ['Bloc', 'GetX', 'Provider'],
  'Databases': ['Hive', 'Firebase', 'sqflite'],
  'Tools': ['Git', 'GitHub', 'Figma'],
  'Deployment': ['Amazon App Store'],
  'Proficient in': ['Data Structures', 'Third-party Integrations', 'REST APIs'],
  'Familiar with': [
    'JavaScript',
    'C',
    'HTML',
    'CSS',
    'MVC Architecture',
    'Code Optimization',
  ],
};

typedef JourneyItem = ({String title, String org, String period});

const experience = <JourneyItem>[
  (
    title: 'Flutter Developer',
    org: 'Softroniics',
    period: 'May 8, 2026 – Present',
  ),
  (
    title: 'Junior Software Consultant – R&D',
    org: 'Datamate Info Solution Limited',
    period: 'Mar 17, 2025 – Oct 31, 2025',
  ),
];

const certifications = <JourneyItem>[
  (
    title: 'Certified Penetration Tester',
    org: 'RedTeam Hacker Academy, Perinthalmanna',
    period: 'Jun 13 – Aug 20, 2022',
  ),
  (
    title: 'Certified Ethical Hacker',
    org: 'EC-Council (RedTeam Hacker Academy) · ECC5876913240',
    period: 'Nov 22 – Dec 23, 2022',
  ),
];

const education = <JourneyItem>[
  (
    title: 'Mobile App Development Using Flutter',
    org: 'Brototype, Calicut',
    period: '2023 – 2024',
  ),
  (
    title: 'Bachelor of Computer Application',
    org: 'GEMS Arts and Science College, Perinthalmanna',
    period: '2019 – 2022',
  ),
  (
    title: 'Computer Science & Information Technology',
    org: 'S H M G VHSS, Edavanna',
    period: '2017 – 2019',
  ),
  (title: 'S S L C', org: 'V M C G H S S, Wandoor', period: '2017'),
];

typedef Project = ({
  String name,
  String description,
  List<String> tags,
  Map<String, String> links,
});

const projects = <Project>[
  (
    name: 'Quokart',
    description:
        'Used-product marketplace connecting users with deals and offers. Multi-method login (email, phone, Google), category browsing, location-based deals, and an admin panel for categories and products. MVC architecture with Provider.',
    tags: ['Flutter', 'Firebase', 'Provider', 'MVC'],
    links: {
      'Live (Amazon)': 'https://www.amazon.in/Brototype-Quokart/dp/B0DKNRMM8C/',
      'User app': 'https://github.com/Aji46/Quick_deals_User_side',
      'Admin app': 'https://github.com/Aji46/Quick-O-Deals-Admin',
    },
  ),
  (
    name: 'DropBlood',
    description:
        'Blood donation app connecting donors and recipients with real-time updates, Firebase authentication, secure data handling, and Hive for offline access.',
    tags: ['Flutter', 'Firebase', 'Hive'],
    links: {
      'Live (Amazon)': 'https://www.amazon.in/dp/B0DPTG9PWM/',
      'GitHub': 'https://github.com/Aji46/Reddrop_new',
    },
  ),
  (
    name: 'Mini projects',
    description:
        'Student Management app in GetX and Provider + Hive versions, and a Netflix clone built with Flutter and the TMDB API with responsive UI and movie search.',
    tags: ['GetX', 'Provider', 'Hive', 'TMDB API'],
    links: {
      'Student · GetX': 'https://github.com/Aji46/student_app_getx',
      'Student · Provider': 'https://github.com/Aji46/student-app-provider',
      'Netflix clone': 'https://github.com/Aji46/Netflix_clone',
    },
  ),
];

// ───────────────────────── shared HTML nodes ─────────────────────────
// Used by BOTH the app (via .seoNodes) and the route bodies below, so the
// mirror in the running app and the prerendered pages are identical.

SeoNode _a(String text, String href) =>
    SeoNode(tag: 'a', text: text, attributes: {'href': href});

SeoNode chipListNode(List<String> items) => SeoNode(
      tag: 'ul',
      children: [for (final i in items) SeoNode(tag: 'li', text: i)],
    );

SeoNode skillGroupNode(String title, List<String> items) => SeoNode(
      tag: 'section',
      children: [
        SeoNode(tag: 'h2', text: title),
        chipListNode(items),
      ],
    );

SeoNode journeySectionNode(String label, List<JourneyItem> items) => SeoNode(
      tag: 'section',
      children: [
        SeoNode(tag: 'h2', text: label),
        for (final i in items)
          SeoNode(
            tag: 'article',
            children: [
              SeoNode(tag: 'h3', text: i.title),
              SeoNode(tag: 'p', text: i.org),
              SeoNode(tag: 'p', children: [SeoNode(tag: 'time', text: i.period)]),
            ],
          ),
      ],
    );

SeoNode projectNode(Project p) => SeoNode(
      tag: 'article',
      children: [
        SeoNode(tag: 'h2', text: p.name),
        SeoNode(tag: 'p', text: p.description),
        chipListNode(p.tags),
        SeoNode(
          tag: 'ul',
          children: [
            for (final e in p.links.entries)
              SeoNode(tag: 'li', children: [_a(e.key, e.value)]),
          ],
        ),
      ],
    );

// ───────────────────────── pages (one per scene) ─────────────────────────

class SeoPageData {
  SeoPageData({
    required this.path,
    required this.name,
    required this.h1,
    required this.title,
    required this.description,
    required this.body,
  });

  final String path;
  final String name; // short name for nav + breadcrumbs
  final String h1; // the ONE h1 of this page
  final String title; // <title> (≈ 50–60 chars)
  final String description; // meta description (≈ 120–160 chars)
  final List<SeoNode> Function(SeoPageData page) body;

  String get url => path == '/' ? '$siteBase/' : '$siteBase$path';

  SeoMeta meta() => SeoMeta(
        title: title,
        description: description,
        canonicalUrl: url,
        openGraph: OpenGraphMeta(image: '$siteBase/og.png'),
        schemas: [
          if (path != '/')
            SeoSchema.breadcrumbs([
              (name: 'Home', url: '$siteBase/'),
              (name: name, url: url),
            ]),
        ],
      );
}

/// Order MUST match the scene order in main.dart (Home, About, Skills,
/// Journey, Projects, Contact).
final seoPages = <SeoPageData>[
  SeoPageData(
    path: '/',
    name: 'Home',
    h1: 'Ajilesh V — Flutter Developer & Cyber Security Researcher',
    title: 'Ajilesh V — Flutter Developer & Cyber Security Researcher',
    description:
        'Flutter developer and cyber security researcher. I build fast, polished Flutter apps with Firebase, Bloc, GetX and Provider.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      SeoNode(tag: 'p', text: heroIntro),
      SeoNode(tag: 'ul', children: [
        SeoNode(tag: 'li', children: [_a('GitHub', 'https://github.com/Aji46')]),
        SeoNode(tag: 'li', children: [
          _a('LinkedIn', 'https://www.linkedin.com/in/ajilesh-v-/'),
        ]),
        SeoNode(tag: 'li', children: [
          _a('LeetCode', 'https://leetcode.com/u/Aji46/'),
        ]),
      ]),
    ],
  ),
  SeoPageData(
    path: '/about',
    name: 'About',
    h1: 'About Ajilesh V',
    title: 'About Ajilesh V — Flutter Developer & Ethical Hacker',
    description:
        'Flutter app developer, Certified Ethical Hacker and Certified Penetration Tester with two apps published on the Amazon Appstore.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      SeoNode(tag: 'p', text: aboutText),
      chipListNode(aboutBadges),
    ],
  ),
  SeoPageData(
    path: '/skills',
    name: 'Skills',
    h1: 'Skills & stack',
    title: 'Skills & Tech Stack — Ajilesh V, Flutter Developer',
    description:
        'Dart, Flutter, Bloc, GetX, Provider, Hive, Firebase, sqflite and REST APIs — the tools Ajilesh V uses to ship Flutter apps.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      for (final e in skillGroups.entries) skillGroupNode(e.key, e.value),
    ],
  ),
  SeoPageData(
    path: '/journey',
    name: 'Journey',
    h1: 'Journey — experience, certifications and education',
    title: 'Experience, Certifications & Education — Ajilesh V',
    description:
        'Flutter Developer at Softroniics, previously R&D at Datamate Info Solution. Certified Ethical Hacker and Penetration Tester.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      journeySectionNode('Experience', experience),
      journeySectionNode('Certifications', certifications),
      journeySectionNode('Education', education),
    ],
  ),
  SeoPageData(
    path: '/projects',
    name: 'Projects',
    h1: 'Projects — Flutter apps by Ajilesh V',
    title: 'Flutter Projects — Quokart, DropBlood & More | Ajilesh V',
    description:
        'Selected Flutter work: the Quokart marketplace and DropBlood donation app (both on Amazon Appstore) plus GetX, Provider and Hive projects.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      for (final pr in projects) projectNode(pr),
    ],
  ),
  SeoPageData(
    path: '/contact',
    name: 'Contact',
    h1: 'Contact Ajilesh V — ready to take the leap?',
    title: 'Contact Ajilesh V — Hire a Flutter Developer',
    description:
        'Have an app idea, a product to ship or a security question? Reach Ajilesh V by WhatsApp, email, phone or LinkedIn.',
    body: (p) => [
      SeoNode(tag: 'h1', text: p.h1),
      SeoNode(
        tag: 'p',
        text:
            'Have an app idea, a product to ship, or a security question? Let’s talk.',
      ),
      SeoNode(tag: 'ul', children: [
        SeoNode(tag: 'li', children: [_a('WhatsApp', 'https://wa.me/918943381295')]),
        SeoNode(tag: 'li', children: [
          _a('ajilesh46@gmail.com', 'mailto:ajilesh46@gmail.com'),
        ]),
        SeoNode(tag: 'li', children: [_a('+91 89433 81295', 'tel:+918943381295')]),
        SeoNode(tag: 'li', children: [
          _a('LinkedIn', 'https://www.linkedin.com/in/ajilesh-v-/'),
        ]),
        SeoNode(tag: 'li', children: [_a('GitHub', 'https://github.com/Aji46')]),
      ]),
    ],
  ),
];

/// The route table used by the prerenderer (and by an SSR server, if you
/// ever add one).
final seoRoutes = [
  for (final p in seoPages)
    SeoRoute(
      path: p.path,
      meta: (_) => p.meta(),
      body: (_) => p.body(p),
    ),
];
