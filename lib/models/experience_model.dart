/// MODEL LAYER
class ExperienceModel {
  final String company;
  final String role;
  final String duration;
  final String? referenceNote;

  const ExperienceModel({
    required this.company,
    required this.role,
    required this.duration,
    this.referenceNote,
  });
}

class EducationModel {
  final String institution;
  final String qualification;
  final String duration;
  final String? note;

  const EducationModel({
    required this.institution,
    required this.qualification,
    required this.duration,
    this.note,
  });
}

class CertificateModel {
  final String title;
  final String issuer;
  final String duration;
  final String? certificateNumber;

  const CertificateModel({
    required this.title,
    required this.issuer,
    required this.duration,
    this.certificateNumber,
  });
}
