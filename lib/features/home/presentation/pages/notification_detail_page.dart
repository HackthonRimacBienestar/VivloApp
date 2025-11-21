import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de notificación / alerta
class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Notificación',
      body: Center(
        child: Text('Detalle de notificación / alerta'),
      ),
    );
  }
}

