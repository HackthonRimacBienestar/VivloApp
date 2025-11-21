import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Hábitos y estilo de vida
class LifestyleQuestionsPage extends StatelessWidget {
  const LifestyleQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Estilo de Vida',
      body: Center(
        child: Text('Hábitos y estilo de vida'),
      ),
    );
  }
}

