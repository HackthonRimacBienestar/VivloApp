import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Acerca de la app / términos / políticas
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Acerca de',
      body: Center(
        child: Text('Acerca de la app / términos / políticas'),
      ),
    );
  }
}

