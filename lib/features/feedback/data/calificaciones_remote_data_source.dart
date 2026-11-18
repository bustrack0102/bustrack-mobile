import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';

/// Modelo de datos para Calificación recibido y enviado a la API de Azure.
class CalificacionModel {
  final String id;
  final String usuarioId;
  final String usuarioNombre;
  final String? rutaId;
  final String? empresaId;
  final String? destinoId;
  final int puntuacion;
  final String? comentario;
  final String? imagenUrl;
  final DateTime fechaCreacion;

  CalificacionModel({
    required this.id,
    required this.usuarioId,
    required this.usuarioNombre,
    this.rutaId,
    this.empresaId,
    this.destinoId,
    required this.puntuacion,
    this.comentario,
    this.imagenUrl,
    required this.fechaCreacion,
  });

  factory CalificacionModel.fromJson(Map<String, dynamic> json) {
    return CalificacionModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      usuarioId:
          json['usuarioId']?.toString() ?? json['UsuarioId']?.toString() ?? '',
      usuarioNombre: json['usuarioNombre']?.toString() ??
          json['UsuarioNombre']?.toString() ??
          '',
      rutaId: json['rutaId']?.toString() ?? json['RutaId']?.toString(),
      empresaId: json['empresaId']?.toString() ?? json['EmpresaId']?.toString(),
      destinoId: json['destinoId']?.toString() ?? json['DestinoId']?.toString(),
      puntuacion: (json['puntuacion'] ?? json['Puntuacion'] ?? 5) as int,
      comentario:
          json['comentario']?.toString() ?? json['Comentario']?.toString(),
      imagenUrl: json['imagenUrl']?.toString() ?? json['ImagenUrl']?.toString(),
      fechaCreacion: DateTime.tryParse(json['fechaCreacion']?.toString() ??
              json['FechaCreacion']?.toString() ??
              '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RutaId': rutaId,
      'EmpresaId': empresaId,
      'DestinoId': destinoId,
      'Puntuacion': puntuacion,
      'Comentario': comentario,
      'ImagenUrl': imagenUrl,
    };
  }
}

/// Resumen estadístico de calificaciones de una ruta o empresa.
class CalificacionResumenModel {
  final int totalOpiniones;
  final double promedio;
  final int estrellas5;
  final int estrellas4;
  final int estrellas3;
  final int estrellas2;
  final int estrellas1;

  CalificacionResumenModel({
    required this.totalOpiniones,
    required this.promedio,
    this.estrellas5 = 0,
    this.estrellas4 = 0,
    this.estrellas3 = 0,
    this.estrellas2 = 0,
    this.estrellas1 = 0,
  });

  factory CalificacionResumenModel.fromJson(Map<String, dynamic> json) {
    return CalificacionResumenModel(
      totalOpiniones:
          (json['totalOpiniones'] ?? json['TotalOpiniones'] ?? 0) as int,
      promedio:
          ((json['promedio'] ?? json['Promedio'] ?? 0.0) as num).toDouble(),
      estrellas5: (json['estrellas5'] ?? json['Estrellas5'] ?? 0) as int,
      estrellas4: (json['estrellas4'] ?? json['Estrellas4'] ?? 0) as int,
      estrellas3: (json['estrellas3'] ?? json['Estrellas3'] ?? 0) as int,
      estrellas2: (json['estrellas2'] ?? json['Estrellas2'] ?? 0) as int,
      estrellas1: (json['estrellas1'] ?? json['Estrellas1'] ?? 0) as int,
    );
  }
}

/// Fuente de datos remota para el módulo de Calificaciones en Azure.
class CalificacionesRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Consulta las calificaciones públicas de una ruta o empresa.
  Future<List<CalificacionModel>> getCalificaciones({
    String? rutaId,
    String? empresaId,
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.calificaciones,
      queryParameters: {
        if (rutaId != null) 'rutaId': rutaId,
        if (empresaId != null) 'empresaId': empresaId,
        'page': page,
      },
    );

    if (response.data is Map && response.data['items'] is List) {
      final list = response.data['items'] as List;
      return list
          .map((e) => CalificacionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (response.data is List) {
      final list = response.data as List;
      return list
          .map((e) => CalificacionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Consulta el resumen estadístico de calificaciones.
  Future<CalificacionResumenModel> getResumen({
    String? rutaId,
    String? empresaId,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.calificacionesResumen,
      queryParameters: {
        if (rutaId != null) 'rutaId': rutaId,
        if (empresaId != null) 'empresaId': empresaId,
      },
    );
    return CalificacionResumenModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Consulta las calificaciones del usuario autenticado.
  Future<List<CalificacionModel>> getMisCalificaciones() async {
    final response = await _apiClient.get(ApiConfig.calificacionesMias);
    if (response.data is List) {
      final list = response.data as List;
      return list
          .map((e) => CalificacionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Registra una nueva calificación en Azure.
  Future<CalificacionModel> crearCalificacion({
    String? rutaId,
    String? empresaId,
    String? destinoId,
    required int puntuacion,
    String? comentario,
    String? imagenUrl,
  }) async {
    final payload = {
      if (rutaId != null) 'RutaId': rutaId,
      if (empresaId != null) 'EmpresaId': empresaId,
      if (destinoId != null) 'DestinoId': destinoId,
      'Puntuacion': puntuacion,
      if (comentario != null) 'Comentario': comentario,
      if (imagenUrl != null) 'ImagenUrl': imagenUrl,
    };

    final response = await _apiClient.post(
      ApiConfig.calificaciones,
      data: payload,
    );
    return CalificacionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Edita una calificación propia.
  Future<CalificacionModel> editarCalificacion({
    required String id,
    required int puntuacion,
    String? comentario,
    String? imagenUrl,
  }) async {
    final response = await _apiClient.put(
      '${ApiConfig.calificaciones}/$id',
      data: {
        'Puntuacion': puntuacion,
        if (comentario != null) 'Comentario': comentario,
        if (imagenUrl != null) 'ImagenUrl': imagenUrl,
      },
    );
    return CalificacionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina una calificación propia.
  Future<void> eliminarCalificacion(String id) async {
    await _apiClient.delete('${ApiConfig.calificaciones}/$id');
  }
}
