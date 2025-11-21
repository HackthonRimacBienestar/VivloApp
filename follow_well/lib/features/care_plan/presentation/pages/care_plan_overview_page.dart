import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Resumen del plan de cuidado
class CarePlanOverviewPage extends StatelessWidget {
  const CarePlanOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Plan de Cuidado',
      body: Center(
        child: Text('Resumen del plan de cuidado'),
      ),
    );
  }
}

