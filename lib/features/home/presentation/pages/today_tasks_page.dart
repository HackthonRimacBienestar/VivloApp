import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de tareas de hoy
class TodayTasksPage extends StatelessWidget {
  const TodayTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Tareas de Hoy',
      body: Center(
        child: Text('Detalle de tareas de hoy'),
      ),
    );
  }
}

