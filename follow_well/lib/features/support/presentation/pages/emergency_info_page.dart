import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Información y contactos de emergencia
class EmergencyInfoPage extends StatelessWidget {
  const EmergencyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Emergencias',
      body: Center(
        child: Text('Información y contactos de emergencia'),
      ),
    );
  }
}

