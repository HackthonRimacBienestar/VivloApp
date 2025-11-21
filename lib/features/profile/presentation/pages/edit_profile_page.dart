import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Editar perfil
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Editar Perfil',
      body: Center(
        child: Text('Editar perfil'),
      ),
    );
  }
}

