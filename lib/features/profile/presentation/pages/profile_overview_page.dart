import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Perfil del usuario
class ProfileOverviewPage extends StatelessWidget {
  const ProfileOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Mi Perfil',
      body: Center(
        child: Text('Perfil del usuario'),
      ),
    );
  }
}

