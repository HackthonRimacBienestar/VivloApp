import 'package:flutter/material.dart';

class CommunityGroup {
  final String name;
  final String description;
  final int membersOnline;
  final int totalMembers;
  final String tone;
  final IconData icon;
  final Color accent;

  const CommunityGroup({
    required this.name,
    required this.description,
    required this.membersOnline,
    required this.totalMembers,
    required this.tone,
    required this.icon,
    required this.accent,
  });
}
