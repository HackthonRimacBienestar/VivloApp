import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/auth_service.dart';

class VoiceDataRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  Future<void> createConversation(String conversationId) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('conversations').upsert({
        'id': conversationId,
        'user_id': userId,
        'start_time': DateTime.now().toIso8601String(),
        'call_status': 'active',
        'ai_analysis_status': 'pending',
      });
    } catch (e) {
      print('Error creating conversation: $e');
    }
  }

  Future<void> addMessage({
    required String conversationId,
    required String role, // 'user' or 'agent'
    required String content,
  }) async {
    try {
      await _supabase.from('messages').insert({
        'conversation_id': conversationId,
        'role': role,
        'content': content,
        'timestamp_in_call': DateTime.now().millisecondsSinceEpoch
            .toDouble(), // Placeholder for relative time
      });
    } catch (e) {
      print('Error adding message: $e');
    }
  }

  Future<void> updateConversationStatus(
    String conversationId,
    String status,
  ) async {
    try {
      await _supabase
          .from('conversations')
          .update({'call_status': status})
          .eq('id', conversationId);
    } catch (e) {
      print('Error updating conversation status: $e');
    }
  }
}
