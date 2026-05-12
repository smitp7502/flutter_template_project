import 'package:dio/dio.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      '${options.method} ${options.path}',
      tag: 'API',
      json: {
        'headers': options.headers,
        'query': options.queryParameters,
        'body': options.data,
      },
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.success(
      '${response.requestOptions.method} ${response.requestOptions.path}',
      tag: 'API',
      json: response.data,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '${err.requestOptions.method} ${err.requestOptions.path}',
      tag: 'API',
      json: {'message': err.message, 'response': err.response?.data},
    );

    handler.next(err);
  }
}
