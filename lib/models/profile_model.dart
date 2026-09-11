/// MODEL LAYER (M in MVC)
/// Holds the core personal / contact information shown across the site.
class ProfileModel {
  final String name;
  final String title;
  final String summary;
  final String phone;
  final String email;
  final String linkedInUrl;
  final String githubUrl;
  final String instagramUrl;
  final String leetcodeUrl;
  final String profileImage;
  final List<String> galleryImages;

  const ProfileModel({
    required this.name,
    required this.title,
    required this.summary,
    required this.phone,
    required this.email,
    required this.linkedInUrl,
    required this.githubUrl,
    required this.instagramUrl,
    required this.leetcodeUrl,
    required this.profileImage,
    required this.galleryImages,
  });
}
