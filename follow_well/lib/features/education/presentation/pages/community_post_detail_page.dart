import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Detalle de publicación / hilo
class CommunityPostDetailPage extends StatelessWidget {
  const CommunityPostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detalle de Publicación',
      body: Center(
        child: Text('Detalle de publicación / hilo'),
      ),
    );
  }
}

