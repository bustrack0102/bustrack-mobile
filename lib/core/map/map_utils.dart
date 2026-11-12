import 'dart:math' as math;

import 'models/geo_point.dart';

/// Utilidades geográficas compartidas por los mapas y el viaje en curso.
class MapUtils {
  MapUtils._();

  static const double _earthRadiusKm = 6371.0088;

  /// Distancia en línea recta entre dos coordenadas (fórmula de Haversine).
  static double distanceKm(GeoPoint from, GeoPoint to) {
    final lat1 = _toRadians(from.latitude);
    final lat2 = _toRadians(to.latitude);
    final deltaLat = _toRadians(to.latitude - from.latitude);
    final deltaLon = _toRadians(to.longitude - from.longitude);

    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;
}
