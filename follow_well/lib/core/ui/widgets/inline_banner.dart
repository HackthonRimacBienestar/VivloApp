import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

/// Inline Banner basado en design.json
class InlineBanner extends StatelessWidget {
  final BannerType type;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const InlineBanner({
    super.key,
    required this.type,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData defaultIcon;

    switch (type) {
      case BannerType.info:
        backgroundColor = AppColors.accentInfo;
        defaultIcon = Icons.info_outline;
        break;
      case BannerType.warning:
        backgroundColor = AppColors.statusWarning;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case BannerType.error:
        backgroundColor = AppColors.statusError;
        defaultIcon = Icons.error_outline;
        break;
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(icon ?? defaultIcon, size: 20, color: AppColors.pureWhite),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.pureWhite,
              ),
            ),
          ),
          if (actionLabel != null) ...[
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.pureWhite,
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}

enum BannerType { info, warning, error }
