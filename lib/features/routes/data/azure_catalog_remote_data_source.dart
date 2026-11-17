import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import 'models/api_models.dart';

/// Fuente de datos remota para consultar catálogos reales de Azure (Empresas, Rutas, Paradas, Tarifas, Destinos).
class AzureCatalogRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  /// Obtiene el catálogo de medios de transporte registrados (autobús, combi, etc.).
  Future<List<MedioTransporteModel>> getMediosTransporte() async {
    final response = await _apiClient.get(ApiConfig.mediosTransporte);

    if (response.data is List) {
      final list = response.data as List;
      return list
          .map((e) => MedioTransporteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (response.data is Map && response.data['items'] is List) {
      final list = response.data['items'] as List;
      return list
          .map((e) => MedioTransporteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Sonda de disponibilidad del backend en Azure.
  Future<bool> checkHealth() async {
    try {
      final response = await _apiClient.get(ApiConfig.health);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Obtiene la lista de empresas registradas.
  Future<List<EmpresaModel>> getEmpresas({String? q, String? municipio}) async {
    final response = await _apiClient.get(
      ApiConfig.empresas,
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (municipio != null && municipio.isNotEmpty) 'municipio': municipio,
        'activo': true,
      },
    );

    if (response.data is Map && response.data['items'] is List) {
      final list = response.data['items'] as List;
      return list.map((e) => EmpresaModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Obtiene sugerencias de paradas para autocompletar origen/destino.
  Future<List<ParadaModel>> autocompletarParadas(String query) async {
    if (query.length < 2) return [];

    final response = await _apiClient.get(
      ApiConfig.paradasAutocompletar,
      queryParameters: {'q': query, 'limite': 10},
    );

    if (response.data is List) {
      final list = response.data as List;
      return list.map((e) => ParadaModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Obtiene el catálogo de rutas con filtros opcionales.
  Future<List<RutaApiModel>> getRutas({String? empresaId, String? q}) async {
    final response = await _apiClient.get(
      ApiConfig.rutas,
      queryParameters: {
        if (empresaId != null && empresaId.isNotEmpty) 'empresaId': empresaId,
        if (q != null && q.isNotEmpty) 'q': q,
        'activa': true,
      },
    );

    if (response.data is Map && response.data['items'] is List) {
      final list = response.data['items'] as List;
      return list.map((e) => RutaApiModel.fromJson(e)).toList();
    } else if (response.data is List) {
      final list = response.data as List;
      return list.map((e) => RutaApiModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Busca alternativas de rutas entre una parada de origen y una parada de destino.
  Future<List<RutaApiModel>> buscarRutas({
    required String paradaOrigenId,
    required String paradaDestinoId,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.rutasBuscar,
      queryParameters: {
        'paradaOrigenId': paradaOrigenId,
        'paradaDestinoId': paradaDestinoId,
      },
    );

    if (response.data is Map && response.data['alternativas'] is List) {
      final list = response.data['alternativas'] as List;
      return list.map((e) => RutaApiModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Obtiene la lista de paradas en orden secuencial para una ruta específica.
  Future<List<ParadaModel>> getParadasDeRuta(String rutaId) async {
    final response = await _apiClient.get('${ApiConfig.rutas}/$rutaId/paradas');

    if (response.data is List) {
      final list = response.data as List;
      return list.map((e) => ParadaModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Obtiene la geometría cartográfica GeoJSON de una ruta para dibujarla en el mapa.
  Future<GeometriaRutaModel?> getGeometriaRuta(String rutaId) async {
    final response =
        await _apiClient.get('${ApiConfig.rutas}/$rutaId/geometria');
    if (response.data is Map<String, dynamic>) {
      return GeometriaRutaModel.fromJson(response.data);
    }
    return null;
  }

  /// Calcula el precio aproximado en MXN entre dos paradas de una ruta.
  Future<TarifaCalculoModel?> calcularTarifa({
    required String rutaId,
    required String paradaSubidaId,
    required String paradaBajadaId,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.tarifasCalcular,
      queryParameters: {
        'rutaId': rutaId,
        'paradaSubidaId': paradaSubidaId,
        'paradaBajadaId': paradaBajadaId,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return TarifaCalculoModel.fromJson(response.data);
    }
    return null;
  }

  /// Obtiene la lista de destinos turísticos registrados.
  Future<List<DestinoTuristicoModel>> getDestinos({String? categoria}) async {
    final response = await _apiClient.get(
      ApiConfig.destinos,
      queryParameters: {
        if (categoria != null && categoria.isNotEmpty) 'categoria': categoria,
      },
    );

    if (response.data is Map && response.data['items'] is List) {
      final list = response.data['items'] as List;
      return list.map((e) => DestinoTuristicoModel.fromJson(e)).toList();
    }
    return [];
  }
}
