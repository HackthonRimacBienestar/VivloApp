import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';

/// Home de educación y recursos
class EducationHomePage extends StatelessWidget {
  const EducationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Educación',
      body: Center(
        child: Text('Home de educación y recursos'),
      ),
    );
  }
}

