import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Registrar actividad física
class LogActivityPage extends StatelessWidget {
  const LogActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Registrar Actividad',
      body: Center(
        child: Text('Registrar actividad física'),
      ),
    );
  }
}

