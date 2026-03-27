import 'package:dio/dio.dart';
import 'package:my_money/http/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient().dio;

  // função de registro
  Future<String?> realizarRegistroEmailSenha(
    String name,
    String email,
    String senha,
  ) async {
    try {
      final response = await _dio.post(
        "/auth/register",
        data: {"name": name, "email": email, "password": senha},
      );

      final String token = response.data["token"];

      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw "Dados inválidos. Por favor, verifique as informações fornecidas.";
      } else if (e.response?.statusCode == 409) {
        throw "Email já registrado. Por favor, use outro email ou faça login.";
      } else {
        print('Erro no servidor: ${e.message}');
        throw "Falha ao realizar registro. Erro no servidor. Tente novamente mais tarde.";
      }
    }
  }

  // função de login
  Future<String?> realizarLoginEmailSenha(String email, String senha) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"email": email, "password": senha},
      );

      final String token = response.data["token"];

      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw "Credenciais inválidas. Por favor, verifique seu email e senha.";
      } else {
        print('Erro no servidor: ${e.message}');
        throw "Falha ao fazer login. Erro no servidor. Tente novamente mais tarde.";
      }
    }
  }
}
