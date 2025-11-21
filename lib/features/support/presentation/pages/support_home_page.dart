import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Home de ayuda y soporte
class SupportHomePage extends StatelessWidget {
  const SupportHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Ayuda y Soporte',
      body: Center(
        child: Text('Home de ayuda y soporte'),
      ),
    );
  }
}

