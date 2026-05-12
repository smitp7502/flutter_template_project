class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return message;
  }
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiException extends AppException {
  ApiException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class UnknownException extends AppException {
  UnknownException({required super.message, super.error, super.stackTrace});
}
