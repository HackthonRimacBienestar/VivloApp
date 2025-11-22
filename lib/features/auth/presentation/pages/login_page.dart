import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:follow_well/core/services/auth_service.dart';
import 'package:follow_well/shared/constants/routes.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/widgets/jobsly_wordmark.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/spacing.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await _auth.login();
      setState(() {});
      // Navegar al agente después del login exitoso
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.voiceAgent);
      }
    } catch (e) {
      debugPrint('Error login: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      await _auth.register();
      setState(() {});
      // Navegar al agente después del registro exitoso
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.voiceAgent);
      }
    } catch (e) {
      debugPrint('Error registro: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al registrarse: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.credentials?.user;

    // Si el usuario está logueado, mostramos la vista de perfil (manteniendo funcionalidad existente)
    if (user != null) {
      return AppScaffold(
        showAppBar: true,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user.pictureUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(user.pictureUrl.toString()),
                  radius: 40,
                ),
              const SizedBox(height: 16),
              Text('Hola, ${user.name ?? user.nickname ?? 'usuario'}'),
              const SizedBox(height: 8),
              Text(user.email ?? ''),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    await _auth.logout();
                    setState(() {});
                  } catch (e) {
                    debugPrint('Error logout: $e');
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                child: const Text('Cerrar sesión'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.voiceAgent);
                },
                child: const Text('Ir al Asistente de Voz'),
              ),
            ],
          ),
        ),
      );
    }

    // Vista de Login con diseño replicado de SignUpPage
    return AppScaffold(
      showAppBar: false,
      body: Column(
        children: [
          // Header con curva y gradiente
          Container(
            height: 180,
            decoration: const BoxDecoration(gradient: AppGradients.flameHero),
            child: Stack(
              children: [
                // Botón de regreso (opcional, dependiendo de la navegación)
                if (Navigator.canPop(context))
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                // Contenido del header alineado a la izquierda
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: JobslyWordmark(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                  ),
                ),
                // Curva decorativa
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 50),
                    painter: _WavePainter(),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F7),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // Tarjeta blanca con formulario
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título principal
                          Text(
                            'Bienvenido de nuevo',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              height: 1.2,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtítulo
                          Text(
                            'Inicia sesión para continuar',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                              height: 1.4,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Botón Iniciar Sesión
                          PrimaryButton(
                            text: 'Iniciar sesión',
                            onPressed: _login,
                            isLoading: _isLoading,
                            fullWidth: true,
                          ),

                          const SizedBox(height: 24),

                          // Divider "O inicia sesión con"
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.line,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'O continúa con',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.line,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Botones sociales
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  assetPath: 'assets/iconos/google.svg',
                                  label: 'Google',
                                  onPressed: _login, // Trigger Auth0 login
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialButton(
                                  assetPath: 'assets/iconos/facebook-icon.svg',
                                  label: 'Facebook',
                                  onPressed: _login, // Trigger Auth0 login
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Link a registro
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '¿No tienes cuenta? ',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _register,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    minimumSize: const Size(44, 44),
                                  ),
                                  child: Text(
                                    'Regístrate',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0,
                                      height: 1.4,
                                      color: AppColors.flareRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para la curva del header (Copiado de SignUpPage)
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F5F7)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, 50, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Widget para botones sociales (Copiado de SignUpPage)
class _SocialButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: AppColors.line, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 1.4,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
