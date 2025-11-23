import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/health_score_card.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/rewards_carousel.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  // Usamos un ValueNotifier para notificar cuando debe refrescarse
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger refresh cuando regresamos a este tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTrigger.value++;
    });
  }

  @override
  void dispose() {
    _refreshTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: AppSpacing.xl),
              const HealthScoreCard(),
              const SizedBox(height: AppSpacing.xl),
              MetricsGrid(refreshTrigger: _refreshTrigger),
              const SizedBox(height: AppSpacing.xl),
              const RewardsCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
