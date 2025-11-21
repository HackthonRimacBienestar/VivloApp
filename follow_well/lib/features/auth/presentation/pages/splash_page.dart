import 'package:flutter/material.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../shared/constants/routes.dart';
import 'welcome_page.dart';
import 'login_page.dart';

/// Pantalla de Splash / Carga inicial
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    // Simular tiempo de carga mínimo
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Verificar si tiene token (usuario logueado)
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      // Usuario logueado → ir a Home
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    // Verificar si ya vio la bienvenida
    final hasSeenWelcome = await StorageService.hasSeenWelcome();
    if (hasSeenWelcome) {
      // Ya vio bienvenida → ir a Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      // Primera vez → ir a Welcome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.flareRed,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: Column(
              children: [
                // Spacer superior para centrar visualmente
                const Spacer(flex: 2),

                // Logo principal con animación
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo_rimac_contigo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Sección inferior con loading y texto
                Column(
                  children: [
                    // Loading indicator elegante
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Texto de carga profesional
                    const Text(
                      'Preparando tu experiencia',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Subtexto
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.hero),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
