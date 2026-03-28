import 'package:flutter/material.dart';
import 'package:my_money/auth/token_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();

    _verificarTokenAutenticacao();
  }

  Future<void> _verificarTokenAutenticacao() async {
    final tokenService = TokenService();
    final String? token = await tokenService.recuperarToken();

    if (mounted) {
      if (token != null) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }

      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      body: Center(
        child: Image.asset(
          'lib/assets/images/icone.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
