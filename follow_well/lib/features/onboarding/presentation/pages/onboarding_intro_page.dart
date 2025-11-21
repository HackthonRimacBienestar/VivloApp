import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Intro al programa de cuidado crónico
class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Bienvenido al Programa',
      body: Center(
        child: Text('Intro al programa de cuidado crónico'),
      ),
    );
  }
}

