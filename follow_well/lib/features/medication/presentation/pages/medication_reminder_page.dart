import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Configurar recordatorios de medicación
class MedicationReminderPage extends StatelessWidget {
  const MedicationReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Recordatorios de Medicación',
      body: Center(
        child: Text('Configurar recordatorios de medicación'),
      ),
    );
  }
}

