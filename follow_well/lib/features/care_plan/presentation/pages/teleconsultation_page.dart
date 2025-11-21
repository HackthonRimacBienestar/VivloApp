import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantalla de teleconsulta (sala virtual)
class TeleconsultationPage extends StatelessWidget {
  const TeleconsultationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Teleconsulta',
      body: Center(
        child: Text('Pantalla de teleconsulta (sala virtual)'),
      ),
    );
  }
}

