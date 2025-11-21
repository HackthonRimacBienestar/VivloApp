import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/utils/storage_service.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

/// Pantalla de Bienvenida
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WelcomeSlide> _slides = [
    WelcomeSlide(
      title: 'Empodera Tu Salud Con Conocimiento',
      description:
          'Toma el control de tu bienestar con información precisa y apoyo personalizado',
      imagePath: 'assets/ROBOTSITO1.png',
    ),
    WelcomeSlide(
      title: 'Seguimiento Inteligente',
      description:
          'Registra y monitorea tus signos vitales en minutos, obtén insights clave para tu salud',
      imagePath: 'assets/ROBOTSITO1.png',
    ),
    WelcomeSlide(
      title: 'Mantente Motivado Y Alcanza Objetivos',
      description:
          'Recibe apoyo constante de nuestro equipo de salud para lograr tus metas de bienestar',
      imagePath: 'assets/chica1.png',
      useGradientBackground: true,
      gradientColors: const [
        Color(0xFFE1D5FF),
        Color(0xFFF1E3FF),
        Color(0xFFFFF3F4),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleGetStarted() async {
    await StorageService.setHasSeenWelcome(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  void _handleAlreadyHaveAccount() async {
    await StorageService.setHasSeenWelcome(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  // Método para crear títulos con palabras clave destacadas
  Widget _buildStyledTitle(String title) {
    // Lista de palabras clave para enfatizar (similar al estilo "Quick" de la imagen)
    final keywords = [
      'conocimiento',
      'inteligente',
      'motivado',
      'objetivos',
      'empodera',
      'alcanza',
      'mantente',
      'salud',
    ];

    final words = title.split(' ');
    final List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final wordLower = word.toLowerCase();

      // Verificar si la palabra es clave o contiene una palabra clave
      final isKeyword = keywords.any((keyword) => wordLower.contains(keyword));

      spans.add(
        TextSpan(
          text: word + (i < words.length - 1 ? ' ' : ''),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 30,
            fontWeight: isKeyword ? FontWeight.w800 : FontWeight.w600,
            color: Colors.black,
            height: 1.25,
            letterSpacing: isKeyword ? -0.8 : -0.3,
          ),
        ),
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.flameHero.createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: spans,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softAmbient),
        child: Stack(
          children: [
            // Efecto de glow decorativo
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.flareRed.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.pulseMagenta.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal
            SafeArea(
              child: Column(
                children: [
                  // Botón Omitir con estilo minimalista
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: TextButton(
                        onPressed: _handleAlreadyHaveAccount,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Omitir',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3F3F44),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView con slides
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: AppSpacing.xxl),
                                
                                // Imagen con efecto fade-out (gradient mask)
                                Hero(
                                  tag: 'visual_$index',
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 300,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Imagen con gradient mask (fade-out de arriba a abajo)
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: const [
                                                Colors.white,      // Opaco arriba
                                                Colors.white,      // Opaco medio-alto
                                                Colors.transparent, // Transparente abajo
                                              ],
                                              stops: const [0.0, 0.5, 1.0],
                                            ).createShader(bounds);
                                          },
                                          blendMode: BlendMode.dstIn,
                                          child: Image.asset(
                                            slide.imagePath,
                                            height: 280,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.xxl),

                                // Título con estilo bold moderno
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                  ),
                                  child: _buildStyledTitle(slide.title),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),

                                // Descripción con mejor legibilidad
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg,
                                  ),
                                  child: Text(
                                    slide.description,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF6B6B73),
                                      height: 1.5,
                                      letterSpacing: 0.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.xxl),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Indicadores de página animados
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _currentPage == index
                              ? AppGradients.flameHero
                              : null,
                          color: _currentPage == index ? null : AppColors.line,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Botones con mejor armonía visual
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // Botón primario con gradiente
                        PrimaryButton(
                          text: 'Crear cuenta',
                          onPressed: _handleGetStarted,
                          fullWidth: true,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Botón secundario con estilo text-link elegante
                        TextButton(
                          onPressed: _handleAlreadyHaveAccount,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppGradients.flameHero.createShader(bounds),
                            child: const Text(
                              'Ya tengo cuenta',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeSlide {
  final String title;
  final String description;
  final String imagePath;
  final bool useGradientBackground;
  final List<Color>? gradientColors;

  WelcomeSlide({
    required this.title,
    required this.description,
    required this.imagePath,
    this.useGradientBackground = false,
    this.gradientColors,
  });
}
