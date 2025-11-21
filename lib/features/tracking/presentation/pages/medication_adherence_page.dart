import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Historial de adherencia a medicación
class MedicationAdherencePage extends StatelessWidget {
  const MedicationAdherencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Adherencia a Medicación',
      body: Center(
        child: Text('Historial de adherencia a medicación'),
      ),
    );
  }
}

