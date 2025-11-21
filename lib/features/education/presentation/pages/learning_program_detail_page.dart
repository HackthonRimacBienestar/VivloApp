import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de programa educativo
class LearningProgramDetailPage extends StatelessWidget {
  const LearningProgramDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Programa',
      body: Center(
        child: Text('Detalle de programa educativo'),
      ),
    );
  }
}

