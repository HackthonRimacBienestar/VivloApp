import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de resultados de laboratorio
class LabResultsListPage extends StatelessWidget {
  const LabResultsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Resultados de Laboratorio',
      body: Center(
        child: Text('Lista de resultados de laboratorio'),
      ),
    );
  }
}

