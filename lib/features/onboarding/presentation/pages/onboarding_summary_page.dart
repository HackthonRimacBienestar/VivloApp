import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Resumen de perfil inicial
class OnboardingSummaryPage extends StatelessWidget {
  const OnboardingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Resumen del Perfil',
      body: Center(
        child: Text('Resumen de perfil inicial'),
      ),
    );
  }
}

