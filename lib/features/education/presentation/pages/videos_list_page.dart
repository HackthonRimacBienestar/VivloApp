import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de videos / tutoriales
class VideosListPage extends StatelessWidget {
  const VideosListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Videos',
      body: Center(
        child: Text('Lista de videos / tutoriales'),
      ),
    );
  }
}

