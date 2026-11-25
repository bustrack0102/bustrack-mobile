import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';

/// Modelo para el registro de dispositivos móviles y notificaciones push.
class DispositivoModel {
  final String id;
  final String tokenFcm;
  final String plataforma;
  final String fechaRegistro;

  const DispositivoModel({
    required this.id,
    required this.tokenFcm,
    required this.plataforma,
    required this.fechaRegistro,
  });

  factory DispositivoModel.fromJson(Map<String, dynamic> json) {
    return DispositivoModel(
      id: json['id']?.toString() ?? '',
      tokenFcm: json['tokenFcm']?.toString() ?? '',
      plataforma: json['plataforma']?.toString() ?? 'android',
      fechaRegistro:
          json['fechaRegistro']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}

/// Fuente de datos remota para el registro y gestión de dispositivos con FCM.
class DispositivosRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Registra el token de Firebase Cloud Messaging del dispositivo del usuario.
  Future<DispositivoModel?> registrarDispositivo({
    required String tokenFcm,
    String plataforma = 'Android',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.dispositivos,
        data: {
          'tokenFcm': tokenFcm,
          'plataforma': plataforma,
        },
      );
      if (response.data is Map<String, dynamic>) {
        return DispositivoModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  /// Obtiene los dispositivos registrados vinculados a la cuenta del usuario.
  Future<List<DispositivoModel>> getMisDispositivos() async {
    try {
      final response = await _apiClient.get(ApiConfig.dispositivosMios);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => DispositivoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// Desvincula y elimina el token de un dispositivo registrado.
  Future<bool> eliminarDispositivo(String id) async {
    try {
      final response = await _apiClient.delete('${ApiConfig.dispositivos}/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
