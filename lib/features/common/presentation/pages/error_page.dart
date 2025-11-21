import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Pantalla genérica de error
class ErrorPage extends StatelessWidget {
  final String? message;
  
  const ErrorPage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Error',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message ?? 'Ha ocurrido un error'),
          ],
        ),
      ),
    );
  }
}

