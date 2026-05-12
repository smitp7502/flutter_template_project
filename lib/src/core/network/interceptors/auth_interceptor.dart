import 'package:dio/dio.dart';
import 'package:flutter_template/src/core/constants/storage_key.dart';
import 'package:flutter_template/src/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await StorageService().readString(StorageKey.accessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
