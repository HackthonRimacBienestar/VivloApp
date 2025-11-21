import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Confirmar toma de medicación
class LogMedicationIntakePage extends StatelessWidget {
  const LogMedicationIntakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Confirmar Medicación',
      body: Center(
        child: Text('Confirmar toma de medicación'),
      ),
    );
  }
}

