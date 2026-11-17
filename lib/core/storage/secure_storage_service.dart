import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio singleton para el almacenamiento seguro de tokens JWT e información de sesión.
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // flutter_secure_storage v11: almacenamiento cifrado por defecto con
  // AES-GCM + RSA OAEP (Android Keystore). Ya no existe
  // `encryptedSharedPreferences`; v11 migra al nuevo esquema de cifrado.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyAccessToken = 'jwt_access_token';
  static const String _keyRefreshToken = 'jwt_refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';

  /// Guarda los tokens de acceso y renovación devueltos por Azure Backend.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  /// Recupera el Access Token actual.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Recupera el Refresh Token actual.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Guarda los datos del perfil de usuario en almacenamiento seguro.
  Future<void> saveUserData({
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    await _storage.write(key: _keyUserId, value: id);
    await _storage.write(key: _keyUserName, value: name);
    await _storage.write(key: _keyUserEmail, value: email);
    await _storage.write(key: _keyUserRole, value: role);
  }

  /// Lee los datos guardados del usuario.
  Future<Map<String, String?>> getUserData() async {
    final id = await _storage.read(key: _keyUserId);
    final name = await _storage.read(key: _keyUserName);
    final email = await _storage.read(key: _keyUserEmail);
    final role = await _storage.read(key: _keyUserRole);
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  /// Comprueba si existe una sesión guardada activa.
  Future<bool> hasActiveSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Elimina de forma limpia los tokens y datos del usuario al cerrar sesión.
  /// Solo borra las claves propias de autenticación; no toca otras claves
  /// que la app pueda almacenar en el futuro.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyUserId),
      _storage.delete(key: _keyUserName),
      _storage.delete(key: _keyUserEmail),
      _storage.delete(key: _keyUserRole),
    ]);
  }
}
