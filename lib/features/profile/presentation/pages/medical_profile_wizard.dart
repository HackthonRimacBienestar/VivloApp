import 'package:flutter/material.dart';
import 'package:follow_well/features/profile/data/profile_repository.dart';
import 'package:follow_well/features/profile/domain/profile.dart';
import 'package:intl/intl.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../../../core/ui/widgets/primary_button.dart';
import '../../../../core/services/auth_service.dart';

class MedicalProfileWizard extends StatefulWidget {
  final Profile? currentProfile;

  const MedicalProfileWizard({super.key, this.currentProfile});

  @override
  State<MedicalProfileWizard> createState() => _MedicalProfileWizardState();
}

class _MedicalProfileWizardState extends State<MedicalProfileWizard> {
  final PageController _pageController = PageController();
  final ProfileRepository _repository = ProfileRepository();
  final AuthService _authService = AuthService();

  int _currentPage = 0;
  String? _selectedDiabetesType;
  DateTime? _selectedDiagnosisDate;
  bool _isSaving = false;

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
    if (widget.currentProfile != null) {
      _selectedDiabetesType = widget.currentProfile!.diabetesType;
      _selectedDiagnosisDate = widget.currentProfile!.diagnosisDate;
    }
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _saveAndFinish();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveAndFinish() async {
    setState(() => _isSaving = true);
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final profile = Profile(
        id: user.id,
        fullName: widget.currentProfile?.fullName,
        avatarUrl: widget.currentProfile?.avatarUrl,
        pointsBalance: widget.currentProfile?.pointsBalance ?? 0,
        diabetesType: _selectedDiabetesType,
        diagnosisDate: _selectedDiagnosisDate,
      );

      await _repository.updateProfile(profile);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: _previousPage,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepIndicator(0),
            const SizedBox(width: 8),
            _buildStepIndicator(1),
          ],
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildDiabetesTypeStep(), _buildDiagnosisDateStep()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: PrimaryButton(
          text: _currentPage == 0 ? 'Siguiente' : 'Finalizar',
          onPressed: _canProceed() ? _nextPage : null,
          isLoading: _isSaving,
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_currentPage == 0) return _selectedDiabetesType != null;
    if (_currentPage == 1) return _selectedDiagnosisDate != null;
    return false;
  }

  Widget _buildStepIndicator(int stepIndex) {
    final isActive = stepIndex == _currentPage;
    final isCompleted = stepIndex < _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive || isCompleted
            ? AppColors.accentPrimary
            : AppColors.inkSoft.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildDiabetesTypeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué tipo de diabetes tienes?',
            style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Esta información nos ayuda a personalizar tus retos.',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: _diabetesTypes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final type = _diabetesTypes[index];
                final isSelected = _selectedDiabetesType == type;
                return _buildOptionCard(
                  title: type,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedDiabetesType = type),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisDateStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Cuándo fuiste diagnosticado?',
            style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Para calcular tu "Edad Diabética" y celebrar tus hitos.',
            style: AppTypography.body.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 48),
          Center(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDiagnosisDate ?? DateTime.now(),
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
                if (picked != null) {
                  setState(() => _selectedDiagnosisDate = picked);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedDiagnosisDate != null
                        ? AppColors.accentPrimary
                        : AppColors.inkSoft.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    if (_selectedDiagnosisDate != null)
                      BoxShadow(
                        color: AppColors.accentPrimary.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 48,
                      color: _selectedDiagnosisDate != null
                          ? AppColors.accentPrimary
                          : AppColors.inkSoft,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedDiagnosisDate != null
                          ? DateFormat(
                              'dd MMMM yyyy',
                              'es',
                            ).format(_selectedDiagnosisDate!)
                          : 'Seleccionar Fecha',
                      style: AppTypography.subtitle.copyWith(
                        color: _selectedDiagnosisDate != null
                            ? AppColors.ink
                            : AppColors.inkSoft,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentPrimary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentPrimary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: AppTypography.body.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.accentPrimary : AppColors.ink,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accentPrimary),
          ],
        ),
      ),
    );
  }
}
