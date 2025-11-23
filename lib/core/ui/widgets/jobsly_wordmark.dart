import 'package:flutter/material.dart';

/// Wordmark profesional y estructurado para RIMAC Contigo.
/// Diseño moderno con jerarquía visual clara y espaciado preciso.
class JobslyWordmark extends StatelessWidget {
  final double brandFontSize;
  final double productFontSize;
  final bool showLogo;
  final EdgeInsetsGeometry? padding;
  final double logoSize;

  const JobslyWordmark({
    super.key,
    this.brandFontSize = 13,
    this.productFontSize = 30,
    this.logoSize = 48,
    this.showLogo = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Estilo para la marca (RIMAC) - más sutil y elegante
    final brandStyle = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: brandFontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.4,
      height: 1.2,
      color: Colors.white.withOpacity(0.92),
    );

    // Estilo para el producto (Contigo) - más prominente y legible
    final productStyle = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: productFontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.1,
      color: Colors.white,
    );

    // Logo con diseño profesional y sombra sutil
    // Logo con diseño profesional
    final logo = Image.asset(
      'assets/1024.png',
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLogo) ...[logo, const SizedBox(width: 16)],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('RIMAC', style: brandStyle),
                const SizedBox(height: 2),
                Text('Vivlo', style: productStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
