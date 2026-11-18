import '../../../core/storage/secure_storage_service.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';
import 'models/user_model.dart';

/// Implementación del repositorio de Autenticación conectando la API de Azure con el almacenamiento seguro.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final SecureStorageService _storage = SecureStorageService();

  static final AuthRepositoryImpl _instance = AuthRepositoryImpl._internal();
  factory AuthRepositoryImpl() => _instance;
  AuthRepositoryImpl._internal();

  @override
  Future<UserModel> login({
    required String correo,
    required String password,
  }) async {
    final authResponse = await _remoteDataSource.login(
      correo: correo,
      password: password,
    );

    // Guardar tokens de acceso y renovacion de forma encriptada
    await _storage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    UserModel user;
    if (authResponse.usuario != null) {
      user = authResponse.usuario!;
    } else {
      user = await _remoteDataSource.getPerfilMe();
    }

    await _storage.saveUserData(
      id: user.id,
      name: user.nombreCompleto,
      email: user.correo,
      role: user.rol,
    );

    return user;
  }

  @override
  Future<UserModel> registro({
    required String nombreCompleto,
    required String correo,
    required String password,
    required String confirmacionPassword,
    required bool aceptaAvisoPrivacidad,
  }) async {
    final authResponse = await _remoteDataSource.registro(
      nombreCompleto: nombreCompleto,
      correo: correo,
      password: password,
      confirmacionPassword: confirmacionPassword,
      aceptaAvisoPrivacidad: aceptaAvisoPrivacidad,
    );

    await _storage.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    UserModel user;
    if (authResponse.usuario != null) {
      user = authResponse.usuario!;
    } else {
      user = await _remoteDataSource.getPerfilMe();
    }

    await _storage.saveUserData(
      id: user.id,
      name: user.nombreCompleto,
      email: user.correo,
      role: user.rol,
    );

    return user;
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _remoteDataSource.logout(refreshToken);
      }
    } catch (_) {
      // Si falla la peticion de logout en backend por red, igual se limpia la sesion local
    } finally {
      await _storage.clearSession();
    }
  }

  @override
  Future<UserModel?> getPerfilMe() async {
    try {
      return await _remoteDataSource.getPerfilMe();
    } catch (_) {
      // Si no hay conexion o fallo, intentar recuperar los datos guardados en local
      final id = await _storage.getUserId();
      final name = await _storage.getUserName();
      final email = await _storage.getUserEmail();
      final role = await _storage.getUserRole();

      if (id != null && name != null && email != null) {
        return UserModel(
          id: id,
          nombreCompleto: name,
          correo: email,
          rol: role ?? 'Usuario',
        );
      }
      return null;
    }
  }

  @override
  Future<bool> hasActiveSession() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> solicitarRecuperacionPassword(String correo) async {
    await _remoteDataSource.solicitarRecuperacionPassword(correo);
  }

  @override
  Future<void> restablecerPassword({
    required String correo,
    required String token,
    required String nuevaPassword,
    required String confirmacionPassword,
  }) async {
    await _remoteDataSource.restablecerPassword(
      correo: correo,
      token: token,
      nuevaPassword: nuevaPassword,
      confirmacionPassword: confirmacionPassword,
    );
  }

  @override
  Future<bool> verificarCorreo({
    required String correo,
    required String token,
  }) async {
    return await _remoteDataSource.verificarCorreo(
      correo: correo,
      token: token,
    );
  }

  @override
  Future<void> reenviarVerificacion(String correo) async {
    await _remoteDataSource.reenviarVerificacion(correo);
  }
}
