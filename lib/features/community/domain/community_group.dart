import 'package:flutter/material.dart';

class CommunityGroup {
  final String id;
  final String name;
  final String description;
  final int membersOnline;
  final int totalMembers;
  final String tone;
  final IconData icon;
  final Color accent;

  const CommunityGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.membersOnline,
    required this.totalMembers,
    required this.tone,
    required this.icon,
    required this.accent,
  });

  factory CommunityGroup.fromJson(Map<String, dynamic> json) {
    return CommunityGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      membersOnline:
          0, // This would ideally come from a separate query or realtime count
      totalMembers: 0, // This would ideally come from a count query
      tone: json['tone'] as String? ?? '',
      icon: _parseIcon(json['icon'] as String?),
      accent: _parseColor(json['accent_color'] as String?),
    );
  }

  static IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'favorite':
        return Icons.favorite;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.group;
    }
  }

  static Color _parseColor(String? colorHex) {
    if (colorHex == null) return Colors.blue;
    try {
      return Color(int.parse(colorHex));
    } catch (_) {
      return Colors.blue;
    }
  }
}
