import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Configuración de privacidad y datos
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Privacidad',
      body: Center(
        child: Text('Configuración de privacidad y datos'),
      ),
    );
  }
}

