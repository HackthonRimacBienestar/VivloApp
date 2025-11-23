class CommunityMessage {
  final String id;
  final String groupId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? authorName; // Optional, joined from profiles

  const CommunityMessage({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.authorName,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      authorName: json['profiles'] != null
          ? json['profiles']['full_name'] as String?
          : null,
    );
  }
}
