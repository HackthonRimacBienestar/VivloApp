import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../data/missions_repository.dart';
import '../domain/health_challenge.dart';

class MissionsPage extends StatefulWidget {
  final ChallengeCategory? filterCategory;

  const MissionsPage({super.key, this.filterCategory});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage>
    with SingleTickerProviderStateMixin {
  final MissionsRepository _repository = MissionsRepository();
  late ConfettiController _confettiController;
  late AnimationController _animationController;

  List<HealthChallenge> _challenges = [];
  bool _isLoading = true;
  ChallengeCategory? _activeFilter;

  @override
  void initState() {
    super.initState();
    _activeFilter = widget.filterCategory;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadChallenges();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadChallenges() async {
    setState(() => _isLoading = true);
    final allChallenges = await _repository.getMyChallenges();

    List<HealthChallenge> filteredChallenges = allChallenges;
    if (_activeFilter != null) {
      filteredChallenges = allChallenges
          .where((c) => c.category == _activeFilter)
          .toList();
    }

    // Ordenar por urgencia: las que tienen menos tiempo restante primero
    filteredChallenges.sort((a, b) {
      // Misiones completadas van al final
      if (a.status == ChallengeStatus.completed &&
          b.status != ChallengeStatus.completed) {
        return 1;
      }
      if (b.status == ChallengeStatus.completed &&
          a.status != ChallengeStatus.completed) {
        return -1;
      }

      // Si ambas están completadas o ambas activas, ordenar por fecha de vencimiento
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1; // Sin fecha va al final
      if (b.dueDate == null) return -1; // Sin fecha va al final

      // Ordenar por fecha más cercana primero
      return a.dueDate!.compareTo(b.dueDate!);
    });

    if (mounted) {
      setState(() {
        _challenges = filteredChallenges;
        _isLoading = false;
      });
      _animationController.forward(from: 0);
    }
  }

  Future<void> _completeChallenge(HealthChallenge challenge) async {
    try {
      await _repository.completeChallenge(challenge.id);
      await _loadChallenges();
      if (mounted) {
        _confettiController.play();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Misión completada! +50 puntos'),
            backgroundColor: AppColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al completar: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
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
    return DateFormat('dd MMM', 'es').format(date);
  }

  String _getTimeRemaining(DateTime? dueDate) {
    if (dueDate == null) return '';

    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Vencida';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d restantes';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h restantes';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min restantes';
    } else {
      return 'Vence pronto';
    }
  }

  void _clearFilter() {
    setState(() {
      _activeFilter = null;
    });
    _loadChallenges();
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
          Column(
            children: [
              if (_activeFilter != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filtrado por:',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(_getCategoryName(_activeFilter!)),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: _clearFilter,
                        backgroundColor: AppColors.accentPrimary.withOpacity(
                          0.1,
                        ),
                        labelStyle: AppTypography.caption.copyWith(
                          color: AppColors.accentPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _challenges.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadChallenges,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _challenges.length,
                          itemBuilder: (context, index) {
                            return _buildAnimatedChallengeCard(
                              _challenges[index],
                              index,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  AppColors.accentPrimary,
                  AppColors.emberOrange,
                  AppColors.statusSuccess,
                  Colors.blue,
                  Colors.purple,
                ],
              ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceHint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              size: 48,
              color: AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay misiones activas',
            style: AppTypography.title.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _activeFilter != null
                ? 'No hay misiones para esta categoría'
                : 'Habla con Vivlo para recibir nuevos retos',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
            textAlign: TextAlign.center,
          ),
          if (_activeFilter != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: _clearFilter,
                child: const Text('Ver todas las misiones'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedChallengeCard(HealthChallenge challenge, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double delay = index * 0.1;
        final double slide = Curves.easeOutQuad.transform(
          (_animationController.value - delay).clamp(0.0, 1.0),
        );
        final double opacity = (_animationController.value - delay).clamp(
          0.0,
          1.0,
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - slide)),
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: _buildChallengeCard(challenge),
    );
  }

  Widget _buildChallengeCard(HealthChallenge challenge) {
    final isCompleted = challenge.status == ChallengeStatus.completed;
    final categoryName = _getCategoryName(challenge.category);
    final dueDateStr = _formatDate(challenge.dueDate);
    final timeRemaining = _getTimeRemaining(challenge.dueDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isCompleted
              ? AppColors.statusSuccess.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isCompleted ? null : () => _showChallengeDetails(challenge),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              categoryName.toUpperCase(),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.inkMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (challenge.difficultyLevel > 0)
                            Row(
                              children: List.generate(
                                challenge.difficultyLevel,
                                (index) => Icon(
                                  Icons.bolt_rounded,
                                  size: 14,
                                  color: AppColors.emberOrange.withOpacity(0.6),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        challenge.title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? AppColors.inkSoft
                              : AppColors.ink,
                        ),
                      ),
                      if (challenge.description != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          challenge.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.inkSoft,
                            height: 1.3,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (challenge.dueDate != null && !isCompleted) ...[
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.statusError,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeRemaining,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.statusError,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '· $dueDateStr',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.inkSoft,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.emberOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 14,
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.statusSuccess.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.statusSuccess,
                      size: 20,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.inkSoft.withOpacity(0.5),
                    size: 24,
                  ),
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
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceHint,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.inkSoft, size: 24),
      );
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
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: AppColors.inkSoft.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                _buildCategoryIcon(challenge.category, false),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName.toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkMuted,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.title,
                        style: AppTypography.title.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceHint.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                challenge.description ?? 'Sin descripción',
                style: AppTypography.body.copyWith(
                  color: AppColors.ink,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.calendar_today_rounded,
                    'Vence',
                    dueDateStr,
                    AppColors.ink,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.bolt_rounded,
                    'Dificultad',
                    'Nivel ${challenge.difficultyLevel}',
                    AppColors.ink,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    Icons.star_rounded,
                    'Recompensa',
                    '${challenge.pointsReward} pts',
                    AppColors.emberOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _completeChallenge(challenge);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Completar Misión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.inkSoft),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
