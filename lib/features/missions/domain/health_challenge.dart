enum ChallengeStatus { assigned, completed, skipped, expired }

enum ChallengeCategory {
  glucose_check,
  diet,
  exercise,
  medication,
  mental_wellbeing,
}

class HealthChallenge {
  final String id;
  final String userId;
  final String? sourceConversationId;
  final String title;
  final String? description;
  final ChallengeCategory category;
  final int difficultyLevel;
  final int pointsReward;
  final ChallengeStatus status;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;

  HealthChallenge({
    required this.id,
    required this.userId,
    this.sourceConversationId,
    required this.title,
    this.description,
    required this.category,
    this.difficultyLevel = 1,
    this.pointsReward = 50,
    this.status = ChallengeStatus.assigned,
    this.dueDate,
    this.completedAt,
    required this.createdAt,
  });

  factory HealthChallenge.fromJson(Map<String, dynamic> json) {
    return HealthChallenge(
      id: json['id'],
      userId: json['user_id'],
      sourceConversationId: json['source_conversation_id'],
      title: json['title'],
      description: json['description'],
      category: _parseCategory(json['category']),
      difficultyLevel: json['difficulty_level'] ?? 1,
      pointsReward: json['points_reward'] ?? 50,
      status: _parseStatus(json['status']),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static ChallengeCategory _parseCategory(String category) {
    return ChallengeCategory.values.firstWhere(
      (e) => e.toString().split('.').last == category,
      orElse: () => ChallengeCategory.glucose_check,
    );
  }

  static ChallengeStatus _parseStatus(String status) {
    return ChallengeStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => ChallengeStatus.assigned,
    );
  }
}
