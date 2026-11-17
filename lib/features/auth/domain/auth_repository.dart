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
}
