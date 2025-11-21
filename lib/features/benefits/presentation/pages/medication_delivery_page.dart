import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Gestión de delivery / extensión de receta
class MedicationDeliveryPage extends StatelessWidget {
  const MedicationDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Delivery de Medicación',
      body: Center(
        child: Text('Gestión de delivery / extensión de receta'),
      ),
    );
  }
}

