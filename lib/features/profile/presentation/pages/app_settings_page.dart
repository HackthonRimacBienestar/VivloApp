import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Preferencias de idioma y accesibilidad
class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Configuración',
      body: Center(
        child: Text('Preferencias de idioma y accesibilidad'),
      ),
    );
  }
}

