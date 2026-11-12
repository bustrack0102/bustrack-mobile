import '../../../../core/map/models/geo_point.dart';
import 'route_stop.dart';

/// Tipo de servicio de transporte.
enum TransportMode { urban, express, feeder }

extension TransportModeLabel on TransportMode {
  String get label => switch (this) {
        TransportMode.urban => 'Urbano',
        TransportMode.express => 'Express',
        TransportMode.feeder => 'Alimentador',
      };
}

/// Estado operativo de la ruta, cuando la API lo proporciona.
enum RouteStatus { active, delayed, suspended }

extension RouteStatusLabel on RouteStatus {
  String get label => switch (this) {
        RouteStatus.active => 'Activa',
        RouteStatus.delayed => 'Demora reportada',
        RouteStatus.suspended => 'Suspendida',
      };
}

/// Ocupación reportada, cuando la API la proporciona.
enum RouteOccupancy { low, medium, high }

extension RouteOccupancyLabel on RouteOccupancy {
  String get label => switch (this) {
        RouteOccupancy.low => 'Ocupación baja',
        RouteOccupancy.medium => 'Ocupación media',
        RouteOccupancy.high => 'Ocupación alta',
      };
}

/// Ruta de transporte público tal como la expone la API central.
///
/// Los campos opcionales solo se muestran en la UI cuando tienen datos.
class TransportRoute {
  final String id;
  final String code;
  final String name;
  final String companyName;
  final TransportMode mode;
  final String originName;
  final String destinationName;
  final double fare;
  final String currency;
  final int? frequencyMinutes;
  final int? estimatedDurationMinutes;
  final double? distanceKm;
  final int? nextArrivalMinutes;
  final RouteStatus? status;
  final RouteOccupancy? occupancy;
  final List<RouteStop> stops;

  /// Geometría opcional del recorrido. Si está vacía se dibuja una línea que
  /// conecta las paradas registradas.
  final List<GeoPoint> geometry;

  /// Identifica datos de demostración mientras la API no esté disponible.
  final bool isDemo;

  const TransportRoute({
    required this.id,
    required this.code,
    required this.name,
    required this.companyName,
    required this.mode,
    required this.originName,
    required this.destinationName,
    required this.fare,
    required this.stops,
    this.currency = 'MXN',
    this.frequencyMinutes,
    this.estimatedDurationMinutes,
    this.distanceKm,
    this.nextArrivalMinutes,
    this.status,
    this.occupancy,
    this.geometry = const [],
    this.isDemo = false,
  });

  List<RouteStop> get orderedStops {
    final result = [...stops];
    result.sort((a, b) => a.order.compareTo(b.order));
    return result;
  }

  GeoPoint? get originPoint {
    final ordered = orderedStops;
    return ordered.isEmpty ? null : ordered.first.location;
  }

  GeoPoint? get destinationPoint {
    final ordered = orderedStops;
    return ordered.isEmpty ? null : ordered.last.location;
  }

  /// Puntos para dibujar la polilínea. Usa la geometría de la API si existe.
  List<GeoPoint> get polylinePoints {
    if (geometry.length >= 2) {
      return geometry.where((point) => point.isValid).toList();
    }
    return orderedStops
        .where((stop) => stop.hasValidCoordinates)
        .map((stop) => stop.location)
        .toList();
  }

  bool get hasRegisteredGeometry => geometry.length >= 2;

  String get fareLabel => '\$${fare.toStringAsFixed(2)} $currency';

  String get displayName => '$code · $name';
}
