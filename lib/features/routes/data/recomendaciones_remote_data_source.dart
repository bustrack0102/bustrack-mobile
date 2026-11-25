import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';

/// Modelo de solicitud para recomendaciones de viaje con GenAI.
class RecomendacionRequest {
  final String origen;
  final String destino;
  final String? horario;
  final List<String>? preferencias;

  const RecomendacionRequest({
    required this.origen,
    required this.destino,
    this.horario,
    this.preferencias,
  });

  Map<String, dynamic> toJson() => {
        'origen': origen,
        'destino': destino,
        if (horario != null) 'horario': horario,
        if (preferencias != null) 'preferencias': preferencias,
      };
}

/// Modelo de respuesta de recomendación devuelto por la API.
class RecomendacionResponse {
  final String id;
  final String recomendacion;
  final List<String> rutasSugeridas;
  final String? tiempoEstimado;
  final double? costoAproximadoMxn;
  final String fechaCreacion;

  const RecomendacionResponse({
    required this.id,
    required this.recomendacion,
    this.rutasSugeridas = const [],
    this.tiempoEstimado,
    this.costoAproximadoMxn,
    required this.fechaCreacion,
  });

  factory RecomendacionResponse.fromJson(Map<String, dynamic> json) {
    return RecomendacionResponse(
      id: json['id']?.toString() ?? '',
      recomendacion: json['recomendacion']?.toString() ??
          json['mensaje']?.toString() ??
          '',
      rutasSugeridas: json['rutasSugeridas'] is List
          ? (json['rutasSugeridas'] as List).map((e) => e.toString()).toList()
          : const [],
      tiempoEstimado: json['tiempoEstimado']?.toString(),
      costoAproximadoMxn: json['costoAproximadoMxn'] != null
          ? double.tryParse(json['costoAproximadoMxn'].toString())
          : null,
      fechaCreacion:
          json['fechaCreacion']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}

/// Fuente de datos remota para el servicio de IA Generativa de recomendaciones de viaje.
class RecomendacionesRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Solicita una recomendación de viaje asistida por IA.
  Future<RecomendacionResponse?> solicitarRecomendacion(
      RecomendacionRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.recomendaciones,
        data: request.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return RecomendacionResponse.fromJson(
            response.data as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  /// Consulta el historial de recomendaciones del usuario autenticado.
  Future<List<RecomendacionResponse>> getHistorial() async {
    try {
      final response = await _apiClient.get(ApiConfig.recomendacionesHistorial);
      if (response.data is List) {
        return (response.data as List)
            .map((e) =>
                RecomendacionResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// Envía retroalimentación (feedback) sobre una recomendación generada.
  Future<bool> enviarRetroalimentacion({
    required String recomendacionId,
    required bool util,
    int? puntuacion,
    String? comentario,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.recomendaciones}/$recomendacionId/retroalimentacion',
        data: {
          'util': util,
          if (puntuacion != null) 'puntuacion': puntuacion,
          if (comentario != null) 'comentario': comentario,
        },
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
