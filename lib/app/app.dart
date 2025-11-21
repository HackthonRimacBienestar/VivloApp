import 'package:flutter/material.dart';
import '../core/ui/theme/theme.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../shared/constants/routes.dart';
import '../features/home/presentation/pages/home_dashboard_page.dart';

/// Bootstrap de la aplicación
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIMAC Contigo', 
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.home: (_) => const HomeDashboardPage(),
        // Otras rutas se pueden agregar aquí o usar Navigator.push con MaterialPageRoute
      },
    );
  }
}
