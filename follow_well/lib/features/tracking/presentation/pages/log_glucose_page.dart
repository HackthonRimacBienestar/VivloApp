import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Registrar glucosa
class LogGlucosePage extends StatelessWidget {
  const LogGlucosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Registrar Glucosa',
      body: Center(
        child: Text('Registrar glucosa'),
      ),
    );
  }
}

