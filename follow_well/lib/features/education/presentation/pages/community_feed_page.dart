import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Feed de comunidad
class CommunityFeedPage extends StatelessWidget {
  const CommunityFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Comunidad',
      body: Center(
        child: Text('Feed de comunidad'),
      ),
    );
  }
}

