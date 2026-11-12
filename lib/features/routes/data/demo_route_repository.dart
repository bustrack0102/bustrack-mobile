import '../../../../core/map/models/geo_point.dart';
import '../domain/models/route_stop.dart';
import '../domain/models/transport_route.dart';
import '../domain/repositories/route_repository.dart';

/// Repositorio de demostración.
///
/// IMPORTANTE: los datos son ilustrativos y están marcados con `isDemo = true`.
/// No representan rutas, paradas ni coordenadas oficiales. Deben sustituirse
/// por la respuesta de la API central (`GET /api/v1/rutas` y
/// `GET /api/v1/rutas/{id}/paradas`) cuando esté disponible.
class DemoRouteRepository implements RouteRepository {
  final Duration delay;
  final bool simulateFailure;

  const DemoRouteRepository({
    this.delay = const Duration(milliseconds: 250),
    this.simulateFailure = false,
  });

  @override
  Future<List<TransportRoute>> getRoutes({
    String query = '',
    TransportMode? mode,
  }) async {
    await Future<void>.delayed(delay);
    if (simulateFailure) {
      throw const RouteRepositoryException(
        'No se pudieron cargar las rutas desde la API central.',
      );
    }

    final normalizedQuery = _normalize(query);
    return demoRoutes.where((route) {
      final matchesMode = mode == null || route.mode == mode;
      if (!matchesMode) return false;
      if (normalizedQuery.isEmpty) return true;

      final searchable = [
        route.code,
        route.name,
        route.companyName,
        route.originName,
        route.destinationName,
        ...route.stops.map((stop) => stop.name),
      ].map(_normalize);

      return searchable.any((value) => value.contains(normalizedQuery));
    }).toList();
  }

  @override
  Future<TransportRoute?> getRouteById(String id) async {
    await Future<void>.delayed(delay);
    if (simulateFailure) {
      throw const RouteRepositoryException(
        'No se pudo cargar el detalle de la ruta.',
      );
    }

    for (final route in demoRoutes) {
      if (route.id == id) return route;
    }
    return null;
  }

  @override
  Future<List<RouteStop>> getStops(String routeId) async {
    final route = await getRouteById(routeId);
    return route?.orderedStops ?? const [];
  }

  static String _normalize(String value) => value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .trim();
}

RouteStop _stop(
  String id,
  String name,
  double lat,
  double lon,
  int order, {
  bool accessible = false,
  String? reference,
}) {
  return RouteStop(
    id: id,
    name: name,
    location: GeoPoint(lat, lon),
    order: order,
    isAccessible: accessible,
    reference: reference,
  );
}

/// Rutas de demostración claramente identificadas.
final List<TransportRoute> demoRoutes = [
  TransportRoute(
    id: 'ruta-102',
    code: '102',
    name: 'Centro – Campus Universitario',
    companyName: 'Transportes Metropolitanos Demo',
    mode: TransportMode.urban,
    originName: 'Terminal Centro',
    destinationName: 'Campus Universitario',
    fare: 10.0,
    frequencyMinutes: 8,
    estimatedDurationMinutes: 35,
    distanceKm: 9.4,
    nextArrivalMinutes: 6,
    status: RouteStatus.active,
    occupancy: RouteOccupancy.medium,
    isDemo: true,
    stops: [
      _stop('102-1', 'Terminal Centro', 25.6714, -100.3090, 1,
          accessible: true),
      _stop('102-2', 'Padre Mier', 25.6740, -100.3150, 2),
      _stop('102-3', 'Constitución', 25.6770, -100.3080, 3),
      _stop('102-4', 'Obispado', 25.6690, -100.3270, 4, accessible: true),
      _stop('102-5', 'Tecnológico', 25.6515, -100.2890, 5),
      _stop('102-6', 'Campus Universitario', 25.6480, -100.2850, 6,
          accessible: true),
    ],
    geometry: const [
      GeoPoint(25.6714, -100.3090),
      GeoPoint(25.6740, -100.3150),
      GeoPoint(25.6735, -100.3210),
      GeoPoint(25.6690, -100.3270),
      GeoPoint(25.6600, -100.3120),
      GeoPoint(25.6515, -100.2890),
      GeoPoint(25.6480, -100.2850),
    ],
  ),
  TransportRoute(
    id: 'ruta-204',
    code: '204',
    name: 'Plaza Hidalgo – Parque Industrial',
    companyName: 'Transportes Metropolitanos Demo',
    mode: TransportMode.urban,
    originName: 'Plaza Hidalgo',
    destinationName: 'Parque Industrial',
    fare: 10.0,
    frequencyMinutes: 12,
    estimatedDurationMinutes: 42,
    distanceKm: 12.1,
    occupancy: RouteOccupancy.low,
    isDemo: true,
    stops: [
      _stop('204-1', 'Plaza Hidalgo', 25.6690, -100.3200, 1, accessible: true),
      _stop('204-2', 'Constitución', 25.6770, -100.3080, 2),
      _stop('204-3', 'Guadalupe', 25.6760, -100.2480, 3),
      _stop('204-4', 'Parque Industrial', 25.7000, -100.2800, 4,
          accessible: true),
    ],
  ),
  TransportRoute(
    id: 'ruta-05-express',
    code: '05 Express',
    name: 'Estación Norte – Corredor Poniente',
    companyName: 'Movilidad Express Demo',
    mode: TransportMode.express,
    originName: 'Estación Norte',
    destinationName: 'Corredor Poniente',
    fare: 12.5,
    frequencyMinutes: 15,
    estimatedDurationMinutes: 25,
    distanceKm: 15.3,
    nextArrivalMinutes: 11,
    status: RouteStatus.delayed,
    occupancy: RouteOccupancy.high,
    isDemo: true,
    stops: [
      _stop('05-1', 'Estación Norte', 25.7150, -100.3150, 1, accessible: true),
      _stop('05-2', 'Universidad', 25.7260, -100.3110, 2),
      _stop('05-3', 'Obispado', 25.6690, -100.3270, 3),
      _stop('05-4', 'Corredor Poniente', 25.6900, -100.3700, 4),
    ],
  ),
  TransportRoute(
    id: 'ruta-310',
    code: '310',
    name: 'Universidad – Cumbres',
    companyName: 'Rutas del Poniente Demo',
    mode: TransportMode.feeder,
    originName: 'Universidad',
    destinationName: 'Cumbres',
    fare: 11.0,
    frequencyMinutes: 20,
    estimatedDurationMinutes: 50,
    distanceKm: 13.7,
    status: RouteStatus.suspended,
    isDemo: true,
    stops: [
      _stop('310-1', 'Universidad', 25.7260, -100.3110, 1, accessible: true),
      _stop('310-2', 'Estación Norte', 25.7150, -100.3150, 2),
      _stop('310-3', 'Cumbres', 25.7050, -100.3620, 3),
    ],
  ),
];
