import 'package:flutter/material.dart';
import 'package:follow_well/core/services/auth_service.dart';
import 'package:follow_well/shared/constants/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await _auth.login();
      setState(() {});
      // Navegar al agente después del login exitoso
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.voiceAgent);
      }
    } catch (e) {
      debugPrint('Error login: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      await _auth.register();
      setState(() {});
      // Navegar al agente después del registro exitoso
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.voiceAgent);
      }
    } catch (e) {
      debugPrint('Error registro: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al registrarse: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.credentials?.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 + Flutter')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _auth.credentials == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Registrarse'),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user?.pictureUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.pictureUrl.toString(),
                      ),
                      radius: 40,
                    ),
                  const SizedBox(height: 16),
                  Text('Hola, ${user?.name ?? user?.nickname ?? 'usuario'}'),
                  const SizedBox(height: 8),
                  Text(user?.email ?? ''),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        await _auth.logout();
                        setState(() {});
                      } catch (e) {
                        debugPrint('Error logout: $e');
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: const Text('Cerrar sesión'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.voiceAgent);
                    },
                    child: const Text('Ir al Asistente de Voz'),
                  ),
                ],
              ),
      ),
    );
  }
}
