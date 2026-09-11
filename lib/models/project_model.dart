/// MODEL LAYER
class ProjectModel {
  final String title;
  final String description;
  final List<String> bullets;
  final List<String> techStack;
  final String? liveLink;
  final String? githubLink;
  final Map<String, String>? extraLinks; // e.g. {"User": url, "Admin": url}

  const ProjectModel({
    required this.title,
    required this.description,
    this.bullets = const [],
    this.techStack = const [],
    this.liveLink,
    this.githubLink,
    this.extraLinks,
  });
}
