import 'package:flutter/material.dart';

import 'geo_point.dart';

/// Polilínea reutilizable para representar un recorrido.
class AppRoutePolyline {
  final String id;
  final List<GeoPoint> points;
  final Color color;
  final double strokeWidth;

  const AppRoutePolyline({
    required this.id,
    required this.points,
    required this.color,
    this.strokeWidth = 5.0,
  });

  bool get hasValidPoints =>
      points.length >= 2 && points.every((point) => point.isValid);
}
