Future<T> retry<T>({
  required Future<T> Function() request,
  int retries = 3,
}) async {
  int attempt = 0;

  while (attempt < retries) {
    try {
      return await request();
    } catch (_) {
      attempt++;

      if (attempt >= retries) rethrow;
    }
  }

  throw Exception();
}
