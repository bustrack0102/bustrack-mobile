import '../../../../core/map/models/geo_point.dart';

/// Parada registrada de una ruta.
class RouteStop {
  final String id;
  final String name;
  final GeoPoint location;
  final int order;
  final bool isAccessible;
  final String? reference;
  final String? address;

  const RouteStop({
    required this.id,
    required this.name,
    required this.location,
    required this.order,
    this.isAccessible = false,
    this.reference,
    this.address,
  });

  bool get hasValidCoordinates => location.isValid;

  double? get latitude => location.latitude;
  double? get longitude => location.longitude;
  GeoPoint get point => location;

  RouteStop copyWith({
    String? id,
    String? name,
    GeoPoint? location,
    int? order,
    bool? isAccessible,
    String? reference,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    GeoPoint resolvedLocation = location ?? this.location;
    if (latitude != null || longitude != null) {
      resolvedLocation = GeoPoint(
        latitude ?? this.location.latitude,
        longitude ?? this.location.longitude,
      );
    }
    return RouteStop(
      id: id ?? this.id,
      name: name ?? this.name,
      location: resolvedLocation,
      order: order ?? this.order,
      isAccessible: isAccessible ?? this.isAccessible,
      reference: reference ?? this.reference,
      address: address ?? this.address,
    );
  }
}
