import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/profile_model.dart';
import '../models/skill_model.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';

/// Central place holding all the *content* pulled from Ajilesh's CV.
/// Edit this file to update text, links, or swap in new asset paths —
/// nothing else in the app needs to change.
class AppData {
  AppData._();

  static const profile = ProfileModel(
    name: 'Ajilesh V',
    title: 'Flutter Developer | Cyber Security Researcher',
    summary:
        'Passionate and dedicated Flutter mobile app developer specializing in '
        'creating efficient, user-friendly applications. Proficient in Dart '
        'programming and well-versed in UI/UX design principles. Skilled in '
        'modern frameworks and tools, with a commitment to staying ahead in the '
        'rapidly evolving mobile app development landscape. Aiming to deliver '
        'impactful solutions that exceed expectations through innovation and '
        'collaboration.',
    phone: '+91 8943381295',
    email: 'ajilesh46@gmail.com',
    linkedInUrl:
        'https://www.linkedin.com/in/ajilesh-v-?utm_source=share_via&utm_content=profile&utm_medium=member_ios',
    // TODO: replace with your real GitHub profile URL
    githubUrl: 'https://github.com/ajilesh46',
    instagramUrl:
        'https://www.instagram.com/ajilesh_________?stkn=bHJ2dW12czV0NGFs&utm_source=qr',
    leetcodeUrl: 'https://leetcode.com/',
    profileImage: 'assets/images/wa4.jpeg',
    galleryImages: [
      'assets/images/wa1.jpeg',
      'assets/images/wa2.jpeg',
      'assets/images/wa3.jpeg',
      'assets/images/wa5.jpeg',
    ],
  );

  static const skillCategories = <SkillCategory>[
    SkillCategory(
      title: 'Programming Languages',
      icon: FontAwesomeIcons.code,
      items: ['Dart'],
    ),
    SkillCategory(
      title: 'Frameworks',
      icon: FontAwesomeIcons.mobileScreenButton,
      items: ['Flutter'],
    ),
    SkillCategory(
      title: 'Databases',
      icon: FontAwesomeIcons.database,
      items: ['Hive', 'Firebase', 'SQflite'],
    ),
    SkillCategory(
      title: 'Deployment & Hosting',
      icon: FontAwesomeIcons.cloudArrowUp,
      items: ['Amazon App Store'],
    ),
    SkillCategory(
      title: 'Development Tools',
      icon: FontAwesomeIcons.toolbox,
      items: ['Git', 'GitHub', 'Figma'],
    ),
    SkillCategory(
      title: 'State Management',
      icon: FontAwesomeIcons.diagramProject,
      items: ['Bloc', 'GetX', 'Provider'],
    ),
    SkillCategory(
      title: 'Proficient In',
      icon: FontAwesomeIcons.star,
      items: ['Data Structures', 'Third-party Integrations', 'REST APIs'],
    ),
    SkillCategory(
      title: 'Familiar With',
      icon: FontAwesomeIcons.layerGroup,
      items: [
        'JavaScript',
        'C',
        'HTML',
        'CSS',
        'MVC Architecture',
        'Code Optimization',
      ],
    ),
  ];

  static const experience = <ExperienceModel>[
    ExperienceModel(
      company: 'Datamate Info Solution Limited',
      role: 'Junior Software Consultant — R & D',
      duration: 'March 17, 2025 – October 31, 2025',
      referenceNote: 'Reference for verification: +91 94477 39393 (jabin.j@mediwarehms.com)',
    ),
  ];

  static const projects = <ProjectModel>[
    ProjectModel(
      title: 'Quokart',
      description:
          'A Flutter-based used-product selling application designed to connect '
          'users with deals and offers. Firebase backend, Provider for state '
          'management, MVC architecture for a clean, scalable codebase.',
      bullets: [
        'Authentication: Multi-method login (email/password, phone, Google)',
        'User Features: Browse products by category — electronics, fashion, groceries',
        'Admin Panel: Manage categories and products seamlessly',
        'Location Services: Geographically relevant deals',
        'Responsive UI with smooth transitions',
      ],
      techStack: ['Dart', 'Flutter', 'Firebase', 'Provider'],
      liveLink: 'https://example.com/quokart-live',
      extraLinks: {
        'GitHub — User': 'https://github.com/ajilesh46/quokart-user',
        'GitHub — Admin': 'https://github.com/ajilesh46/quokart-admin',
      },
    ),
    ProjectModel(
      title: 'DropBlood',
      description:
          'A blood donation app enabling seamless connections between donors and '
          'recipients, with an emphasis on secure and reliable user data '
          'management.',
      bullets: [
        'Real-time updates with Firebase integration for authentication',
        'Hive for offline accessibility',
        'User-friendly design ensuring confidentiality',
      ],
      techStack: ['Dart', 'Flutter', 'Hive', 'Firebase'],
      liveLink: 'https://example.com/dropblood-live',
      githubLink: 'https://github.com/ajilesh46/dropblood',
    ),
    ProjectModel(
      title: 'Student Management Application (GetX Version)',
      description:
          'Student data management app leveraging GetX for enhanced state '
          'management.',
      techStack: ['Dart', 'Flutter', 'GetX'],
      githubLink: 'https://github.com/ajilesh46/student-management-getx',
    ),
    ProjectModel(
      title: 'Student Management Application (Provider Version)',
      description:
          'Streamlined student data management using Flutter, Provider state '
          'management, and Hive database.',
      techStack: ['Dart', 'Flutter', 'Provider', 'Hive'],
      githubLink: 'https://github.com/ajilesh46/student-management-provider',
    ),
    ProjectModel(
      title: 'Netflix Video Clone',
      description:
          'Built with Flutter and the TMDB API, featuring a responsive UI and '
          'movie search functionality.',
      techStack: ['Dart', 'Flutter', 'TMDB API'],
      githubLink: 'https://github.com/ajilesh46/netflix-clone',
    ),
  ];

  static const education = <EducationModel>[
    EducationModel(
      institution: 'Brototype, Calicut',
      qualification: 'Mobile App Development Using Flutter',
      duration: '2023 – 2024',
    ),
    EducationModel(
      institution: 'GEMS Arts And Science College, Perinthalmanna, India',
      qualification:
          'Bachelor of Computer Application — Computer Science and Information Technology',
      duration: '2019 – 2022',
    ),
    EducationModel(
      institution: 'S H M G VHSS, Edavanna, India',
      qualification: 'Higher Secondary (+2)',
      duration: '2017 – 2019',
    ),
    EducationModel(
      institution: 'V M C G H S S, Wandoor, India',
      qualification: 'S S L C',
      duration: '2017',
    ),
  ];

  static const certificates = <CertificateModel>[
    CertificateModel(
      title: 'Certified Penetration Tester',
      issuer: 'RedTeam Hacker Academy — Perinthalmanna, India',
      duration: '13/06/2022 – 20/08/2022',
    ),
    CertificateModel(
      title: 'Certified Ethical Hacker',
      issuer: 'EC-Council (RedTeam Hacker Academy) — Perinthalmanna, India',
      duration: '22/11/2022 – 23/12/2022',
      certificateNumber: 'ECC5876913240',
    ),
  ];
}
