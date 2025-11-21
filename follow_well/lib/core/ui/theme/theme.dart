import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Tema de la aplicación basado en design.json
/// 
/// Incluye soporte para:
/// - Colores de marca y semánticos
/// - Tipografía personalizada
/// - Gradientes y efectos visuales (ver AppGradients en gradients.dart)
/// - Elevaciones y sombras
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        background: AppColors.background,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onPrimary,
        onError: AppColors.onError,
        onSurface: AppColors.onSurface,
        onBackground: AppColors.onBackground,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayL,
        displayMedium: AppTypography.displayM,
        headlineMedium: AppTypography.title,
        titleMedium: AppTypography.subtitle,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.bodySmall,
        labelLarge: AppTypography.button, // Botones usan SemiBold
        bodySmall: AppTypography.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        titleTextStyle: AppTypography.subtitle,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
