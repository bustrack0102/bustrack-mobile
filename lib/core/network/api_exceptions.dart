/// Excepciones personalizadas para el manejo estructurado de errores HTTP en la app BusTrack.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException({required super.message, super.data})
      : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.message, super.data})
      : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException({required super.message, super.data})
      : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException({required super.message, super.data})
      : super(statusCode: 404);
}

class ConflictException extends ApiException {
  ConflictException({required super.message, super.data})
      : super(statusCode: 409);
}

class RateLimitException extends ApiException {
  RateLimitException({required super.message, super.data})
      : super(statusCode: 429);
}

class ServerException extends ApiException {
  ServerException({required super.message, super.data})
      : super(statusCode: 500);
}

class NetworkException extends ApiException {
  NetworkException({required super.message}) : super(statusCode: 0);
}
