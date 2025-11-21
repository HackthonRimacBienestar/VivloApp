import 'package:flutter/material.dart';

/// Colores de la aplicación basados en design.json
class AppColors {
  // Neutrals
  static const Color ink = Color(0xFF0B0B0F);
  static const Color inkMuted = Color(0xFF3F3F44);
  static const Color inkSoft = Color(0xFF6B6B73);
  static const Color line = Color(0xFFD7D7D3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF5F5F2);
  static const Color surfaceHint = Color(0xFFF0F0EA);

  // Brand Palette
  static const Color flareRed = Color(0xFFF7052D);
  static const Color emberOrange = Color(0xFFFD6201);
  static const Color pulseMagenta = Color(0xFFD41983);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color whatsappGreen = Color(0xFF00FF7F);

  // Accent
  static const Color accentPrimary = flareRed;
  static const Color accentSecondary = emberOrange;
  static const Color accentInfo = pulseMagenta;
  static const Color accentPromo = pureWhite;
  static const Color accentHighlight = Color(0xFFFFF5F2);
  static const Color accentDanger = flareRed;
  static const Color accentWhatsapp = whatsappGreen;

  // Status
  static const Color statusSuccess = Color(0xFF31B579);
  static const Color statusWarning = Color(0xFFFFAF3F);
  static const Color statusError = Color(0xFFFF5A5F);
  static const Color statusOffline = Color(0xFF9C9C9C);

  // Semantic roles
  static const Color primary = accentPrimary;
  static const Color onPrimary = neutralsSurface;
  static const Color primaryContainer = accentSecondary;
  static const Color onPrimaryContainer = neutralsInk;
  static const Color onSurface = neutralsInk;
  static const Color surfaceMutedColor = surfaceMuted;
  static const Color onSurfaceMuted = inkSoft;
  static const Color surfaceVariant = surfaceHint;
  static const Color onSurfaceVariant = inkSoft;
  static const Color outline = line;
  static const Color error = statusError;
  static const Color onError = neutralsSurface;
  static const Color success = statusSuccess;
  static const Color warning = statusWarning;

  // Legacy compatibility
  static const Color neutralsInk = ink;
  static const Color neutralsSurface = surface;
  static const Color secondary = accentSecondary;
  static const Color background = surfaceMuted;
  static const Color onBackground = ink;
}
