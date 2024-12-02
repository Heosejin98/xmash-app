import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio? _dio;
  static CookieJar cookieJar = CookieJar();

  static Dio get instance {
    _dio ??= Dio(BaseOptions(
      baseUrl: 'http://xmash.shop:4243',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Origin': 'http://xmash.shop:8080',
      },
      // 웹일 경우 withCredentials 전역 설정
      extra: kIsWeb ? {'withCredentials': true} : null,

    ))..interceptors.addAll([
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      ]);

    return _dio!;
  }
}