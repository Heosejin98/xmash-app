import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:xmash_app/config/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.instance;
  final CookieJar _cookieJar = DioClient.cookieJar;

  AuthService() {
    if (!kIsWeb) {
      // 모바일 앱일 경우에만 쿠키 매니저 초기화
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }

  Future<Response> login(String userId, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'userId': userId,
          'password': password,
        },
        options: Options(
          // 웹일 경우 withCredentials 설정
          extra: kIsWeb ? {'withCredentials': true} : null,
        ),
      );

      // 모바일 앱일 경우 쿠키 저장 처리
      if (!kIsWeb && response.headers.map['set-cookie'] != null) {
        final cookies = response.headers.map['set-cookie']!;
        final uri = Uri.parse('/login');
        await _cookieJar.saveFromResponse(
          uri,
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }
}