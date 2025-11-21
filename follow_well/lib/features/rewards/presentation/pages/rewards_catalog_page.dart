import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Catálogo de recompensas
class RewardsCatalogPage extends StatelessWidget {
  const RewardsCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Catálogo de Recompensas',
      body: Center(
        child: Text('Catálogo de recompensas'),
      ),
    );
  }
}

