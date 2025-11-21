import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de artículos
class ArticlesListPage extends StatelessWidget {
  const ArticlesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Artículos',
      body: Center(
        child: Text('Lista de artículos'),
      ),
    );
  }
}

