import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Línea de tiempo de cuidado / Journey
class CareJourneyTimelinePage extends StatelessWidget {
  const CareJourneyTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Mi Journey',
      body: Center(
        child: Text('Línea de tiempo de cuidado / Journey'),
      ),
    );
  }
}

