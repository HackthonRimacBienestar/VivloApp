import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Opciones de contacto (llamar, escribir, email)
class ContactOptionsPage extends StatelessWidget {
  const ContactOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Contacto',
      body: Center(
        child: Text('Opciones de contacto (llamar, escribir, email)'),
      ),
    );
  }
}

