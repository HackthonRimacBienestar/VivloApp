import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Agendar nueva cita
class NewAppointmentPage extends StatelessWidget {
  const NewAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Agendar Cita',
      body: Center(
        child: Text('Agendar nueva cita'),
      ),
    );
  }
}

