import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_login.dart';
import 'package:my_money/components/nav_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: NavBarAuth(),
      ),
      body: Column(
        children: [
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
