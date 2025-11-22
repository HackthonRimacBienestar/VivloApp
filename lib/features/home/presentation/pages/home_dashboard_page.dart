import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Home / Tablero principal
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Inicio',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home / Tablero principal'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/voice-agent');
              },
              child: const Text('Probar Agente de Voz'),
            ),
          ],
        ),
      ),
    );
  }
}
