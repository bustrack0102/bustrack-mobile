import '../models/route_stop.dart';
import '../models/transport_route.dart';

/// Error de datos de rutas (red, servidor o fuente no disponible).
class RouteRepositoryException implements Exception {
  final String message;

  const RouteRepositoryException(this.message);

  @override
  String toString() => message;
}

/// Contrato de acceso a rutas y paradas de la API central.
abstract class RouteRepository {
  Future<List<TransportRoute>> getRoutes({
    String query = '',
    TransportMode? mode,
  });

  Future<TransportRoute?> getRouteById(String id);

  Future<List<RouteStop>> getStops(String routeId);
}
