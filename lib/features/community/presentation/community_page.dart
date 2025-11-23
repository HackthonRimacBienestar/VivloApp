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
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CommunityHeader(),
              const SizedBox(height: 28),
              const _AmbientSupportCard(),
              const SizedBox(height: 32),
              const _FiltersSection(),
              const SizedBox(height: 32),
              const _GroupsSection(),
              const SizedBox(height: 32),
              const _CirclesSection(),
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
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Comparte avances, dudas y pequeños triunfos con personas que entienden tu ritmo.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            color: AppColors.inkSoft,
            height: 1.5,
            letterSpacing: 0.1,
          ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE60023),
            Color(0xFFFF0000),
            Color(0xFFDC143C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE60023).withOpacity(0.4),
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFFFF0000).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              'Círculo seguro',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Conversaciones guiadas cada noche con especialistas y pacientes referentes.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.waves_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Sintoniza hoy 20:00',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        'Reservar cupo',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE60023),
                        ),
                      ),
                    ),
                  ),
                ),
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
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
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

class _CommunityFilterChip extends StatefulWidget {
  final String label;
  final bool selected;

  const _CommunityFilterChip({required this.label, this.selected = false});

  @override
  State<_CommunityFilterChip> createState() => _CommunityFilterChipState();
}

class _CommunityFilterChipState extends State<_CommunityFilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: widget.selected
                ? const LinearGradient(
                    colors: [Color(0xFFE60023), Color(0xFFFF0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ver agenda',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE60023),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ..._sessions
            .map(
              (session) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFFFBFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF385C), Color(0xFFFF5A5F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE60023).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      session.host,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.inkSoft),
                    const SizedBox(width: 4),
                    Text(
                      session.dateLabel,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 14,
                      color: AppColors.inkSoft,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${session.participants} inscritos',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF385C), Color(0xFFFF5A5F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE60023).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Unirme',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
