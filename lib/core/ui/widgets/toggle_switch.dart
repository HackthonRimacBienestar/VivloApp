import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Toggle Switch basado en design.json
class AppToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppToggleSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.accentPrimary,
      trackOutlineColor: WidgetStateProperty.all(AppColors.surfaceHint),
    );
  }
}
