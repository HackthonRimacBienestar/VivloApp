import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de beneficio / programa
class BenefitDetailPage extends StatelessWidget {
  const BenefitDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Beneficio',
      body: Center(
        child: Text('Detalle de beneficio / programa'),
      ),
    );
  }
}

