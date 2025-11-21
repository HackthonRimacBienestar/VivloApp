import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Programas / cursos educativos
class LearningProgramsPage extends StatelessWidget {
  const LearningProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Programas Educativos',
      body: Center(
        child: Text('Programas / cursos educativos'),
      ),
    );
  }
}

