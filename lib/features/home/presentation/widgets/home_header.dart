import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/ui/theme/gradients.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.emberOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wb_sunny_rounded,
                          color: AppColors.emberOrange,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'EEEE d, MMMM',
                          'es',
                        ).format(DateTime.now()).toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkSoft,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hola, ',
                          style: AppTypography.displayM.copyWith(
                            color: AppColors.inkMuted,
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                        TextSpan(
                          text: name,
                          style: AppTypography.displayM.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.flameHero,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.flareRed.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
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
            ),
          ],
        );
      },
    );
  }
}
