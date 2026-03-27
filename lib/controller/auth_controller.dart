import 'package:flutter/material.dart';
import 'package:my_money/auth/token_service.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'package:my_money/repository/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();
  final TokenService _tokenService = TokenService();

  Future<void> realizarRegistroEmailSenha(
    BuildContext context,
    String nameInput,
    String emailInput,
    String passwordInput,
    String confirmPasswordInput,
  ) async {
    try {
      if (passwordInput != confirmPasswordInput) {
        throw Exception("As senhas não coincidem.");
      }

      final tokenAPI = await _authRepository.realizarRegistroEmailSenha(
        nameInput,
        emailInput,
        passwordInput,
      );

      if (tokenAPI != null) {
        await _tokenService.salvarToken(tokenAPI);

        if (context.mounted) {
          CustomSnackBar.show(
            context: context,
            message: "Registro realizado com sucesso!",
          );
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: e.toString(),
          isError: true,
        );
      }
    }
  }

  Future<void> fazerLoginEmailSenha(
    BuildContext context,
    String emailInput,
    String senhaInput,
  ) async {
    try {
      final tokenAPI = await _authRepository.realizarLoginEmailSenha(
        emailInput,
        senhaInput,
      );

      if (tokenAPI != null) {
        await _tokenService.salvarToken(tokenAPI);

        if (context.mounted) {
          CustomSnackBar.show(
            context: context,
            message: "Login realizado com sucesso!",
          );
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: e.toString(),
          isError: true,
        );
      }
    }
  }
}
