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

  Future<List<HealthChallenge>> getCompletedChallenges() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('health_challenges')
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('completed_at', ascending: false);

      return (response as List)
          .map((json) => HealthChallenge.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching completed challenges: $e');
      return [];
    }
  }

  Future<void> completeChallenge(String challengeId) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      // 1. Get challenge details to know points
      final challengeResponse = await _supabase
          .from('health_challenges')
          .select()
          .eq('id', challengeId)
          .single();

      final challenge = HealthChallenge.fromJson(challengeResponse);

      // Prevent double counting if already completed
      if (challenge.status == ChallengeStatus.completed) return;

      // 2. Update challenge status
      await _supabase
          .from('health_challenges')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', challengeId);

      // 3. Update user points
      final profileResponse = await _supabase
          .from('profiles')
          .select('points_balance')
          .eq('id', userId)
          .single();

      final currentPoints = profileResponse['points_balance'] as int? ?? 0;
      final newPoints = currentPoints + challenge.pointsReward;

      await _supabase
          .from('profiles')
          .update({'points_balance': newPoints})
          .eq('id', userId);
    } catch (e) {
      print('Error completing challenge: $e');
      rethrow;
    }
  }

  Future<Map<ChallengeCategory, int>> getChallengeCounts() async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return {};

    try {
      final response = await _supabase
          .from('health_challenges')
          .select('category, status')
          .eq('user_id', userId)
          .eq('status', 'completed');

      final counts = <ChallengeCategory, int>{};
      for (final item in response as List) {
        final categoryStr = item['category'] as String;
        final category = _parseCategory(categoryStr);
        counts[category] = (counts[category] ?? 0) + 1;
      }
      return counts;
    } catch (e) {
      print('Error fetching challenge counts: $e');
      return {};
    }
  }

  ChallengeCategory _parseCategory(String category) {
    return ChallengeCategory.values.firstWhere(
      (e) => e.toString().split('.').last == category,
      orElse: () => ChallengeCategory.mental_wellbeing,
    );
  }
}
