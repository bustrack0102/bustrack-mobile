import 'package:latlong2/latlong.dart';

/// Coordenada geográfica independiente del proveedor de mapas.
class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint(this.latitude, this.longitude);

  bool get isValid =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  LatLng toLatLng() => LatLng(latitude, longitude);

  factory GeoPoint.fromLatLng(LatLng value) =>
      GeoPoint(value.latitude, value.longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
