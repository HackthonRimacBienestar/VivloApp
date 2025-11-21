import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de retos / desafíos
class ChallengesListPage extends StatelessWidget {
  const ChallengesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Retos',
      body: Center(
        child: Text('Lista de retos / desafíos'),
      ),
    );
  }
}

