import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../theme/app_colors.dart';
import 'map_config.dart';
import 'map_controller_service.dart';
import 'models/app_map_marker.dart';
import 'models/app_route_polyline.dart';
import 'models/geo_point.dart';

/// Componente reutilizable de mapa interactivo (flutter_map + OpenStreetMap).
class AppMapView extends StatelessWidget {
  final MapControllerService? controllerService;
  final GeoPoint? initialCenter;
  final double initialZoom;
  final List<GeoPoint> fitPoints;
  final List<AppMapMarker> markers;
  final List<AppRoutePolyline> polylines;
  final bool showAttribution;
  final void Function(AppMapMarker marker)? onMarkerTap;
  final VoidCallback? onMapReady;

  const AppMapView({
    super.key,
    this.controllerService,
    this.initialCenter,
    this.initialZoom = MapConfig.defaultZoom,
    this.fitPoints = const [],
    this.markers = const [],
    this.polylines = const [],
    this.showAttribution = true,
    this.onMarkerTap,
    this.onMapReady,
  });

  @override
  Widget build(BuildContext context) {
    final center = initialCenter ?? MapConfig.defaultCenter;
    final validFitPoints = fitPoints.where((point) => point.isValid).toList();

    return FlutterMap(
      mapController: controllerService?.controller,
      options: MapOptions(
        initialCenter: center.toLatLng(),
        initialZoom: initialZoom,
        minZoom: MapConfig.minZoom,
        maxZoom: MapConfig.maxZoom,
        initialCameraFit: validFitPoints.length >= 2
            ? CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(
                  validFitPoints.map((point) => point.toLatLng()).toList(),
                ),
                padding: const EdgeInsets.all(48),
              )
            : null,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: () {
          controllerService?.markReady();
          onMapReady?.call();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapConfig.tileUrlTemplate,
          userAgentPackageName: MapConfig.userAgentPackageName,
          maxZoom: MapConfig.maxZoom,
        ),
        if (polylines.any((polyline) => polyline.hasValidPoints))
          PolylineLayer(
            polylines: polylines
                .where((polyline) => polyline.hasValidPoints)
                .map(
                  (polyline) => Polyline(
                    points: polyline.points
                        .map((point) => point.toLatLng())
                        .toList(),
                    strokeWidth: polyline.strokeWidth,
                    color: polyline.color,
                    borderStrokeWidth: 2.0,
                    borderColor: AppColors.surfaceWhite,
                  ),
                )
                .toList(),
          ),
        if (markers.isNotEmpty)
          MarkerLayer(
            markers: markers
                .where((marker) => marker.point.isValid)
                .map(
                  (marker) => Marker(
                    point: marker.point.toLatLng(),
                    width: 44,
                    height: 52,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onMarkerTap == null
                          ? null
                          : () => onMarkerTap!(marker),
                      child: _MapPin(marker: marker),
                    ),
                  ),
                )
                .toList(),
          ),
        if (showAttribution)
          const RichAttributionWidget(
            showFlutterMapAttribution: false,
            attributions: [
              TextSourceAttribution(MapConfig.attributionText),
            ],
          ),
      ],
    );
  }
}

class _MapPin extends StatelessWidget {
  final AppMapMarker marker;

  const _MapPin({required this.marker});

  @override
  Widget build(BuildContext context) {
    if (marker.kind == AppMapMarkerKind.userLocation) {
      return Center(
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surfaceWhite, width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0x332563EB), blurRadius: 8),
            ],
          ),
        ),
      );
    }

    final (Color background, Color foreground, IconData icon) =
        switch (marker.kind) {
      AppMapMarkerKind.origin => (
          AppColors.success,
          AppColors.surfaceWhite,
          Icons.trip_origin_rounded,
        ),
      AppMapMarkerKind.destination => (
          AppColors.primary,
          AppColors.surfaceWhite,
          Icons.flag_rounded,
        ),
      AppMapMarkerKind.stopPrevious => (
          AppColors.disabled,
          AppColors.secondary,
          Icons.circle,
        ),
      AppMapMarkerKind.stopCurrent => (
          AppColors.primary,
          AppColors.surfaceWhite,
          Icons.directions_bus_rounded,
        ),
      AppMapMarkerKind.stopNext => (
          AppColors.tertiary,
          AppColors.primary,
          Icons.circle_outlined,
        ),
      AppMapMarkerKind.stop || AppMapMarkerKind.userLocation => (
          AppColors.surfaceWhite,
          AppColors.secondary,
          Icons.circle,
        ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surfaceWhite, width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 6),
            ],
          ),
          child: Icon(icon, size: 17, color: foreground),
        ),
        Icon(
          Icons.arrow_drop_down,
          size: 16,
          color: background,
        ),
      ],
    );
  }
}
