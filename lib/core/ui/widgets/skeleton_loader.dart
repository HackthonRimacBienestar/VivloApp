import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radii.dart';
import '../theme/spacing.dart';

/// Skeleton Loader basado en design.json
class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceHint,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadii.soft),
      ),
    );
  }
}

/// Skeleton List Item
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          SkeletonLoader(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(AppRadii.soft),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLoader(width: double.infinity, height: 12),
                const SizedBox(height: AppSpacing.xs),
                SkeletonLoader(width: 150, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton Card
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surfaceHint,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
