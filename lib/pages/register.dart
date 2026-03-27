import 'package:flutter/material.dart';
import 'package:my_money/components/auth_action_button.dart';
import 'package:my_money/components/form_register.dart';
import 'package:my_money/components/ui/nav_auth.dart';
import 'package:my_money/controller/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF161618), // Fundo principal da tela
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: NavBarAuth(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 6),
          RegisterForm(
            onRegisterPressed: (name, email, password, confirmPassword) async {
              final nameInput = name.trim();
              final emailInput = email.trim();
              final passwordInput = password.trim();
              final confirmPasswordInput = confirmPassword.trim();

              await _authController.realizarRegistroEmailSenha(
                context,
                nameInput,
                emailInput,
                passwordInput,
                confirmPasswordInput,
              );
            },
          ),

          const Spacer(),

          const AuthActionButton(
            label: "já tem uma conta?",
            buttonLabel: "Acessar",
            routeName: "/login",
          ),
        ],
      ),
    );
  }
}
