import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Registrar síntoma / cómo me siento
class LogSymptomPage extends StatelessWidget {
  const LogSymptomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Registrar Síntoma',
      body: Center(
        child: Text('Registrar síntoma / cómo me siento'),
      ),
    );
  }
}

