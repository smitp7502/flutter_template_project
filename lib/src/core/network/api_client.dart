import 'package:dio/dio.dart';
import 'package:flutter_template/src/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_template/src/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_template/src/core/network/interceptors/logger_interceptor.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://dummyapi.com/api',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          AuthInterceptor(),
          LoggerInterceptor(),
          ErrorInterceptor(),
        ]);
}
