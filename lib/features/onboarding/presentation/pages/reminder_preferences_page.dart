import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Preferencias de recordatorios
class ReminderPreferencesPage extends StatelessWidget {
  const ReminderPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Preferencias de Recordatorios',
      body: Center(
        child: Text('Preferencias de recordatorios'),
      ),
    );
  }
}

