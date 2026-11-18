/// Representasi error/eksepsi saat melakukan panggilan API HTTP
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message, {this.details});

  final int statusCode;
  final String message;
  final dynamic details;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;

  @override
  String toString() => 'ApiException(status: $statusCode, message: $message)';
}
