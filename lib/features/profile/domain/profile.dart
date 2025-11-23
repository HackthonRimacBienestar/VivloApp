class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? diabetesType;
  final DateTime? diagnosisDate;
  final String? clinicalSummary;
  final int pointsBalance;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.diabetesType,
    this.diagnosisDate,
    this.clinicalSummary,
    this.pointsBalance = 0,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      diabetesType: json['diabetes_type'],
      diagnosisDate: json['diagnosis_date'] != null
          ? DateTime.parse(json['diagnosis_date'])
          : null,
      clinicalSummary: json['clinical_summary'],
      pointsBalance: json['points_balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'diabetes_type': diabetesType,
      'diagnosis_date': diagnosisDate?.toIso8601String(),
      'clinical_summary': clinicalSummary,
      'points_balance': pointsBalance,
    };
  }
}
