import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Consentimientos y privacidad
class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Consentimientos',
      body: Center(
        child: Text('Consentimientos y privacidad'),
      ),
    );
  }
}

