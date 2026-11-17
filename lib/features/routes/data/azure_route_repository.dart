import '../../../../core/map/models/geo_point.dart';
import '../domain/models/route_stop.dart';
import '../domain/models/transport_route.dart';
import '../domain/repositories/route_repository.dart';
import 'azure_catalog_remote_data_source.dart';
import 'demo_route_repository.dart';
import 'models/api_models.dart';

/// Repositorio de Rutas conectado a la API de Azure Backend.
///
/// Si la API no está disponible, recurre al repositorio demo (los datos
/// devueltos van marcados con `isDemo = true` para que la UI los distinga).
class AzureRouteRepository implements RouteRepository {
  final AzureCatalogRemoteDataSource _remoteDataSource;
  final DemoRouteRepository _demoRepository;

  /// Caché en memoria del catálogo de rutas (5 minutos) para evitar
  /// re-descargar el catálogo completo en cada detalle.
  List<RutaApiModel>? _rutasCache;
  DateTime? _rutasCacheAt;
  static const _rutasCacheTtl = Duration(minutes: 5);

  AzureRouteRepository({
    AzureCatalogRemoteDataSource? remoteDataSource,
    DemoRouteRepository? demoRepository,
  })  : _remoteDataSource = remoteDataSource ?? AzureCatalogRemoteDataSource(),
        _demoRepository = demoRepository ?? const DemoRouteRepository();

  Future<List<RutaApiModel>> _getRutasCached({String? empresaId, String? q}) {
    // Solo se cachea el catálogo completo (sin filtros), que es el que se
    // reutiliza al resolver el detalle de una ruta.
    final canUseCache = empresaId == null &&
        (q == null || q.isEmpty) &&
        _rutasCache != null &&
        _rutasCacheAt != null &&
        DateTime.now().difference(_rutasCacheAt!) < _rutasCacheTtl;
    if (canUseCache) return Future.value(_rutasCache);

    return _remoteDataSource.getRutas(empresaId: empresaId, q: q).then((list) {
      if (empresaId == null && (q == null || q.isEmpty)) {
        _rutasCache = list;
        _rutasCacheAt = DateTime.now();
      }
      return _rutasCache ?? list;
    });
  }

  /// Alternativas de ruta entre una parada de origen y una parada de destino.
  Future<List<TransportRoute>> searchAlternatives({
    required String paradaOrigenId,
    required String paradaDestinoId,
  }) async {
    final alternativas = await _remoteDataSource.buscarRutas(
      paradaOrigenId: paradaOrigenId,
      paradaDestinoId: paradaDestinoId,
    );
    return alternativas.map((r) => mapRutaApiToDomain(r)).toList();
  }

  @override
  Future<List<TransportRoute>> getRoutes({
    String query = '',
    TransportMode? mode,
  }) async {
    try {
      // Una lista vacía de la API es un resultado válido, no un error:
      // solo se recurre a los datos demo cuando la llamada falla.
      final apiRutas = await _getRutasCached(q: query);
      return apiRutas.map((r) => mapRutaApiToDomain(r)).toList();
    } catch (_) {
      // Sin conexión o error de API: se cae al repositorio demo marcado.
    }
    return _demoRepository.getRoutes(query: query, mode: mode);
  }

  @override
  Future<TransportRoute?> getRouteById(String id) async {
    try {
      final results = await Future.wait([
        _remoteDataSource.getParadasDeRuta(id),
        _remoteDataSource.getGeometriaRuta(id),
        _getRutasCached(),
      ]);
      final apiParadas = results[0] as List<ParadaModel>;
      final apiGeometria = results[1] as GeometriaRutaModel?;
      final apiRutas = results[2] as List<RutaApiModel>;

      final match = apiRutas.where((r) => r.id == id).firstOrNull;
      if (match == null) {
        // La API está disponible pero la ruta no existe: no inventar datos.
        return null;
      }

      final stopsDomain = _mapParadasDeRuta(apiParadas);
      List<GeoPoint>? geometry;
      if (apiGeometria != null &&
          apiGeometria.coordenadasLineString.isNotEmpty) {
        geometry = apiGeometria.coordenadasLineString
            .map((c) => GeoPoint(c[0], c[1]))
            .toList();
      }

      return mapRutaApiToDomain(match, stops: stopsDomain, geometry: geometry);
    } catch (_) {
      return _demoRepository.getRouteById(id);
    }
  }

  @override
  Future<List<RouteStop>> getStops(String routeId) async {
    try {
      final paradas = await _remoteDataSource.getParadasDeRuta(routeId);
      // La API puede devolver una secuencia vacía legítimamente.
      return _mapParadasDeRuta(paradas);
    } catch (_) {
      // Sin conexión o error de API: se cae al repositorio demo.
    }
    return _demoRepository.getStops(routeId);
  }

  List<RouteStop> _mapParadasDeRuta(List<ParadaModel> paradas) {
    return [
      for (var i = 0; i < paradas.length; i++)
        RouteStop(
          id: paradas[i].id,
          name: paradas[i].nombre,
          location: GeoPoint(paradas[i].latitud, paradas[i].longitud),
          order: paradas[i].orden ?? i + 1,
          reference: paradas[i].referenciaVisual,
          isAccessible: paradas[i].esAccesible,
        ),
    ];
  }

  TransportRoute mapRutaApiToDomain(
    RutaApiModel r, {
    List<RouteStop>? stops,
    List<GeoPoint>? geometry,
  }) {
    return TransportRoute(
      id: r.id,
      code: r.codigo.isNotEmpty ? r.codigo : 'RUTA',
      name: r.nombre,
      companyName: r.empresaNombre ?? 'Empresa no especificada',
      mode: TransportMode.urban,
      originName: r.paradaOrigenNombre ?? 'Terminal de salida',
      destinationName: r.paradaDestinoNombre ?? 'Terminal de llegada',
      fare: r.tarifaBaseMxn > 0 ? r.tarifaBaseMxn : 0.0,
      frequencyMinutes: null,
      estimatedDurationMinutes: r.tiempoEstimadoMin?.toInt(),
      distanceKm: r.distanciaTotalKm,
      isDemo: false,
      stops: stops ?? const [],
      geometry: geometry ?? const [],
    );
  }
}
