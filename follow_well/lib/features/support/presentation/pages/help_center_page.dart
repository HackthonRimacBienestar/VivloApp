import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Centro de ayuda / FAQ
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Centro de Ayuda',
      body: Center(
        child: Text('Centro de ayuda / FAQ'),
      ),
    );
  }
}

