import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';

/// Modelo de Consentimiento del Usuario (EP-ML-01..03).
class ConsentimientoModel {
  final String usuarioId;
  final bool activo;
  final String versionAviso;
  final DateTime? fechaActualizacion;

  ConsentimientoModel({
    required this.usuarioId,
    required this.activo,
    required this.versionAviso,
    this.fechaActualizacion,
  });

  factory ConsentimientoModel.fromJson(Map<String, dynamic> json) {
    return ConsentimientoModel(
      usuarioId:
          json['usuarioId']?.toString() ?? json['UsuarioId']?.toString() ?? '',
      activo: json['activo'] == true || json['Activo'] == true,
      versionAviso: json['versionAviso']?.toString() ??
          json['VersionAviso']?.toString() ??
          '1.0',
      fechaActualizacion: DateTime.tryParse(
          json['fechaActualizacion']?.toString() ??
              json['FechaActualizacion']?.toString() ??
              ''),
    );
  }
}

/// Fuente de datos remota para consentimientos del usuario en Azure.
class ConsentimientosRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Obtiene el estado actual del consentimiento del usuario autenticado.
  Future<ConsentimientoModel?> getMiConsentimiento() async {
    try {
      final response = await _apiClient.get(ApiConfig.consentimientosMe);
      if (response.data is Map<String, dynamic>) {
        return ConsentimientoModel.fromJson(
            response.data as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Otorga o renueva el consentimiento explícito de sensores.
  Future<ConsentimientoModel> otorgarConsentimiento({
    bool aceptaAviso = true,
    String versionAviso = '1.0',
  }) async {
    final response = await _apiClient.post(
      ApiConfig.consentimientos,
      data: {
        'AceptaAviso': aceptaAviso,
        'VersionAviso': versionAviso,
      },
    );
    return ConsentimientoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Revoca el consentimiento del usuario en el servidor.
  Future<void> revocarConsentimiento() async {
    await _apiClient.delete(ApiConfig.consentimientosMe);
  }
}
