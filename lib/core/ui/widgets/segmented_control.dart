import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/radii.dart';

/// Segmented Control basado en design.json
class AppSegmentedControl<T> extends StatelessWidget {
  final List<SegmentItem<T>> segments;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;

  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment.value == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(segment.value),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (segment.icon != null) ...[
                        Icon(
                          segment.icon,
                          size: 16,
                          color: isSelected ? AppColors.ink : AppColors.inkSoft,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        segment.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSelected ? AppColors.ink : AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  SegmentItem({required this.value, required this.label, this.icon});
}
