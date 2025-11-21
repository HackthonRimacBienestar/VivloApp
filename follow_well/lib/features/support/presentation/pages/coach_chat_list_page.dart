import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de conversaciones con coach
class CoachChatListPage extends StatelessWidget {
  const CoachChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Conversaciones',
      body: Center(
        child: Text('Lista de conversaciones con coach'),
      ),
    );
  }
}

