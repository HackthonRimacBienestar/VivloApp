import 'package:flutter/material.dart';
import 'colors.dart';

/// Sistema de Gradientes de Marca
/// Basado en el branding: #F7052D (flare red), #FD6201 (ember orange), #D41983 (pulse magenta)
class AppGradients {
  AppGradients._();

  // ══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PRINCIPALES - Para fondos y superficies hero
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradiente primario vibrante: Rojo → Naranja
  /// Uso: Splash, welcome hero, CTAs principales
  static const LinearGradient flameHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.flareRed, AppColors.emberOrange],
  );

  /// Gradiente energético: Magenta → Rojo → Naranja
  /// Uso: Backgrounds completos, promo banners
  static const LinearGradient energyFlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.pulseMagenta, AppColors.flareRed, AppColors.emberOrange],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente Premium para Health Score Card
  static const LinearGradient healthScoreHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD32F2F), // Deep Red
      Color(0xFFE53935), // Red
      Color(0xFFFF5252), // Accent Red
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente suave difuminado para fondos (más sutil)
  /// Uso: Login, signup, forgot password backgrounds
  static const LinearGradient softAmbient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF5F2), // Casi blanco con tinte cálido
      Color(0xFFFFF0F5), // Blanco con tinte magenta suave
      Color(0xFFFFFAF5), // Blanco con tinte naranja suave
    ],
  );

  /// Gradiente radial difuminado desde el centro
  /// Uso: Overlays, efectos de profundidad
  static const RadialGradient radialGlow = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.5,
    colors: [
      Color(0x33F7052D), // Rojo semi-transparente
      Color(0x22FD6201), // Naranja semi-transparente
      Color(0x00FFFFFF), // Transparente
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PARA COMPONENTES
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradiente para botones primarios
  static const LinearGradient buttonPrimary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.flareRed,
      Color(0xFFFA1845), // Tono intermedio
      AppColors.emberOrange,
    ],
  );

  /// Gradiente para tarjetas destacadas
  static const LinearGradient cardAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AF7052D), // Rojo muy transparente
      Color(0x0FFD6201), // Naranja muy transparente
    ],
  );

  /// Gradiente para indicadores de progreso
  static const LinearGradient progressIndicator = LinearGradient(
    colors: [AppColors.pulseMagenta, AppColors.flareRed, AppColors.emberOrange],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // EFECTOS DE SHIMMER Y LOADING
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradiente shimmer para esqueletos de carga
  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, 0.5),
    colors: [Color(0xFFF5F5F2), Color(0xFFFFFFFF), Color(0xFFF5F5F2)],
    stops: [0.0, 0.5, 1.0],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // OVERLAYS Y GLASSMORPHISM
  // ══════════════════════════════════════════════════════════════════════════

  /// Overlay oscuro con gradiente para modales
  static const LinearGradient scrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x80000000), Color(0xCC000000)],
  );

  /// Glass effect: semi-transparente con blur
  static BoxDecoration glassEffect({
    BorderRadius? borderRadius,
    Color? tintColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (tintColor ?? Colors.white).withOpacity(0.2),
          (tintColor ?? Colors.white).withOpacity(0.1),
        ],
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UTILIDADES - Gradientes personalizados
  // ══════════════════════════════════════════════════════════════════════════

  /// Crea un gradiente suave con opacidad variable
  static LinearGradient createSoftGradient({
    required Color color,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color.withOpacity(0.15),
        color.withOpacity(0.05),
        Colors.transparent,
      ],
    );
  }

  /// Crea un gradiente de dos colores con stops personalizados
  static LinearGradient createCustomGradient({
    required Color startColor,
    required Color endColor,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, endColor],
      stops: stops,
    );
  }
}

/// Decoraciones preconstruidas para fondos comunes
class AppBackgrounds {
  AppBackgrounds._();

  /// Fondo blanco puro (fallback)
  static const BoxDecoration solid = BoxDecoration(color: AppColors.surface);

  /// Fondo con gradiente suave ambiente
  static const BoxDecoration softGradient = BoxDecoration(
    gradient: AppGradients.softAmbient,
  );

  /// Fondo con gradiente energético completo
  static const BoxDecoration energyGradient = BoxDecoration(
    gradient: AppGradients.energyFlow,
  );

  /// Fondo con glow radial en la parte superior
  static const BoxDecoration glowTop = BoxDecoration(
    color: AppColors.surface,
    gradient: AppGradients.radialGlow,
  );

  /// Fondo con gradiente + efecto radial combinado
  static BoxDecoration ambientWithGlow = BoxDecoration(
    gradient: AppGradients.softAmbient,
    image: DecorationImage(
      image: const AssetImage('assets/noise_texture.png'),
      fit: BoxFit.cover,
      opacity: 0.03,
      colorFilter: ColorFilter.mode(
        AppColors.flareRed.withOpacity(0.1),
        BlendMode.overlay,
      ),
    ),
  );
}
