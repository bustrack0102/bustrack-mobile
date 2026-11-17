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
}
