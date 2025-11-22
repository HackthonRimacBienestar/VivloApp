import 'package:auth0_flutter/auth0_flutter.dart';

class AuthService {
  static const _domain = 'dev-frhmw1hf574bwgn3.us.auth0.com';
  static const _clientId = '7YJKGBDMw240qXTnzRu1oBbMQZIo16Q4';

  final _auth0 = Auth0(_domain, _clientId);

  Credentials? _credentials;

  Credentials? get credentials => _credentials;

  Future<Credentials?> login() async {
    try {
      _credentials = await _auth0.webAuthentication().login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
      );
      return _credentials;
    } catch (e) {
      print('AuthService Login Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth0.webAuthentication().logout();
      _credentials = null;
    } catch (e) {
      print('AuthService Logout Error: $e');
      rethrow;
    }
  }
}
