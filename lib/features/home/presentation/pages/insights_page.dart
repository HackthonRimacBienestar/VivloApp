import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../missions/data/missions_repository.dart';
import '../../../missions/domain/health_challenge.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final MissionsRepository _repository = MissionsRepository();
  Map<String, int> _dailyPoints = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final challenges = await _repository.getCompletedChallenges();

    final Map<String, int> dailyPoints = {};

    for (var challenge in challenges) {
      if (challenge.completedAt != null) {
        final dateKey = DateFormat('yyyy-MM-dd').format(challenge.completedAt!);
        dailyPoints[dateKey] =
            (dailyPoints[dateKey] ?? 0) + challenge.pointsReward;
      }
    }

    if (mounted) {
      setState(() {
        _dailyPoints = dailyPoints;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Insights',
          style: AppTypography.subtitle.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dailyPoints.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _dailyPoints.length,
              itemBuilder: (context, index) {
                final dateKey = _dailyPoints.keys.elementAt(index);
                final points = _dailyPoints[dateKey]!;
                final date = DateTime.parse(dateKey);

                return _buildDailyCard(date, points);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 64, color: AppColors.inkSoft),
          const SizedBox(height: 16),
          Text(
            'No hay datos suficientes',
            style: AppTypography.title.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 8),
          Text(
            'Completa misiones para ver tus estadísticas',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(DateTime date, int points) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isToday
            ? Border.all(color: AppColors.accentPrimary, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday
                      ? 'Hoy'
                      : DateFormat(
                          'EEEE d, MMMM',
                          'es',
                        ).format(date).toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  'Puntos ganados',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emberOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.emberOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$points',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.emberOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
