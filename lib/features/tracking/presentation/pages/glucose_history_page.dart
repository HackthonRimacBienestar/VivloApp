import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Historial de glucosa
class GlucoseHistoryPage extends StatelessWidget {
  const GlucoseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Historial de Glucosa',
      body: Center(
        child: Text('Historial de glucosa'),
      ),
    );
  }
}

