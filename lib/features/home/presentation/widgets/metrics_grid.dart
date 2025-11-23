import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../missions/data/missions_repository.dart';
import '../../../missions/domain/health_challenge.dart';
import '../../../missions/presentation/pages/category_metrics_page.dart';

class MetricsGrid extends StatefulWidget {
  final ValueNotifier<int>? refreshTrigger;

  const MetricsGrid({super.key, this.refreshTrigger});

  @override
  State<MetricsGrid> createState() => _MetricsGridState();
}

class _MetricsGridState extends State<MetricsGrid> {
  final MissionsRepository _missionsRepository = MissionsRepository();
  Map<ChallengeCategory, int> _challengeCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();

    // Escuchar cambios en el trigger para refrescar
    widget.refreshTrigger?.addListener(_onRefreshTriggered);
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_onRefreshTriggered);
    super.dispose();
  }

  void _onRefreshTriggered() {
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final counts = await _missionsRepository.getChallengeCounts();
    if (mounted) {
      setState(() {
        _challengeCounts = counts;
        _isLoading = false;
      });
    }
  }

  // Método público para refrescar los datos desde fuera
  void refreshData() {
    _loadCounts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu Progreso',
          style: AppTypography.title.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Misiones completadas por categoría',
          style: AppTypography.body.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.5,
          children: ChallengeCategory.values.map((category) {
            final count = _challengeCounts[category] ?? 0;
            return _buildMetricCard(category, count);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricCard(ChallengeCategory category, int count) {
    final (icon, color, label) = _getCategoryDetails(category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryMetricsPage(category: category),
              ),
            );
            // Recargar los contadores cuando se regresa
            _loadCounts();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    Text(
                      count.toString(),
                      style: AppTypography.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkSoft,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color, String) _getCategoryDetails(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.glucose_check:
        return (Icons.water_drop_rounded, Colors.blue, 'Glucosa');
      case ChallengeCategory.diet:
        return (Icons.restaurant_rounded, Colors.green, 'Alimentación');
      case ChallengeCategory.exercise:
        return (Icons.directions_run_rounded, Colors.orange, 'Ejercicio');
      case ChallengeCategory.medication:
        return (Icons.medication_rounded, Colors.red, 'Medicación');
      case ChallengeCategory.mental_wellbeing:
        return (Icons.self_improvement_rounded, Colors.purple, 'Bienestar');
    }
  }
}
