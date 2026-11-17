import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_exceptions.dart';
import 'auth_interceptor.dart';

/// Cliente HTTP centralizado basado en Dio para comunicarse con el Backend de Azure.
class ApiClient {
  late final Dio _dio;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout:
            const Duration(seconds: ApiConfig.connectTimeoutSeconds),
        receiveTimeout:
            const Duration(seconds: ApiConfig.receiveTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(AuthInterceptor());
  }

  /// Realiza peticiones GET procesando errores.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path,
          queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Realiza peticiones POST procesando errores.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Realiza peticiones PUT procesando errores.
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(path,
          data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Realiza peticiones DELETE procesando errores.
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(path,
          data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Mapea excepciones de Dio a excepciones de dominio limpias de BusTrack.
  ApiException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException(
        message:
            'No se pudo conectar con el servidor de BusTrack. Revisa tu conexión a internet.',
      );
    }

    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    const defaultErrorMessage =
        'Ha ocurrido un error inesperado en la comunicación con el servidor.';
    String message = defaultErrorMessage;

    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('mensaje')) {
        message = responseData['mensaje'].toString();
      } else if (responseData.containsKey('message')) {
        message = responseData['message'].toString();
      } else if (responseData.containsKey('title')) {
        message = responseData['title'].toString();
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message, data: responseData);
      case 401:
        return UnauthorizedException(
          message: message == defaultErrorMessage
              ? 'Credenciales incorrectas o sesión expirada.'
              : message,
          data: responseData,
        );
      case 403:
        return ForbiddenException(
          message: 'No tienes permiso para realizar esta acción.',
          data: responseData,
        );
      case 404:
        return NotFoundException(
          message: 'El recurso solicitado no fue encontrado en el servidor.',
          data: responseData,
        );
      case 409:
        return ConflictException(message: message, data: responseData);
      case 429:
        return RateLimitException(
          message:
              'Demasiadas solicitudes. Por favor, intentalo de nuevo en unos momentos.',
          data: responseData,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message:
              'El servidor de BusTrack en Azure está experimentando problemas temporales.',
          data: responseData,
        );
      default:
        return ApiException(
            message: message, statusCode: statusCode, data: responseData);
    }
  }
}
