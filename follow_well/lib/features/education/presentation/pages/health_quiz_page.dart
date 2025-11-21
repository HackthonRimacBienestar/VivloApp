import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantalla de quiz / evaluación corta
class HealthQuizPage extends StatelessWidget {
  const HealthQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Quiz de Salud',
      body: Center(
        child: Text('Pantalla de quiz / evaluación corta'),
      ),
    );
  }
}

