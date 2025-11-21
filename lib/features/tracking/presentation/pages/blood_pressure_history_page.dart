import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Historial de presión arterial
class BloodPressureHistoryPage extends StatelessWidget {
  const BloodPressureHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Historial de Presión Arterial',
      body: Center(
        child: Text('Historial de presión arterial'),
      ),
    );
  }
}

