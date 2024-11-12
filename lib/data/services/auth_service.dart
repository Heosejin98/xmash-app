import 'package:dio/dio.dart';
import 'package:xmash_app/data/core/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<Response> login(String userId, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'userId': userId,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      // DioError 처리
      return e.response!;
    }
  }
}