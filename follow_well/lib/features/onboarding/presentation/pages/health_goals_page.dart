import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Selección de metas de salud
class HealthGoalsPage extends StatelessWidget {
  const HealthGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Metas de Salud',
      body: Center(
        child: Text('Selección de metas de salud'),
      ),
    );
  }
}

