import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/widgets/jobsly_wordmark.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../shared/constants/routes.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';

/// Pantalla de Inicio de sesión
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrDniController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailOrDniController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Implementar lógica de login real con API
      // Por ahora simulamos un login exitoso
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Simular token de autenticación
      await StorageService.saveToken(
        'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      setState(() => _isLoading = false);

      // Navegar a Home
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Form(
                  key: _formKey,
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
                            // Título principal - 28px, bold, letter-spacing -0.5, line-height 1.2
                            Text(
                              'Bienvenido de vuelta',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.2,
                                color: AppColors.ink,
                              ),
                            ),
                            // Espaciado title_to_subtitle: 8
                            const SizedBox(height: 8),
                            // Subtítulo - 15px, regular, line-height 1.4
                            Text(
                              'Ingresa tus credenciales',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0,
                                height: 1.4,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            // Espaciado subtitle_to_first_input: 32
                            const SizedBox(height: 32),

                            // Campo Email o DNI
                            AppTextField(
                              label: 'Email o DNI',
                              hint: 'tu@email.com o 12345678',
                              leadingIcon: Icons.person_outline,
                              controller: _emailOrDniController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El email o DNI es requerido';
                                }
                                final isEmail = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value);
                                final isDni = RegExp(
                                  r'^\d{8}$',
                                ).hasMatch(value);
                                if (!isEmail && !isDni) {
                                  return 'Ingresa un email válido o DNI de 8 dígitos';
                                }
                                return null;
                              },
                            ),
                            // Espaciado between_inputs: 20
                            const SizedBox(height: 20),

                            // Campo Contraseña
                            AppTextField(
                              label: 'Contraseña',
                              hint: 'Ingresa tu contraseña',
                              leadingIcon: Icons.lock_outline,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.inkMuted,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La contraseña es requerida';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            // Espaciado last_input_to_button: 24
                            const SizedBox(height: 24),

                            // Botón Login - 16px, semi_bold, letter-spacing 0.2
                            PrimaryButton(
                              text: 'Iniciar Sesión',
                              onPressed: _handleLogin,
                              isLoading: _isLoading,
                              fullWidth: true,
                            ),
                            // Espaciado button_to_link: 20
                            const SizedBox(height: 20),

                            // Link olvidaste contraseña - 15px, semi_bold
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  minimumSize: const Size(44, 44),
                                ),
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Espaciado separator above: 24
                      const SizedBox(height: 24),

                      // Divider "O inicia sesión con" - line_height 1, thickness 1
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: AppColors.line),
                          ),
                          // Separator text padding horizontal: 16
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            // Separator text - 14px, medium
                            child: Text(
                              'O inicia sesión con',
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
                            child: Container(height: 1, color: AppColors.line),
                          ),
                        ],
                      ),
                      // Espaciado separator below: 24
                      const SizedBox(height: 24),

                      // Botones sociales - spacing_between_buttons: 12
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              assetPath: 'assets/iconos/google.svg',
                              label: 'Google',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialButton(
                              assetPath: 'assets/iconos/facebook-icon.svg',
                              label: 'Facebook',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      // Footer padding top: 24
                      const SizedBox(height: 24),

                      // Link a registro - footer_text: 14px regular, link_text: 15px semi_bold
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                minimumSize: const Size(44, 44),
                              ),
                              child: Text(
                                'Crear cuenta',
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
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para la curva del header
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

// Widget para botones sociales
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
      // Social button height: 52
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          // Social button padding: horizontal 20, vertical 14
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: AppColors.line, width: 1),
          // Social button border_radius: 16
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Social logo size: 24
            SvgPicture.asset(assetPath, width: 24, height: 24),
            // Icon spacing_from_text: 12
            const SizedBox(width: 12),
            // Button social text - 15px, medium
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
