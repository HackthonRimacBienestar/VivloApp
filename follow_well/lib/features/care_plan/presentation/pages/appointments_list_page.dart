import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Lista de citas próximas
class AppointmentsListPage extends StatelessWidget {
  const AppointmentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Próximas Citas',
      body: Center(
        child: Text('Lista de citas próximas'),
      ),
    );
  }
}

