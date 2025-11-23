import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/health_score_card.dart';
import '../widgets/metrics_grid.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SizedBox(height: AppSpacing.xl),
              HealthScoreCard(),
              SizedBox(height: AppSpacing.xl),
              MetricsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
