import 'geo_point.dart';

/// Tipo visual de un marcador del mapa.
enum AppMapMarkerKind {
  origin,
  destination,
  stop,
  stopPrevious,
  stopCurrent,
  stopNext,
  userLocation,
}

/// Representación de un marcador reutilizable del mapa.
class AppMapMarker {
  final String id;
  final GeoPoint point;
  final String label;
  final String? subtitle;
  final AppMapMarkerKind kind;

  const AppMapMarker({
    required this.id,
    required this.point,
    required this.label,
    required this.kind,
    this.subtitle,
  });
}
