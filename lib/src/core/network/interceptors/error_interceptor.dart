import 'package:dio/dio.dart';
import 'package:flutter_template/src/core/exceptions/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(
            message: 'Please check your internet connection',
            statusCode: err.response?.statusCode,
            error: err,
            stackTrace: err.stackTrace,
          ),
        ),
      );
    }

    if (err.response != null) {
      final data = err.response?.data;

      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ApiException(
            message: data?['message'] ?? 'Something went wrong',
            statusCode: err.response?.statusCode,
            error: err,
            stackTrace: err.stackTrace,
          ),
        ),
      );
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: UnknownException(
          message: 'Unexpected error occurred',
          error: err,
          stackTrace: err.stackTrace,
        ),
      ),
    );
  }
}
