import '../../auth/data/auth_repository_impl.dart';

/// Resultado de una solicitud de eliminación de cuenta.
class AccountDeletionResult {
  final bool deleted;
  final String message;

  const AccountDeletionResult({
    required this.deleted,
    required this.message,
  });
}

/// Servicio de cuenta conectado al endpoint DELETE /api/v1/usuarios/me.
class AccountService {
  final AuthRepositoryImpl _authRepository;

  AccountService({AuthRepositoryImpl? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  /// Solicita la baja definitiva de cuenta en el servidor de Azure.
  Future<AccountDeletionResult> requestDeletion({
    required String passwordConfirmacion,
  }) async {
    try {
      await _authRepository.deleteCuentaMe(
        passwordConfirmacion: passwordConfirmacion,
      );
      return const AccountDeletionResult(
        deleted: true,
        message:
            'Tu cuenta y datos personales han sido eliminados del servidor.',
      );
    } catch (e) {
      return AccountDeletionResult(
        deleted: false,
        message: 'No se pudo eliminar la cuenta: $e',
      );
    }
  }
}
