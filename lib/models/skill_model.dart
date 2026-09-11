import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillCategory {
  final String title;
  final FaIconData icon;
  final List<String> items;

  const SkillCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}