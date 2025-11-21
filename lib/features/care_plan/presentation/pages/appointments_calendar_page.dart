import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Calendario de citas
class AppointmentsCalendarPage extends StatelessWidget {
  const AppointmentsCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Calendario de Citas',
      body: Center(
        child: Text('Calendario de citas'),
      ),
    );
  }
}

