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
}
