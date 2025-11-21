import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Configuración de notificaciones
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Notificaciones',
      body: Center(
        child: Text('Configuración de notificaciones'),
      ),
    );
  }
}

