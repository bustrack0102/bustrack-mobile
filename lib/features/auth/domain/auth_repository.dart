import '../data/models/user_model.dart';

/// Interfaz abstracta del repositorio de Autenticación.
abstract class AuthRepository {
  Future<UserModel> login({
    required String correo,
    required String password,
  });

  Future<UserModel> registro({
    required String nombreCompleto,
    required String correo,
    required String password,
    required String confirmacionPassword,
    required bool aceptaAvisoPrivacidad,
  });

  Future<void> logout();

  Future<UserModel?> getPerfilMe();

  Future<bool> hasActiveSession();

  Future<void> solicitarRecuperacionPassword(String correo);

  Future<void> restablecerPassword({
    required String correo,
    required String token,
    required String nuevaPassword,
    required String confirmacionPassword,
  });

  Future<bool> verificarCorreo({
    required String correo,
    required String token,
  });

  Future<void> reenviarVerificacion(String correo);
}
