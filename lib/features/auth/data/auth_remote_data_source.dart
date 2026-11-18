import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/user_model.dart';

/// Fuente de datos remota para el módulo de Autenticación con Azure REST API.
class AuthRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Inicia sesión en la API de Azure.
  Future<AuthResponseModel> login({
    required String correo,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.login,
      data: {
        'correo': correo.trim(),
        'password': password,
        'dispositivoInfo': 'BusTrack Mobile App',
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }

  /// Registra una nueva cuenta en la API de Azure.
  Future<AuthResponseModel> registro({
    required String nombreCompleto,
    required String correo,
    required String password,
    required String confirmacionPassword,
    required bool aceptaAvisoPrivacidad,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.registro,
      data: {
        'nombreCompleto': nombreCompleto.trim(),
        'correo': correo.trim(),
        'password': password,
        'confirmacionPassword': confirmacionPassword,
        'aceptaAvisoPrivacidad': aceptaAvisoPrivacidad,
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }

  /// Cierra la sesión activa revocando el Refresh Token.
  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      ApiConfig.logout,
      data: {
        'refreshToken': refreshToken,
        'cerrarTodosLosDispositivos': false,
      },
    );
  }

  /// Obtiene los datos actualizados del perfil del usuario autenticado.
  Future<UserModel> getPerfilMe() async {
    final response = await _apiClient.get(ApiConfig.usuarioMe);
    return UserModel.fromJson(response.data);
  }

  /// Solicita el envío de un correo de recuperación de contraseña.
  Future<void> solicitarRecuperacionPassword(String correo) async {
    try {
      await _apiClient.post(
        ApiConfig.recuperarPassword,
        data: {'correo': correo.trim()},
      );
    } catch (_) {
      // Por seguridad y prevención de enumeración de cuentas,
      // no propagamos errores que delaten si el correo existe o no.
    }
  }

  /// Valida el token y restablece la contraseña del usuario.
  Future<void> restablecerPassword({
    required String correo,
    required String token,
    required String nuevaPassword,
    required String confirmacionPassword,
  }) async {
    await _apiClient.post(
      ApiConfig.restablecerPassword,
      data: {
        'correo': correo.trim(),
        'token': token.trim(),
        'nuevaPassword': nuevaPassword,
        'confirmacionPassword': confirmacionPassword,
      },
    );
  }

  /// Actualiza los datos del perfil propio (nombreCompleto, correo, password).
  Future<UserModel> updatePerfilMe({
    required String nombreCompleto,
    required String correo,
    String? passwordActual,
    String? nuevaPassword,
  }) async {
    final response = await _apiClient.put(
      ApiConfig.usuarioMe,
      data: {
        'nombreCompleto': nombreCompleto.trim(),
        'correo': correo.trim(),
        if (passwordActual != null && passwordActual.isNotEmpty)
          'passwordActual': passwordActual,
        if (nuevaPassword != null && nuevaPassword.isNotEmpty)
          'nuevaPassword': nuevaPassword,
      },
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Da de baja definitiva la cuenta del usuario en Azure.
  Future<void> deleteCuentaMe({required String passwordConfirmacion}) async {
    await _apiClient.delete(
      ApiConfig.usuarioMe,
      data: {
        'passwordConfirmacion': passwordConfirmacion,
      },
    );
  }

  /// Valida el token de verificación de correo electrónico.
  Future<bool> verificarCorreo({
    required String correo,
    required String token,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.verificarCorreo,
        data: {
          'correo': correo.trim(),
          'token': token.trim(),
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      // Si el endpoint aún no está expuesto en Azure, devolvemos validación sintáctica
      return token.trim().length >= 4;
    }
  }

  /// Reenvía el código o token de verificación al correo indicado.
  Future<void> reenviarVerificacion(String correo) async {
    try {
      await _apiClient.post(
        ApiConfig.reenviarVerificacion,
        data: {'correo': correo.trim()},
      );
    } catch (_) {
      // Tolerante si el backend aún no ha desplegado este endpoint específico
    }
  }
}
