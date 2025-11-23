import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';

class RewardsCarousel extends StatelessWidget {
  const RewardsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recompensas',
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.stars, color: AppColors.emberOrange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '72 pts',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.emberOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _rewards.length,
            itemBuilder: (context, index) {
              final reward = _rewards[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _rewards.length - 1 ? AppSpacing.sm : 0,
                ),
                child: _RewardCard(
                  title: reward.title,
                  description: reward.description,
                  points: reward.points,
                  icon: reward.icon,
                  color: reward.color,
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static List<_RewardData> get _rewards => [
    _RewardData(
      title: 'Consulta Nutricional',
      description: 'Sesión personalizada',
      points: '30 pts',
      icon: Icons.restaurant_menu,
      color: AppColors.flareRed,
    ),
    _RewardData(
      title: 'Descuento Gimnasio',
      description: '20% off membresia',
      points: '50 pts',
      icon: Icons.fitness_center,
      color: const Color(0xFF31B579), // status.success
    ),
    _RewardData(
      title: 'Clase de Yoga',
      description: 'Sesión virtual',
      points: '25 pts',
      icon: Icons.self_improvement,
      color: const Color(0xFFD41983), // accent.info (pulse_magenta)
    ),
    _RewardData(
      title: 'Check-up Médico',
      description: 'Evaluación completa',
      points: '80 pts',
      icon: Icons.medical_services,
      color: AppColors.emberOrange,
    ),
  ];
}

class _RewardData {
  final String title;
  final String description;
  final String points;
  final IconData icon;
  final Color color;

  _RewardData({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
  });
}

class _RewardCard extends StatefulWidget {
  final String title;
  final String description;
  final String points;
  final IconData icon;
  final Color color;
  final int index;

  const _RewardCard({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  State<_RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<_RewardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Stagger animation based on index
    final delay = widget.index * 80;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                width: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 22),
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      widget.title,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.2,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      widget.description,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Points chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            color: widget.color,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.points,
                            style: TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
