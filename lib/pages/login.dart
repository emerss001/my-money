import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_login.dart';
import 'package:my_money/components/ui/nav_auth.dart';
import 'package:my_money/controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF1E1E1E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: NavBarAuth(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 48),
          LoginForm(
            onLoginPressed: (email, password) async {
              final emailInput = email.trim();
              final senhaInput = password.trim();

              await _authController.fazerLoginEmailSenha(
                context,
                emailInput,
                senhaInput,
              );
            },
          ),

          const Spacer(),
          const AuthActionButton(
            label: "Ainda não tem uma conta?",
            buttonLabel: "Cadastre-se",
            routeName: "/register",
          ),
        ],
      ),
    );
  }
}
