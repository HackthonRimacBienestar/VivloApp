import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Crear publicación / comentario
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Crear Publicación',
      body: Center(
        child: Text('Crear publicación / comentario'),
      ),
    );
  }
}

