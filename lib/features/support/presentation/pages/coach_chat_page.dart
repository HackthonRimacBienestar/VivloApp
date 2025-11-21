import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Chat con coach / equipo de salud
class CoachChatPage extends StatelessWidget {
  const CoachChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Chat con Coach',
      body: Center(
        child: Text('Chat con coach / equipo de salud'),
      ),
    );
  }
}

