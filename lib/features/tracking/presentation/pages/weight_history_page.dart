import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Historial de peso / IMC
class WeightHistoryPage extends StatelessWidget {
  const WeightHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Historial de Peso',
      body: Center(
        child: Text('Historial de peso / IMC'),
      ),
    );
  }
}

