import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Selector de registro rápido
class QuickLogPage extends StatelessWidget {
  const QuickLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Registro Rápido',
      body: Center(
        child: Text('Selector de registro rápido'),
      ),
    );
  }
}

