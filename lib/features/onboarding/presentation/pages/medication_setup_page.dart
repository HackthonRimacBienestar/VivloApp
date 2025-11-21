import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Registro de medicación actual
class MedicationSetupPage extends StatelessWidget {
  const MedicationSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Medicación Actual',
      body: Center(
        child: Text('Registro de medicación actual'),
      ),
    );
  }
}

