import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Historial de mediciones (vista general)
class VitalsHistoryPage extends StatelessWidget {
  const VitalsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Historial de Mediciones',
      body: Center(
        child: Text('Historial de mediciones (vista general)'),
      ),
    );
  }
}

