import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile_model.dart';
import '../models/skill_model.dart';
import '../models/project_model.dart';
import '../models/experience_model.dart';
import '../utils/app_data.dart';

/// CONTROLLER LAYER (C in MVC)
/// Mediates between the Models (plain data classes in `app_data.dart`) and
/// the Views (widgets in `lib/views`). Views never read AppData directly —
/// they always go through this provider, so swapping the data source later
/// (e.g. loading from an API or CMS) only touches this file.
class PortfolioProvider extends ChangeNotifier {
  ProfileModel get profile => AppData.profile;
  List<SkillCategory> get skillCategories => AppData.skillCategories;
  List<ExperienceModel> get experience => AppData.experience;
  List<ProjectModel> get projects => AppData.projects;
  List<EducationModel> get education => AppData.education;
  List<CertificateModel> get certificates => AppData.certificates;

  int _selectedProjectIndex = 0;
  int get selectedProjectIndex => _selectedProjectIndex;

  void selectProject(int index) {
    _selectedProjectIndex = index;
    notifyListeners();
  }

  Future<void> launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: profile.email,
      queryParameters: {'subject': 'Let\'s connect'},
    );
    await _tryLaunch(uri);
  }

  Future<void> launchPhone() async {
    final uri = Uri(scheme: 'tel', path: profile.phone.replaceAll(' ', ''));
    await _tryLaunch(uri);
  }

  Future<void> launchUrlString(String url) async {
    await _tryLaunch(Uri.parse(url));
  }

  Future<void> _tryLaunch(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Silently ignore — in a browser sandbox / demo environment the
      // launch may be blocked; the UI still shows the link/text to copy.
    }
  }
}
