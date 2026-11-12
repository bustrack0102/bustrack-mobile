import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

import 'models/geo_point.dart';

/// Administra la cámara, el zoom y los desplazamientos del mapa.
class MapControllerService {
  final MapController controller = MapController();

  bool _isReady = false;

  bool get isReady => _isReady;

  void markReady() {
    _isReady = true;
  }

  void moveTo(GeoPoint point, {double? zoom}) {
    if (!_isReady || !point.isValid) return;
    controller.move(point.toLatLng(), zoom ?? controller.camera.zoom);
  }

  /// Ajusta la cámara para que todos los puntos válidos queden visibles.
  void fitPoints(
    List<GeoPoint> points, {
    EdgeInsets padding = const EdgeInsets.all(48),
  }) {
    if (!_isReady) return;

    final validPoints = points
        .where((point) => point.isValid)
        .map((p) => p.toLatLng())
        .toList();
    if (validPoints.isEmpty) return;

    if (validPoints.length == 1) {
      controller.move(validPoints.first, 15.0);
      return;
    }

    controller.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(validPoints),
        padding: padding,
      ),
    );
  }

  void zoomIn() {
    if (!_isReady) return;
    final nextZoom = (controller.camera.zoom + 1).clamp(3.0, 18.0);
    controller.move(controller.camera.center, nextZoom);
  }

  void zoomOut() {
    if (!_isReady) return;
    final nextZoom = (controller.camera.zoom - 1).clamp(3.0, 18.0);
    controller.move(controller.camera.center, nextZoom);
  }

  void dispose() {
    controller.dispose();
  }
}
