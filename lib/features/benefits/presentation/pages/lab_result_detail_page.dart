import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de resultado de laboratorio
class LabResultDetailPage extends StatelessWidget {
  const LabResultDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Resultado',
      body: Center(
        child: Text('Detalle de resultado de laboratorio'),
      ),
    );
  }
}

