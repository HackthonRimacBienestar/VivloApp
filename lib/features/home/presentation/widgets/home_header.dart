import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es');
    return Builder(
      builder: (context) {
        final user = AuthService().credentials?.user;
        final name = user?.nickname ?? user?.name ?? 'Usuario';
        final pictureUrl = user?.pictureUrl?.toString();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        color: AppColors.emberOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'EEE d MMM',
                          'es',
                        ).format(DateTime.now()).toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hola, $name',
                    style: AppTypography.displayM.copyWith(
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentPrimary, width: 2),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  pictureUrl ??
                      'https://i.pravatar.cc/150?u=a042581f4e29026024d',
                ),
                backgroundColor: AppColors.surfaceHint,
              ),
            ),
          ],
        );
      },
    );
  }
}
