import 'dart:async';

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_storage_service.dart';
import 'session_events.dart';

/// Interceptor de Dio para inyectar automáticamente el Bearer token JWT
/// y renovar la sesión de forma transparente si la respuesta da 401 Unauthorized.
///
/// La renovación está protegida por un [Completer] compartido: múltiples
/// respuestas 401 concurrentes disparan un único `POST /auth/refresh`.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();

  Completer<bool>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Si la ruta no es de auth pública, adjuntar token JWT
    if (!_isPublicAuthEndpoint(options.path)) {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        !_isPublicAuthEndpoint(err.requestOptions.path)) {
      // Intentar renovar token usando refresh token (una sola vez en paralelo)
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Reintentar la solicitud original con el nuevo token
        try {
          final newAccessToken = await _storage.getAccessToken();
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final dio = Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout:
                  const Duration(seconds: ApiConfig.connectTimeoutSeconds),
              receiveTimeout:
                  const Duration(seconds: ApiConfig.receiveTimeoutSeconds),
            ),
          );
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (_) {
          // Si falla el reintento, continuar con el error original.
        }
      } else {
        // No se pudo renovar: limpiar la sesión local y avisar a la UI.
        await _storage.clearSession();
        SessionEvents.notifySessionExpired();
      }
    }
    return handler.next(err);
  }

  bool _isPublicAuthEndpoint(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    const publicEndpoints = [
      ApiConfig.login,
      ApiConfig.registro,
      ApiConfig.refresh,
      ApiConfig.recuperarPassword,
      ApiConfig.restablecerPassword,
      ApiConfig.health,
    ];
    return publicEndpoints.contains(normalized);
  }

  Future<bool> _refreshToken() {
    // Si ya hay un refresh en curso, esperar su resultado en lugar de
    // disparar peticiones duplicadas al endpoint de renovación.
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<bool>();
    _refreshCompleter = completer;
    _doRefreshToken()
        .then(completer.complete)
        .catchError((_) => completer.complete(false))
        .whenComplete(() => _refreshCompleter = null);
    return completer.future;
  }

  Future<bool> _doRefreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
      ));

      final response = await dio.post(
        ApiConfig.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final newAccess = data is Map ? data['accessToken']?.toString() : null;
        final newRefresh =
            data is Map ? data['refreshToken']?.toString() : null;
        if (newAccess != null && newAccess.isNotEmpty) {
          await _storage.saveTokens(
            accessToken: newAccess,
            // Si el backend no rota el refresh token, conservar el actual.
            refreshToken: newRefresh != null && newRefresh.isNotEmpty
                ? newRefresh
                : refreshToken,
          );
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
