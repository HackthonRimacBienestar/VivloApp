# Rimac Vivlo - Design System Quick Reference

## 🎨 Brand Colors

### Primary Palette
```dart
AppColors.flareRed       // #F7052D - Primary energy, hero CTAs
AppColors.emberOrange    // #FD6201 - Secondary actions, warmth
AppColors.pulseMagenta   // #D41983 - Info accents, premium
AppColors.pureWhite      // #FFFFFF - Typography on dark fills
AppColors.whatsappGreen  // #00FF7F - WhatsApp button only
```

### Usage
```dart
// Primary CTA
PrimaryButton(
  text: 'Continuar',
  onPressed: () {},
)

// WhatsApp Support
WhatsAppButton(
  text: 'Soporte',
  onPressed: () {},
)
```

## 🌈 Gradient System

### Background Gradients
```dart
// Energetic full-screen gradient (Splash, Hero sections)
Container(
  decoration: const BoxDecoration(
    gradient: AppGradients.energyFlow,
  ),
)

// Soft ambient (Login, Forms, Content)
Container(
  decoration: const BoxDecoration(
    gradient: AppGradients.softAmbient,
  ),
)

// Hero section gradient
Container(
  decoration: const BoxDecoration(
    gradient: AppGradients.flameHero,
  ),
)
```

### Component Gradients
```dart
// Button with gradient
Container(
  decoration: const BoxDecoration(
    gradient: AppGradients.buttonPrimary,
    borderRadius: BorderRadius.circular(999),
  ),
  child: ...,
)

// Gradient text effect
ShaderMask(
  shaderCallback: (bounds) => AppGradients.flameHero.createShader(bounds),
  child: Text(
    'Título con Gradiente',
    style: TextStyle(
      color: Colors.white, // Required for ShaderMask
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### Decorative Effects
```dart
// Floating glow circle
Positioned(
  top: -100,
  right: -80,
  child: Container(
    width: 250,
    height: 250,
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
)
```

## 🪟 Glassmorphism

### Glass Card
```dart
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
      child: ..., // Your content
    ),
  ),
)
```

### Glass Button
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: TextButton(...),
    ),
  ),
)
```

## ✨ Visual Effects

### Elevated Logo/Icon
```dart
Container(
  padding: const EdgeInsets.all(AppSpacing.lg),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: AppColors.flareRed.withOpacity(0.2),
        blurRadius: 30,
        spreadRadius: 5,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: Image.asset('assets/logo.png', height: 70),
)
```

### Gradient Progress Indicator
```dart
Container(
  width: 200,
  height: 4,
  decoration: BoxDecoration(
    gradient: AppGradients.progressIndicator,
    borderRadius: BorderRadius.circular(2),
  ),
)
```

### Animated Page Indicators
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: isActive ? 32 : 8,
  height: 8,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    gradient: isActive ? AppGradients.flameHero : null,
    color: isActive ? null : AppColors.line,
  ),
)
```

## 📐 Layout Patterns

### Auth Page Structure
```dart
Container(
  decoration: const BoxDecoration(
    gradient: AppGradients.softAmbient,
  ),
  child: Stack(
    children: [
      // Decorative glow circles (2-3 max)
      _buildDecorativeGlow(),
      
      // Main content
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Hero section (logo, title)
              _buildHeroSection(),
              
              // Glass form card
              _buildGlassFormCard(),
              
              // CTAs
              _buildActions(),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

### Form Card Pattern
```dart
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
      ),
      child: Column(
        children: [
          // Form fields with spacing
        ],
      ),
    ),
  ),
)
```

## 🎯 Spacing System

```dart
AppSpacing.xxs  // 4pt
AppSpacing.xs   // 8pt
AppSpacing.sm   // 12pt
AppSpacing.md   // 16pt - Default horizontal padding
AppSpacing.lg   // 20pt - Comfortable spacing
AppSpacing.xl   // 24pt - Section breaks
AppSpacing.xxl  // 32pt - Major sections
AppSpacing.hero // 48pt - Hero spacing
```

## 🔤 Typography with Gradients

### Gradient Headlines
```dart
ShaderMask(
  shaderCallback: (bounds) => AppGradients.flameHero.createShader(bounds),
  child: Text(
    'Bienvenido',
    style: AppTypography.displayM.copyWith(
      color: Colors.white, // Required
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### Regular Text
```dart
Text(
  'Descripción',
  style: AppTypography.body.copyWith(
    color: AppColors.inkMuted,
    height: 1.5, // Line height
  ),
)
```

## 🎬 Animations

### Fade + Scale Entrance
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: YourContent(),
      ),
    );
  }
}
```

## 📱 Responsive Considerations

```dart
// Get screen size
final size = MediaQuery.of(context).size;
final isSmallScreen = size.width < 600;

// Adaptive padding
padding: EdgeInsets.symmetric(
  horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.xxl,
)

// Adaptive font size
style: AppTypography.displayM.copyWith(
  fontSize: isSmallScreen ? 24 : 32,
)
```

## ✅ Best Practices

1. **Always use gradients from `AppGradients`** - Don't create inline gradients
2. **Limit decorative glows** - 2-3 per screen maximum
3. **Glassmorphism sparingly** - Main content cards only
4. **Animate entrances** - Fade + scale for key content
5. **Maintain contrast** - White text on gradients, dark text on glass
6. **Touch targets** - Minimum 48x48pt
7. **Dispose controllers** - Always clean up animations
8. **Test on devices** - Blur effects can be expensive

## 🚀 Quick Start Template

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/theme/gradients.dart';
import '../../../core/ui/theme/spacing.dart';
import '../../../core/ui/theme/typography.dart';

class MyNewPage extends StatelessWidget {
  const MyNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.softAmbient,
        ),
        child: Stack(
          children: [
            // Decorative glow
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
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

            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    // Your content here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---
**For full documentation, see `design.json` and `AUTH_DESIGN_ENHANCEMENTS.md`**
