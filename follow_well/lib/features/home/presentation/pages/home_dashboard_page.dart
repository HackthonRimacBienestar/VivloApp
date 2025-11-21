import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Home / Tablero principal
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Inicio',
      body: Center(
        child: Text('Home / Tablero principal'),
      ),
    );
  }
}

