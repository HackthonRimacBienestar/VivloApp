import 'package:flutter/material.dart';
import '../core/ui/theme/theme.dart';
import '../shared/constants/routes.dart';
import '../features/voice_dictation/presentation/voice_agent_page.dart';
import '../features/auth/presentation/pages/login_page.dart';

/// Bootstrap de la aplicación
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIMAC Contigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.voiceAgent: (_) => const VoiceAgentPage(),
        AppRoutes.login: (_) => const LoginPage(),
      },
    );
  }
}
