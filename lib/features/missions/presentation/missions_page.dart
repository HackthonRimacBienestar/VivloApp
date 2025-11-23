import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';

import '../data/missions_repository.dart';
import '../domain/health_challenge.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final MissionsRepository _repository = MissionsRepository();
  late ConfettiController _confettiController;
  List<HealthChallenge> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _loadChallenges();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadChallenges() async {
    setState(() => _isLoading = true);
    final challenges = await _repository.getMyChallenges();
    if (mounted) {
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    }
  }

  Future<void> _completeChallenge(HealthChallenge challenge) async {
    try {
      await _repository.completeChallenge(challenge.id);
      await _loadChallenges(); // Reload to update status
      if (mounted) {
        _confettiController.play();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Misión completada! +50 puntos')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al completar: $e')));
      }
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha límite';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Mis Misiones',
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
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _challenges.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadChallenges,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _challenges.length,
                    itemBuilder: (context, index) {
                      return _buildChallengeCard(_challenges[index]);
                    },
                  ),
                ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: AppColors.inkSoft),
          const SizedBox(height: 16),
          Text(
            'No tienes misiones activas',
            style: AppTypography.title.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 8),
          Text(
            'Habla con Vivlo para recibir nuevos retos',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(HealthChallenge challenge) {
    final isCompleted = challenge.status == ChallengeStatus.completed;
    final categoryName = _getCategoryName(challenge.category);
    final dueDateStr = _formatDate(challenge.dueDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: Border.all(
          color: isCompleted
              ? AppColors.statusSuccess.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isCompleted ? null : () => _showChallengeDetails(challenge),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCategoryIcon(challenge.category, isCompleted),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHint.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              categoryName,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.inkMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (challenge.dueDate != null && !isCompleted)
                            Text(
                              'Vence: $dueDateStr',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.statusError,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        challenge.title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? AppColors.inkSoft
                              : AppColors.ink,
                        ),
                      ),
                      if (challenge.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          challenge.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.emberOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${challenge.pointsReward} pts',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.emberOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: AppColors.statusSuccess)
                else
                  const Icon(Icons.chevron_right, color: AppColors.inkSoft),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(ChallengeCategory category, bool isCompleted) {
    IconData icon;
    Color color;

    switch (category) {
      case ChallengeCategory.glucose_check:
        icon = Icons.water_drop_rounded;
        color = Colors.blue;
        break;
      case ChallengeCategory.diet:
        icon = Icons.restaurant_rounded;
        color = Colors.green;
        break;
      case ChallengeCategory.exercise:
        icon = Icons.directions_run_rounded;
        color = Colors.orange;
        break;
      case ChallengeCategory.medication:
        icon = Icons.medication_rounded;
        color = Colors.red;
        break;
      case ChallengeCategory.mental_wellbeing:
        icon = Icons.self_improvement_rounded;
        color = Colors.purple;
        break;
    }

    if (isCompleted) {
      color = AppColors.inkSoft;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  void _showChallengeDetails(HealthChallenge challenge) {
    final categoryName = _getCategoryName(challenge.category);
    final dueDateStr = _formatDate(challenge.dueDate);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inkSoft.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildCategoryIcon(challenge.category, false),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (challenge.dueDate != null)
                      Text(
                        'Vence: $dueDateStr',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.statusError,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              challenge.title,
              style: AppTypography.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              challenge.description ?? '',
              style: AppTypography.body.copyWith(color: AppColors.ink),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recompensa', style: AppTypography.caption),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.emberOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.pointsReward} puntos',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.emberOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _completeChallenge(challenge);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Completar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
