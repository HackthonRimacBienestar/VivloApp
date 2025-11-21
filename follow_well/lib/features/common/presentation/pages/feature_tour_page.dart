import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantalla de primera vez / tutorial corto
class FeatureTourPage extends StatelessWidget {
  const FeatureTourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Bienvenido',
      body: Center(
        child: Text('Pantalla de primera vez / tutorial corto'),
      ),
    );
  }
}

