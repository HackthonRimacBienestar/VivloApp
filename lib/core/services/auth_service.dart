import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // TODO: Replace with your actual Web Client ID from Google Cloud Console
  // This is required for the idToken to be valid for Supabase
  static const String _webClientId =
      '893398700652-04u75ec9msvodsqvl60qo9nl9ua055th.apps.googleusercontent.com';

  // Google Sign In configuration
  // serverClientId is crucial for getting the idToken
  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: _webClientId);

  User? get currentUser => _supabase.auth.currentUser;

  // Returns the current session if any
  Session? get currentSession => _supabase.auth.currentSession;

  Future<AuthResponse> loginWithGoogle() async {
    try {
      // 1. Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign In aborted by user';
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      // 4. Sign in to Supabase with the tokens
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print('AuthService Login Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await _supabase.auth.signOut(); // Sign out from Supabase
    } catch (e) {
      print('AuthService Logout Error: $e');
      rethrow;
    }
  }

  // Helper to get user info
  User? getUser() {
    return _supabase.auth.currentUser;
  }
}
