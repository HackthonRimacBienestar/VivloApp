import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/ui/theme/spacing.dart';
import 'login_page.dart';

/// Pantalla de Recuperar contraseña
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrDniController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailOrDniController.dispose();
    super.dispose();
  }

  Future<void> _handleSendReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Implementar lógica real de recuperación de contraseña
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isEmailSent = true;
      });

      // Mostrar mensaje de éxito
      AppSnackbar.show(
        context,
        message: 'Se ha enviado un enlace a tu email',
        icon: Icons.check_circle_outline,
      );
    }
  }

  void _handleBackToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '',
      showAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.softAmbient,
        ),
        child: Stack(
          children: [
            // Efectos decorativos
            Positioned(
              top: -100,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.flareRed.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.emberOrange.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xl),

                      // Icono con gradiente
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.flameHero,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.flareRed.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.hero),

                      // Título con gradiente
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppGradients.flameHero.createShader(bounds),
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: AppTypography.displayM.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _isEmailSent
                            ? 'Revisa tu email para restablecer tu contraseña'
                            : 'Ingresa tu email o DNI y te enviaremos un enlace para restablecer tu contraseña',
                        style: AppTypography.body.copyWith(
                          color: AppColors.inkMuted,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.hero),

                      if (!_isEmailSent) ...[
                        // Tarjeta de formulario con glassmorphism
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Campo Email/DNI
                                  AppTextField(
                                    label: 'Email o DNI',
                                    hint: 'Ingresa tu email o DNI',
                                    leadingIcon: Icons.email_outlined,
                                    controller: _emailOrDniController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'El email o DNI es requerido';
                                      }
                                      final isEmail = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value);
                                      final isDni =
                                          RegExp(r'^\d{8}$').hasMatch(value);
                                      if (!isEmail && !isDni) {
                                        return 'Ingresa un email válido o DNI de 8 dígitos';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Botón Enviar
                        PrimaryButton(
                          text: 'Enviar enlace',
                          onPressed: _handleSendReset,
                          isLoading: _isLoading,
                          fullWidth: true,
                        ),
                      ] else ...[
                        // Mensaje de éxito con glassmorphism
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.xxl),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: AppColors.statusSuccess
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.statusSuccess.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.lg),
                                    decoration: BoxDecoration(
                                      color: AppColors.statusSuccess
                                          .withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_rounded,
                                      size: 60,
                                      color: AppColors.statusSuccess,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    'Email enviado',
                                    style: AppTypography.title.copyWith(
                                      color: AppColors.statusSuccess,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña',
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.inkMuted,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],

                      const SizedBox(height: AppSpacing.lg),

                      // Botón volver a Login
                      SecondaryGhostButton(
                        text: _isEmailSent
                            ? 'Volver a iniciar sesión'
                            : 'Cancelar',
                        onPressed: _handleBackToLogin,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
