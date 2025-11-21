import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantalla de permisos (notificaciones, salud, ubicación)
class PermissionsRequestPage extends StatelessWidget {
  const PermissionsRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Permisos',
      body: Center(
        child: Text('Pantalla de permisos (notificaciones, salud, ubicación)'),
      ),
    );
  }
}

