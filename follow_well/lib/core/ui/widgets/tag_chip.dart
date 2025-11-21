import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/radii.dart';

/// Tag / Chip basado en design.json
class TagChip extends StatelessWidget {
  final String label;
  final TagChipVariant variant;
  final bool isSelected;

  const TagChip({
    super.key,
    required this.label,
    this.variant = TagChipVariant.primary,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    switch (variant) {
      case TagChipVariant.primary:
        backgroundColor = AppColors.accentPrimary;
        break;
      case TagChipVariant.secondary:
        backgroundColor = AppColors.accentSecondary;
        break;
      case TagChipVariant.info:
        backgroundColor = AppColors.accentInfo;
        break;
    }

    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

enum TagChipVariant { primary, secondary, info }
