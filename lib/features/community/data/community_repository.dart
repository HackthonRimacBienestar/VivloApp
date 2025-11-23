import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/auth_service.dart';
import '../domain/community_group.dart';
import '../domain/community_message.dart';

class CommunityRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  // Fetch all community groups
  Future<List<CommunityGroup>> getGroups() async {
    try {
      final response = await _supabase
          .from('community_groups')
          .select()
          .order('created_at');

      return (response as List)
          .map((json) => CommunityGroup.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching groups: $e');
      return [];
    }
  }

  // Fetch initial messages for a group
  Future<List<CommunityMessage>> getMessages(String groupId) async {
    try {
      final response = await _supabase
          .from('community_messages')
          .select('*, profiles(full_name)')
          .eq('group_id', groupId)
          .order('created_at', ascending: false)
          .limit(50);

      return (response as List)
          .map((json) => CommunityMessage.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  // Send a message
  Future<void> sendMessage(String groupId, String content) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('community_messages').insert({
        'group_id': groupId,
        'user_id': userId,
        'content': content,
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Subscribe to new messages in a group
  Stream<List<CommunityMessage>> subscribeToMessages(String groupId) async* {
    await for (final maps
        in _supabase
            .from('community_messages')
            .stream(primaryKey: ['id'])
            .eq('group_id', groupId)
            .order('created_at', ascending: true)) {
      // Fetch profiles for each message to show names
      final messagesWithProfiles = <CommunityMessage>[];

      for (final map in maps) {
        final userId = map['user_id'] as String;

        // Fetch the profile for this user
        final profileResponse = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', userId)
            .maybeSingle();

        final fullName = profileResponse?['full_name'] as String?;

        // Add profile name to the message map
        final messageWithProfile = Map<String, dynamic>.from(map);
        if (fullName != null) {
          messageWithProfile['profiles'] = {'full_name': fullName};
        }

        messagesWithProfiles.add(CommunityMessage.fromJson(messageWithProfile));
      }

      yield messagesWithProfiles;
    }
  }

  // Join a group (if not already a member)
  Future<void> joinGroup(String groupId) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('community_members').upsert({
        'group_id': groupId,
        'user_id': userId,
      }, onConflict: 'group_id, user_id');
    } catch (e) {
      print('Error joining group: $e');
    }
  }
}
