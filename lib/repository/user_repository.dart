import 'package:dio/dio.dart';
import 'package:my_money/http/api_client.dart';

class UserRepository {
  final Dio _dio = ApiClient().dio;

  // função pata buscar os dados do perfil do usuário
  Future<Map<String, dynamic>> obterPerfilUsuario() async {
    try {
      final response = await _dio.get("/users/me");

      var user = response.data["user"];

      Map<String, dynamic> perfilUsuario = {
        "nome": user["name"],
        "email": user["email"],
        "criadoEm": user["createdAt"],
        "imagemUrl": user["profileImageUrl"],
      };

      return perfilUsuario;
    } on DioException catch (e) {
      print('Erro ao obter perfil do usuário: ${e.message}');
      throw "Falha ao obter perfil do usuário. Tente novamente mais tarde.";
    }
  }
}
