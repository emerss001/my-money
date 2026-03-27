import 'dart:io';

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
        "imagemUrl": user["imageUrl"],
      };

      return perfilUsuario;
    } on DioException catch (e) {
      print('Erro ao obter perfil do usuário: ${e.message}');
      throw "Falha ao obter perfil do usuário. Tente novamente mais tarde.";
    }
  }

  // função para atualizar imagem do perfil do usuário
  Future<void> atualizarImagemPerfil(File novaImagem) async {
    try {
      String fileName = novaImagem.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          novaImagem.path,
          filename: fileName,
        ),
      });

      await _dio.post("/users/upload-profile-image", data: formData);
    } on DioException catch (e) {
      print('Erro ao atualizar imagem do perfil: ${e.message}');
      throw "Falha ao atualizar imagem do perfil. Tente novamente mais tarde.";
    }
  }

  // função para buscar a imagem de perfil do usuário
  Future<String> obterImagemPerfil() async {
    try {
      final response = await _dio.get("/users/profile-image");
      return response.data["imageUrl"] ?? "";
    } on DioException catch (e) {
      print('Erro ao obter imagem do perfil: ${e.message}');
      throw "Falha ao obter imagem do perfil. Tente novamente mais tarde.";
    }
  }
}
