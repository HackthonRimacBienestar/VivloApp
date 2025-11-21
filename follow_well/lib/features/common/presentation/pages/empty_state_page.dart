import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantallas de estados vacíos (sin datos, sin conexión)
class EmptyStatePage extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStatePage({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sin Datos',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
