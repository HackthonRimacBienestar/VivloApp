import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import 'metric_card.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metrics',
          style: AppTypography.title.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.1,
          children: const [
            MetricCard(
              title: 'NUTRICIÓN',
              icon: Icons.restaurant_rounded,
              color: Color(0xFFEF5350),
              chartType: ChartType.bar,
              index: 0,
            ),
            MetricCard(
              title: 'BIENESTAR EMOCIONAL',
              icon: Icons.self_improvement_rounded,
              color: Color(0xFFAB47BC),
              chartType: ChartType.line,
              index: 1,
            ),
            MetricCard(
              title: 'EJERCICIOS Y SALUD',
              icon: Icons.directions_run_rounded,
              color: Color(0xFFFFA726),
              chartType: ChartType.line,
              index: 2,
            ),
            MetricCard(
              title: 'MEDICACIÓN',
              icon: Icons.medication_rounded,
              color: Color(0xFF42A5F5),
              chartType: ChartType.bar,
              index: 3,
            ),
          ],
        ),
      ],
    );
  }
}
