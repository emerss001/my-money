import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_login.dart';
import 'package:my_money/components/ui/nav_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            onLoginPressed: () {
              // Lógica de autenticação vai aqui
              print("Botão de login clicado!");
            },
          ),

          const Spacer(),
          const AuthActionButton(
            label: "Ainda não tem uma conta?",
            buttonLabel: "Cadastre-se",
          ),
        ],
      ),
    );
  }
}
