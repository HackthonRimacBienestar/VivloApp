import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de reto
class ChallengeDetailPage extends StatelessWidget {
  const ChallengeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Reto',
      body: Center(
        child: Text('Detalle de reto'),
      ),
    );
  }
}

