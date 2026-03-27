import 'package:flutter/material.dart';
import 'package:my_money/auth/token_service.dart';

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

    await Future.delayed(const Duration(microseconds: 500));

    if (mounted) {
      if (token != null) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
