import 'package:auth0_flutter/auth0_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const _domain = 'dev-w7xybxca7a6ecknz.us.auth0.com';
  static const _clientId = 'lWdqoyUXATcALJ6Di8VutUuapfAIdgRp';

  final _auth0 = Auth0(_domain, _clientId);

  Credentials? _credentials;

  Credentials? get credentials => _credentials;

  Future<Credentials?> login() async {
    try {
      _credentials = await _auth0
          .webAuthentication(scheme: 'followwell')
          .login(scopes: {'openid', 'profile', 'email', 'offline_access'});
      return _credentials;
    } catch (e) {
      print('AuthService Login Error: $e');
      rethrow;
    }
  }

  Future<Credentials?> register() async {
    try {
      _credentials = await _auth0
          .webAuthentication(scheme: 'followwell')
          .login(
            scopes: {'openid', 'profile', 'email', 'offline_access'},
            parameters: {'screen_hint': 'signup'},
          );
      return _credentials;
    } catch (e) {
      print('AuthService Register Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth0.webAuthentication(scheme: 'followwell').logout();
      _credentials = null;
    } catch (e) {
      print('AuthService Logout Error: $e');
      rethrow;
    }
  }

  // Helper to get user info if needed, though credentials.user is usually enough
  Future<UserProfile?> getUser() async {
    return _credentials?.user;
  }
}
