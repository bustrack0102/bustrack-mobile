import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';

/// Modelo de Viaje Guardado según DTO de Azure (EP-VG-01..05).
class ViajeModel {
  final String id;
  final String titulo;
  final String rutaId;
  final String rutaNombre;
  final String? empresaNombre;
  final String? paradaOrigenId;
  final String? paradaDestinoId;
  final double? tarifaEstimadaMxn;
  final int? totalParadas;
  final String? notas;
  final bool favorito;
  final DateTime fechaActualizacion;

  ViajeModel({
    required this.id,
    required this.titulo,
    required this.rutaId,
    required this.rutaNombre,
    this.empresaNombre,
    this.paradaOrigenId,
    this.paradaDestinoId,
    this.tarifaEstimadaMxn,
    this.totalParadas,
    this.notas,
    this.favorito = false,
    required this.fechaActualizacion,
  });

  factory ViajeModel.fromJson(Map<String, dynamic> json) {
    return ViajeModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? json['Titulo']?.toString() ?? '',
      rutaId: json['rutaId']?.toString() ?? json['RutaId']?.toString() ?? '',
      rutaNombre: json['rutaNombre']?.toString() ??
          json['RutaNombre']?.toString() ??
          '',
      empresaNombre: json['empresaNombre']?.toString() ??
          json['EmpresaNombre']?.toString(),
      paradaOrigenId: json['paradaOrigenId']?.toString() ??
          json['ParadaOrigenId']?.toString(),
      paradaDestinoId: json['paradaDestinoId']?.toString() ??
          json['ParadaDestinoId']?.toString(),
      tarifaEstimadaMxn:
          ((json['tarifaEstimadaMxn'] ?? json['TarifaEstimadaMxn']) as num?)
              ?.toDouble(),
      totalParadas:
          (json['totalParadas'] ?? json['TotalParadas'] as num?)?.toInt(),
      notas: json['notas']?.toString() ?? json['Notas']?.toString(),
      favorito: json['favorito'] == true || json['Favorito'] == true,
      fechaActualizacion: DateTime.tryParse(
              json['fechaActualizacion']?.toString() ??
                  json['FechaActualizacion']?.toString() ??
                  '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Titulo': titulo,
      'RutaId': rutaId,
      'ParadaOrigenId': paradaOrigenId,
      'ParadaDestinoId': paradaDestinoId,
      'Notas': notas,
      'Favorito': favorito,
    };
  }
}

/// Fuente de datos remota para el historial de viajes en Azure.
class ViajesRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Obtiene todos los viajes guardados por el usuario actual.
  Future<List<ViajeModel>> getViajes() async {
    final response = await _apiClient.get(ApiConfig.viajes);
    if (response.data is List) {
      final list = response.data as List;
      return list
          .map((e) => ViajeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Obtiene los detalles de un viaje guardado.
  Future<ViajeModel?> getViajeById(String id) async {
    final response = await _apiClient.get('${ApiConfig.viajes}/$id');
    if (response.data is Map<String, dynamic>) {
      return ViajeModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  /// Guarda un nuevo viaje en Azure.
  Future<ViajeModel> crearViaje({
    required String titulo,
    required String rutaId,
    String? paradaOrigenId,
    String? paradaDestinoId,
    String? notas,
    bool favorito = false,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.viajes,
      data: {
        'Titulo': titulo,
        'RutaId': rutaId,
        if (paradaOrigenId != null) 'ParadaOrigenId': paradaOrigenId,
        if (paradaDestinoId != null) 'ParadaDestinoId': paradaDestinoId,
        if (notas != null) 'Notas': notas,
        'Favorito': favorito,
      },
    );
    return ViajeModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza un viaje guardado.
  Future<ViajeModel> actualizarViaje({
    required String id,
    required String titulo,
    String? paradaOrigenId,
    String? paradaDestinoId,
    String? notas,
    required bool favorito,
  }) async {
    final response = await _apiClient.put(
      '${ApiConfig.viajes}/$id',
      data: {
        'Titulo': titulo,
        if (paradaOrigenId != null) 'ParadaOrigenId': paradaOrigenId,
        if (paradaDestinoId != null) 'ParadaDestinoId': paradaDestinoId,
        if (notas != null) 'Notas': notas,
        'Favorito': favorito,
      },
    );
    return ViajeModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina un viaje del historial remoto.
  Future<void> eliminarViaje(String id) async {
    await _apiClient.delete('${ApiConfig.viajes}/$id');
  }
}
