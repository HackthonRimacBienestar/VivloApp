import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Selección de enfermedades crónicas
class ChronicConditionsPage extends StatelessWidget {
  const ChronicConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Enfermedades Crónicas',
      body: Center(
        child: Text('Selección de enfermedades crónicas'),
      ),
    );
  }
}

