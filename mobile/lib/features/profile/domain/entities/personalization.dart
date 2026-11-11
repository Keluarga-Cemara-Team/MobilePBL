class Personalization {
  const Personalization({
    this.birthDate,
    this.gender = '',
    this.country = '',
    this.education = '',
    this.occupation = '',
    this.employmentStatus = '',
    this.workLocation = '',
    this.smoking = '',
    this.alcohol = '',
    this.income = '',
    this.familyMentalHealthHistory = '',
    this.professionalSupport = '',
  });

  final DateTime? birthDate;
  final String gender;
  final String country;
  final String education;
  final String occupation;
  final String employmentStatus;
  final String workLocation;
  final String smoking;
  final String alcohol;
  final String income;
  final String familyMentalHealthHistory;
  final String professionalSupport;

  Personalization copyWith({
    DateTime? birthDate,
    bool clearBirthDate = false,
    String? gender,
    String? country,
    String? education,
    String? occupation,
    String? employmentStatus,
    String? workLocation,
    String? smoking,
    String? alcohol,
    String? income,
    String? familyMentalHealthHistory,
    String? professionalSupport,
  }) {
    return Personalization(
      birthDate: clearBirthDate ? null : birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      workLocation: workLocation ?? this.workLocation,
      smoking: smoking ?? this.smoking,
      alcohol: alcohol ?? this.alcohol,
      income: income ?? this.income,
      familyMentalHealthHistory:
          familyMentalHealthHistory ?? this.familyMentalHealthHistory,
      professionalSupport: professionalSupport ?? this.professionalSupport,
    );
  }

  Map<String, dynamic> toJson() => {
    'birth_date': birthDate?.toIso8601String(),
    'gender': gender,
    'country': country,
    'education': education,
    'occupation': occupation,
    'employment_status': employmentStatus,
    'work_location': workLocation,
    'smoking': smoking,
    'alcohol': alcohol,
    'income': income,
    'family_mental_health_history': familyMentalHealthHistory,
    'professional_support': professionalSupport,
  };

  factory Personalization.fromJson(Map<String, dynamic> json) {
    return Personalization(
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'].toString())
          : null,
      gender: json['gender']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      education: json['education']?.toString() ?? '',
      occupation: json['occupation']?.toString() ?? '',
      employmentStatus: json['employment_status']?.toString() ?? '',
      workLocation: json['work_location']?.toString() ?? '',
      smoking: json['smoking']?.toString() ?? '',
      alcohol: json['alcohol']?.toString() ?? '',
      income: json['income']?.toString() ?? '',
      familyMentalHealthHistory:
          json['family_mental_health_history']?.toString() ?? '',
      professionalSupport: json['professional_support']?.toString() ?? '',
    );
  }
}
