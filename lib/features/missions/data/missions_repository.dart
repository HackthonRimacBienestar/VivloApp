import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/auth_service.dart';
import '../domain/health_challenge.dart';

class MissionsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  Future<List<HealthChallenge>> getMyChallenges() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('health_challenges')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => HealthChallenge.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching challenges: $e');
      return [];
    }
  }

  Future<void> completeChallenge(String challengeId) async {
    try {
      await _supabase
          .from('health_challenges')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', challengeId);
    } catch (e) {
      print('Error completing challenge: $e');
      rethrow;
    }
  }
}
