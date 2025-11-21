import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de medicamento
class MedicationDetailPage extends StatelessWidget {
  const MedicationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Medicamento',
      body: Center(
        child: Text('Detalle de medicamento'),
      ),
    );
  }
}

