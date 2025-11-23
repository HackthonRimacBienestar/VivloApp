import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/services/auth_service.dart';
import '../data/profile_repository.dart';
import '../domain/profile.dart';
import 'pages/medical_profile_wizard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _repository = ProfileRepository();
  final _authService = AuthService();

  bool _isLoading = true;
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _repository.getMyProfile();

    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  void _openMedicalWizard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalProfileWizard(currentProfile: _profile),
      ),
    );

    if (result == true) {
      _loadProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil médico actualizado')),
      );
    }
  }

  String _calculateTimeSinceDiagnosis() {
    if (_profile?.diagnosisDate == null) return '---';
    final days = DateTime.now().difference(_profile!.diagnosisDate!).inDays;
    final years = (days / 365).floor();
    if (years > 0) return '$years años';
    return '$days días';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildStatsRow(),
                        const SizedBox(height: 24),
                        _buildMedicalCard(),
                        if (_profile?.clinicalSummary != null) ...[
                          const SizedBox(height: 24),
                          _buildClinicalSummaryCard(),
                        ],
                        const SizedBox(height: 24),
                        _buildAccountActions(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentPrimary.withOpacity(0.1),
                AppColors.surface,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildAvatar(),
              const SizedBox(height: 16),
              Text(
                _profile?.fullName ?? 'Usuario',
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              _buildPointsBadge(),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: AppColors.ink),
          onPressed: () {
            // TODO: Navigate to settings
          },
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: AppColors.surfaceHint,
        backgroundImage: _profile?.avatarUrl != null
            ? NetworkImage(_profile!.avatarUrl!)
            : null,
        child: _profile?.avatarUrl == null
            ? const Icon(Icons.person, size: 40, color: AppColors.inkSoft)
            : null,
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.emberOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppColors.emberOrange,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${_profile?.pointsBalance ?? 0} Puntos',
            style: AppTypography.caption.copyWith(
              color: AppColors.emberOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Diagnóstico',
            _calculateTimeSinceDiagnosis(),
            Icons.history_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Racha',
            '5 días', // Placeholder
            Icons.local_fire_department_rounded,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.inkSoft),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                'Perfil Médico',
                style: AppTypography.subtitle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: _openMedicalWizard,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMedicalInfoRow(
            'Tipo de Diabetes',
            _profile?.diabetesType ?? 'No especificado',
            Icons.medical_services_outlined,
          ),
          const SizedBox(height: 12),
          _buildMedicalInfoRow(
            'Fecha Diagnóstico',
            _profile?.diagnosisDate != null
                ? DateFormat('dd/MM/yyyy').format(_profile!.diagnosisDate!)
                : 'No especificado',
            Icons.calendar_today_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: AppTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClinicalSummaryCard() {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: AppColors.accentPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Resumen Clínico (IA)',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _profile!.clinicalSummary!,
            style: AppTypography.body.copyWith(
              color: AppColors.ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceHint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_outline, color: AppColors.ink),
          ),
          title: const Text('Editar Datos Personales'),
          trailing: const Icon(Icons.chevron_right, color: AppColors.inkSoft),
          onTap: () {
            // TODO: Edit personal info
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.flareRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.logout_rounded, color: AppColors.flareRed),
          ),
          title: Text(
            'Cerrar Sesión',
            style: AppTypography.body.copyWith(color: AppColors.flareRed),
          ),
          onTap: () async {
            await _authService.logout();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }
}
