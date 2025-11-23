import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/ui/widgets/primary_button.dart';
import '../../../../core/services/auth_service.dart';
import '../data/profile_repository.dart';
import '../domain/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _repository = ProfileRepository();
  final _authService = AuthService();

  bool _isLoading = true;
  bool _isSaving = false;

  final _nameController = TextEditingController();
  String? _diabetesType;
  DateTime? _diagnosisDate;
  int _points = 0;
  String? _avatarUrl;

  final List<String> _diabetesTypes = [
    'Type 1',
    'Type 2',
    'Gestational',
    'Pre-diabetes',
    'LADA',
    'MODY',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _repository.getMyProfile();

    if (mounted) {
      if (profile != null) {
        _nameController.text = profile.fullName ?? '';
        _diabetesType = profile.diabetesType;
        _diagnosisDate = profile.diagnosisDate;
        _points = profile.pointsBalance;
        _avatarUrl = profile.avatarUrl;
      } else {
        // Fallback to Auth metadata if profile doesn't exist yet
        final user = _authService.currentUser;
        _nameController.text = user?.userMetadata?['full_name'] ?? '';
        _avatarUrl = user?.userMetadata?['avatar_url'] as String?;
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final profile = Profile(
        id: user.id,
        fullName: _nameController.text,
        diabetesType: _diabetesType,
        diagnosisDate: _diagnosisDate,
        // Preserve existing values
        avatarUrl: _avatarUrl,
        pointsBalance: _points,
      );

      await _repository.updateProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _diagnosisDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accentPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _diagnosisDate) {
      setState(() {
        _diagnosisDate = picked;
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
          'Mi Perfil',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.flareRed),
            onPressed: () async {
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    _buildPointsBadge(),
                    const SizedBox(height: 32),
                    _buildTextField(
                      label: 'Nombre completo',
                      controller: _nameController,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown(),
                    const SizedBox(height: 24),
                    _buildDatePicker(),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: 'Guardar Cambios',
                      onPressed: _saveProfile,
                      isLoading: _isSaving,
                    ),
                  ],
                ),
              ),
            ),
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
        radius: 50,
        backgroundColor: AppColors.surfaceHint,
        backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
        child: _avatarUrl == null
            ? const Icon(Icons.person, size: 50, color: AppColors.inkSoft)
            : null,
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$_points Puntos',
            style: AppTypography.body.copyWith(
              color: AppColors.emberOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.inkSoft),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inkSoft.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inkSoft.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentPrimary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Diabetes',
          style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _diabetesType,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.inkSoft,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inkSoft.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inkSoft.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentPrimary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _diabetesTypes.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) => setState(() => _diabetesType = value),
          hint: const Text('Selecciona tu tipo'),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Diagnóstico',
          style: AppTypography.bodySmall.copyWith(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.inkSoft.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.inkSoft,
                ),
                const SizedBox(width: 12),
                Text(
                  _diagnosisDate != null
                      ? DateFormat('dd/MM/yyyy').format(_diagnosisDate!)
                      : 'Seleccionar fecha',
                  style: AppTypography.body.copyWith(
                    color: _diagnosisDate != null
                        ? AppColors.ink
                        : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
