import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Registrar presión arterial
class LogBloodPressurePage extends StatelessWidget {
  const LogBloodPressurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Registrar Presión Arterial',
      body: Center(
        child: Text('Registrar presión arterial'),
      ),
    );
  }
}

