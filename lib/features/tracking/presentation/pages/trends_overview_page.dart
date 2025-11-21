import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Resumen de tendencias y progreso
class TrendsOverviewPage extends StatelessWidget {
  const TrendsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Tendencias y Progreso',
      body: Center(
        child: Text('Resumen de tendencias y progreso'),
      ),
    );
  }
}

