import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Radio Group basado en design.json
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: WidgetStateProperty.all(AppColors.accentPrimary),
    );

    if (label != null) {
      return Row(
        children: [
          widget,
          const SizedBox(width: 8),
          Text(label!, style: AppTypography.bodySmall),
        ],
      );
    }

    return widget;
  }
}
