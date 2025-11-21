import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Reprogramar cita
class RescheduleAppointmentPage extends StatelessWidget {
  const RescheduleAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Reprogramar Cita',
      body: Center(
        child: Text('Reprogramar cita'),
      ),
    );
  }
}

