import '../../../../core/map/models/geo_point.dart';

/// Parada registrada de una ruta.
class RouteStop {
  final String id;
  final String name;
  final GeoPoint location;
  final int order;
  final bool isAccessible;
  final String? reference;

  const RouteStop({
    required this.id,
    required this.name,
    required this.location,
    required this.order,
    this.isAccessible = false,
    this.reference,
  });

  bool get hasValidCoordinates => location.isValid;
}
