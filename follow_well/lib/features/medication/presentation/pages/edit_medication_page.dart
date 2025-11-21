import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Agregar / editar medicamento
class EditMedicationPage extends StatelessWidget {
  const EditMedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Editar Medicamento',
      body: Center(
        child: Text('Agregar / editar medicamento'),
      ),
    );
  }
}

