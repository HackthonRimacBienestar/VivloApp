import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Home de beneficios y programas
class BenefitsHomePage extends StatelessWidget {
  const BenefitsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Beneficios',
      body: Center(
        child: Text('Home de beneficios y programas'),
      ),
    );
  }
}

