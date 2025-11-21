import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Solicitud de renovación / refill
class MedicationRefillRequestPage extends StatelessWidget {
  const MedicationRefillRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Solicitar Renovación',
      body: Center(
        child: Text('Solicitud de renovación / refill'),
      ),
    );
  }
}

