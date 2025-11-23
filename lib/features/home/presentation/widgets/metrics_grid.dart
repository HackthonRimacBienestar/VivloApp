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
              icon: Icons.fastfood,
              color: Color(0xFFEF5350),
              chartType: ChartType.bar,
              index: 0,
            ),
            MetricCard(
              title: 'BIENESTAR EMOCIONAL',
              icon: Icons.psychology,
              color: Color(0xFFE57373),
              chartType: ChartType.line,
              index: 1,
            ),
            MetricCard(
              title: 'EJERCICIOS Y SALUD',
              icon: Icons.directions_run,
              color: Color(0xFFF44336),
              chartType: ChartType.line,
              index: 2,
            ),
            MetricCard(
              title: 'SUEÑO Y DESCANSO',
              icon: Icons.bedtime,
              color: Color(0xFFE53935),
              chartType: ChartType.bar,
              index: 3,
            ),
          ],
        ),
      ],
    );
  }
}
