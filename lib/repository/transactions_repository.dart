import 'package:dio/dio.dart';
import 'package:my_money/http/api_client.dart';

class TransactionsRepository {
  final Dio _dio = ApiClient().dio;

  // função para buscar métricas globais
  Future<Map<String, dynamic>> obterMetricasGlobais() async {
    try {
      final response = await _dio.get("/metrics");

      var metricas = response.data;

      return metricas;
    } on DioException catch (e) {
      print('Erro ao obter métricas globais: ${e.message}');
      throw "Falha ao obter métricas globais. Tente novamente mais tarde.";
    }
  }

  // função para buscar categorias
  Future<List<dynamic>> obterCategorias() async {
    try {
      final response = await _dio.get("/transactions/categories");

      var categorias = response.data;
      return categorias;
    } on DioException catch (e) {
      print('Erro ao obter categorias: ${e.message}');
      throw "Falha ao obter categorias. Tente novamente mais tarde.";
    }
  }

  // função para buscar transações
  Future<List<dynamic>> obterTransacoes() async {
    try {
      final response = await _dio.get("/transactions");
      return response.data;
    } on DioException catch (e) {
      print('Erro ao obter transações: ${e.message}');
      throw "Falha ao obter transações. Tente novamente mais tarde.";
    }
  }
}
