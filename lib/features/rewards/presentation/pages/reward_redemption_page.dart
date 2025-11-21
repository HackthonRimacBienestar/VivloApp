import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle / canje de recompensa
class RewardRedemptionPage extends StatelessWidget {
  const RewardRedemptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Canjear Recompensa',
      body: Center(
        child: Text('Detalle / canje de recompensa'),
      ),
    );
  }
}

