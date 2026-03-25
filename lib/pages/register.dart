import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_register.dart';
import 'package:my_money/components/nav_auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161618), // Fundo principal da tela
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: NavBarAuth(),
      ),
      body: Column(
        children: [
          RegisterForm(
            onRegisterPressed: () {
              // Lógica de registro vai aqui
              print("Botão Cadastrar clicado!");
            },
          ),

          const Spacer(),

          const AuthActionButton(
            label: "já tem uma conta?",
            buttonLabel: "Acessar",
          ),
        ],
      ),
    );
  }
}
