import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Inscripción a programa de bienestar
class ProgramEnrollmentPage extends StatelessWidget {
  const ProgramEnrollmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Inscripción a Programa',
      body: Center(
        child: Text('Inscripción a programa de bienestar'),
      ),
    );
  }
}

