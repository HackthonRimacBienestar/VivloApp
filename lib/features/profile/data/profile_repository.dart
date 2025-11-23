import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/auth_service.dart';
import '../domain/profile.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  Future<Profile?> getMyProfile() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return Profile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Stream<Profile?> streamMyProfile() {
    final userId = _authService.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) => data.isEmpty ? null : Profile.fromJson(data.first));
  }

  Future<void> updateProfile(Profile profile) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase
          .from('profiles')
          .update({
            'full_name': profile.fullName,
            'diabetes_type': profile.diabetesType,
            'diagnosis_date': profile.diagnosisDate?.toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}
