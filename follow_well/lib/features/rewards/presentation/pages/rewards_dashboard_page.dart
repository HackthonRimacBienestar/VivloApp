import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Dashboard de bienestar y puntos
class RewardsDashboardPage extends StatelessWidget {
  const RewardsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Bienestar',
      body: Center(
        child: Text('Dashboard de bienestar y puntos'),
      ),
    );
  }
}

