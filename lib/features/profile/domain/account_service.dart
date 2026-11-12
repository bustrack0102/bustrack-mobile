/// Resultado de una solicitud de eliminación de cuenta.
class AccountDeletionResult {
  final bool deleted;
  final String message;

  const AccountDeletionResult({
    required this.deleted,
    required this.message,
  });
}

/// Servicio de cuenta.
///
/// La eliminación real requiere el endpoint de cuenta de la API central, que
/// todavía no está implementado. No se elimina solo el estado local para no
/// simular una baja que no existe en el servidor.
class AccountService {
  const AccountService();

  Future<AccountDeletionResult> requestDeletion() async {
    return const AccountDeletionResult(
      deleted: false,
      message:
          'La eliminación de cuenta requiere el endpoint de cuenta de la API '
          'central, que aún no está disponible. No se eliminó ningún dato.',
    );
  }
}
