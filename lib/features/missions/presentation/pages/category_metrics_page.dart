import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../data/missions_repository.dart';
import '../../domain/health_challenge.dart';

class CategoryMetricsPage extends StatefulWidget {
  final ChallengeCategory category;

  const CategoryMetricsPage({super.key, required this.category});

  @override
  State<CategoryMetricsPage> createState() => _CategoryMetricsPageState();
}

class _CategoryMetricsPageState extends State<CategoryMetricsPage> {
  final MissionsRepository _repository = MissionsRepository();
  bool _isLoading = true;
  int _completedCount = 0;
  int _totalPoints = 0;
  List<Map<String, dynamic>> _glucoseLogs = [];
  List<HealthChallenge> _categoryMissions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Fetch all challenges to calculate stats
    final allChallenges = await _repository.getMyChallenges();
    final categoryChallenges = allChallenges
        .where((c) => c.category == widget.category)
        .toList();

    final completed = categoryChallenges
        .where((c) => c.status == ChallengeStatus.completed)
        .toList();

    int points = 0;
    for (var c in completed) {
      points += c.pointsReward;
    }

    // Fetch glucose logs if applicable
    if (widget.category == ChallengeCategory.glucose_check) {
      final logs = await _repository.getGlucoseLogs();
      if (mounted) {
        setState(() {
          _glucoseLogs = logs;
        });
      }
    }

    if (mounted) {
      setState(() {
        _categoryMissions = categoryChallenges;
        _completedCount = completed.length;
        _totalPoints = points;
        _isLoading = false;
      });
    }
  }

  String _getCategoryName(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.glucose_check:
        return 'Control de Glucosa';
      case ChallengeCategory.diet:
        return 'Alimentación';
      case ChallengeCategory.exercise:
        return 'Ejercicio';
      case ChallengeCategory.medication:
        return 'Medicación';
      case ChallengeCategory.mental_wellbeing:
        return 'Bienestar Mental';
    }
  }

  (IconData, Color) _getCategoryStyle(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.glucose_check:
        return (Icons.water_drop_rounded, Colors.blue);
      case ChallengeCategory.diet:
        return (Icons.restaurant_rounded, Colors.green);
      case ChallengeCategory.exercise:
        return (Icons.directions_run_rounded, Colors.orange);
      case ChallengeCategory.medication:
        return (Icons.medication_rounded, Colors.red);
      case ChallengeCategory.mental_wellbeing:
        return (Icons.self_improvement_rounded, Colors.purple);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getCategoryStyle(widget.category);
    final categoryName = _getCategoryName(widget.category);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          categoryName,
          style: AppTypography.subtitle.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(icon, color, categoryName),
                  const SizedBox(height: 24),
                  if (widget.category == ChallengeCategory.glucose_check) ...[
                    _buildGlucoseChart(color),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Historial de Misiones',
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMissionsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard(IconData icon, Color color, String name) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso Total',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '$_completedCount completadas',
                    style: AppTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Puntos Ganados', '$_totalPoints', Colors.white),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  'Total Asignadas',
                  '${_categoryMissions.length}',
                  Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.subtitle.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGlucoseChart(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Últimas Mediciones',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.show_chart_rounded, color: color),
            ],
          ),
          const SizedBox(height: 16),
          if (_glucoseLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No hay registros recientes',
                  style: AppTypography.body.copyWith(color: AppColors.inkSoft),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _glucoseLogs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final log = _glucoseLogs[index];
                final value = log['value_mg_dl'];
                final date = DateTime.parse(log['measured_at']);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$value mg/dL',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          if (log['notes'] != null)
                            Text(
                              log['notes'],
                              style: AppTypography.caption.copyWith(
                                color: AppColors.inkSoft,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        DateFormat('dd/MM HH:mm').format(date),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMissionsList() {
    if (_categoryMissions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No hay misiones en esta categoría',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categoryMissions.length,
      itemBuilder: (context, index) {
        final challenge = _categoryMissions[index];
        final isCompleted = challenge.status == ChallengeStatus.completed;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted
                  ? AppColors.statusSuccess.withOpacity(0.3)
                  : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isCompleted ? AppColors.inkSoft : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted ? 'Completado' : 'Pendiente',
                      style: AppTypography.caption.copyWith(
                        color: isCompleted
                            ? AppColors.statusSuccess
                            : AppColors.inkSoft,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.statusSuccess,
                  size: 20,
                ),
            ],
          ),
        );
      },
    );
  }
}
