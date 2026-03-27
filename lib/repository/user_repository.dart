import 'package:dio/dio.dart';
import 'package:my_money/http/api_client.dart';

class UserRepository {
  final Dio _dio = ApiClient().dio;
}
