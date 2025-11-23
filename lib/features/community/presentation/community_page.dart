import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../domain/community_group.dart';
import 'community_chat_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommunityHeader(),
              SizedBox(height: AppSpacing.xl),
              _AmbientSupportCard(),
              SizedBox(height: AppSpacing.xl),
              _FiltersSection(),
              SizedBox(height: AppSpacing.xl),
              _GroupsSection(),
              SizedBox(height: AppSpacing.xl),
              _CirclesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu comunidad',
          style: AppTypography.displayM.copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Comparte avances, dudas y pequeños triunfos con personas que entienden tu ritmo.',
          style: AppTypography.body.copyWith(color: AppColors.inkSoft),
        ),
      ],
    );
  }
}

class _AmbientSupportCard extends StatelessWidget {
  const _AmbientSupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.hero / 2),
        gradient: const LinearGradient(
          colors: [AppColors.flareRed, AppColors.emberOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(30, 247, 5, 45),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Círculo seguro',
            style: AppTypography.caption.copyWith(
              color: AppColors.pureWhite.withOpacity(0.8),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Conversaciones guiadas cada noche con especialistas y pacientes referentes.',
            style: AppTypography.title.copyWith(color: AppColors.pureWhite),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.waves_rounded, color: AppColors.pureWhite.withOpacity(0.8)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Sintoniza hoy 20:00',
                style: AppTypography.bodySmall.copyWith(color: AppColors.pureWhite),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.pureWhite,
                  textStyle: AppTypography.button,
                ),
                child: const Text('Reservar cupo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FiltersSection extends StatelessWidget {
  const _FiltersSection();

  static const _filters = [
    'Diabetes tipo 2',
    'Hipertensión',
    'Bienestar mental',
    'Cuidadores',
    'Nuevos diagnósticos',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explora círculos activos',
          style: AppTypography.subtitle.copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _filters
              .map(
                (filter) => _CommunityFilterChip(
                  label: filter,
                  selected: filter == _filters.first,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _CommunityFilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CommunityFilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.surface : AppColors.surfaceHint,
        borderRadius: BorderRadius.circular(AppSpacing.hero),
        border: Border.all(
          color: selected ? AppColors.accentPrimary : AppColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 16,
            color: selected ? AppColors.accentPrimary : AppColors.inkSoft,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: selected ? AppColors.accentPrimary : AppColors.ink,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsSection extends StatelessWidget {
  const _GroupsSection();

  static const _groups = [
    CommunityGroup(
      name: 'Glucosa Serena',
      description: 'Chequeos diarios, recetas sencillas y alertas de hipoglucemia.',
      membersOnline: 28,
      totalMembers: 214,
      tone: 'Noches calmadas, hábitos sostenibles',
      icon: Icons.water_drop,
      accent: AppColors.accentSecondary,
    ),
    CommunityGroup(
      name: 'Ritmo Cardiaco',
      description: 'Personas con hipertensión comparten rutinas y recordatorios.',
      membersOnline: 14,
      totalMembers: 140,
      tone: 'Respira, registra y reconoce tus logros',
      icon: Icons.favorite,
      accent: AppColors.accentInfo,
    ),
    CommunityGroup(
      name: 'Nube Clara',
      description: 'Espacio mixto para salud mental y acompañamiento emocional.',
      membersOnline: 21,
      totalMembers: 310,
      tone: 'Moderado por psicólogos invitados cada semana',
      icon: Icons.self_improvement,
      accent: AppColors.statusSuccess,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chats destacados',
          style: AppTypography.subtitle.copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._groups
            .map(
              (group) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _GroupCard(
                  group: group,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CommunityChatPage(group: group),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  final CommunityGroup group;
  final VoidCallback onTap;

  const _GroupCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardInternalPadding),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardInternalPadding),
          border: Border.all(color: AppColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(12, 0, 0, 0),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: group.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Icon(group.icon, color: group.accent),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.name,
                              style: AppTypography.title.copyWith(color: AppColors.ink),
                            ),
                          ),
                          _Badge(label: '${group.membersOnline} en línea'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        group.description,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        group.tone,
                        style: AppTypography.caption.copyWith(color: AppColors.inkMuted),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(Icons.people_outline, size: 16, color: AppColors.inkSoft),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${group.totalMembers} miembros',
                            style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Spacer(),
                Icon(Icons.chevron_right, color: AppColors.inkMuted),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                  child: Text(
                    'Entrar',
                    style: AppTypography.button.copyWith(color: AppColors.surface),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentHighlight,
        borderRadius: BorderRadius.circular(AppSpacing.hero),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: AppColors.accentSecondary),
      ),
    );
  }
}

class _CirclesSection extends StatelessWidget {
  const _CirclesSection();

  static const _sessions = [
    _CircleSession(
      title: 'Microrutinas para la mañana',
      host: 'Paula, nutricionista Vivlo',
      dateLabel: 'Hoy · 20:00',
      participants: 64,
    ),
    _CircleSession(
      title: 'Cómo hablarle a tu médico con datos',
      host: 'Foro con comunidad + especialista',
      dateLabel: 'Jueves · 19:30',
      participants: 42,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Próximos círculos guiados',
                style: AppTypography.subtitle.copyWith(color: AppColors.ink),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Ver agenda completa'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ..._sessions
            .map(
              (session) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _CircleCard(session: session),
              ),
            )
            .toList(),
      ],
    );
  }
}

class _CircleCard extends StatelessWidget {
  final _CircleSession session;

  const _CircleCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        border: Border.all(color: AppColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 420;

          final avatar = Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentPrimary.withOpacity(0.1),
            ),
            child: const Icon(Icons.mic_none_rounded, color: AppColors.accentPrimary),
          );

          final details = Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: AppTypography.body.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  session.host,
                  style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.inkSoft),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      session.dateLabel,
                      style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.group_outlined, size: 14, color: AppColors.inkSoft),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${session.participants} inscritos',
                      style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
                    ),
                  ],
                ),
              ],
            ),
          );

          final joinButton = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentPrimary,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Unirme',
                style: AppTypography.button.copyWith(color: AppColors.surface),
              ),
            ),
          );

          final baseRowChildren = <Widget>[
            avatar,
            const SizedBox(width: AppSpacing.md),
            details,
          ];

          if (!isCompact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...baseRowChildren,
                const SizedBox(width: AppSpacing.sm),
                joinButton,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: baseRowChildren,
              ),
              const SizedBox(height: AppSpacing.md),
              Align(alignment: Alignment.centerRight, child: joinButton),
            ],
          );
        },
      ),
    );
  }
}

class _CircleSession {
  final String title;
  final String host;
  final String dateLabel;
  final int participants;

  const _CircleSession({
    required this.title,
    required this.host,
    required this.dateLabel,
    required this.participants,
  });
}
