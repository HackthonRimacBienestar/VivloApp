import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';

class MissionsList extends StatelessWidget {
  const MissionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Misiones',
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ver todas',
                style: AppTypography.caption.copyWith(
                  color: AppColors.accentPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildMissionItem(
          title: 'Caminata diaria',
          subtitle: '30/30 minutos',
          progress: 1.0,
          icon: Icons.directions_walk,
          color: Colors.blue,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMissionItem(
          title: 'Beber agua',
          subtitle: '4/8 vasos',
          progress: 0.5,
          icon: Icons.local_drink,
          color: Colors.cyan,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMissionItem(
          title: 'Meditación',
          subtitle: '0/10 minutos',
          progress: 0.0,
          icon: Icons.self_improvement,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMissionItem({
    required String title,
    required String subtitle,
    required double progress,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surfaceHint,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
