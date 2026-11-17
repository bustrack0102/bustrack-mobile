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
    } catch (e) {
      final localData = await _storage.getUserData();
      if (localData['id'] != null && localData['id']!.isNotEmpty) {
        return UserModel(
          id: localData['id']!,
          nombreCompleto: localData['name'] ?? '',
          correo: localData['email'] ?? '',
          rol: localData['role'] ?? 'Usuario',
        );
      }
      return null;
    }
  }

  @override
  Future<bool> hasActiveSession() async {
    try {
      return await _storage.hasActiveSession();
    } catch (_) {
      // Sin el plugin de secure storage disponible (tests/preview), no hay sesión.
      return false;
    }
  }
}
