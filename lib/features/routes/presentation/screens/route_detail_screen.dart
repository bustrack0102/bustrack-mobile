import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/map/location_service.dart';
import '../../../../core/map/map_config.dart';
import '../../../../core/map/map_controller_service.dart';
import '../../../../core/map/map_view.dart';
import '../../../../core/map/models/app_map_marker.dart';
import '../../../../core/map/models/app_route_polyline.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../../feedback/presentation/screens/rate_contribute_screen.dart';
import '../../../history/domain/journey_history_service.dart';
import '../../../trip/presentation/screens/trip_in_progress_screen.dart';
import '../../domain/models/route_stop.dart';
import '../../domain/models/transport_route.dart';

/// Pantalla 7 – Detalle de ruta.
class RouteDetailScreen extends StatefulWidget {
  final TransportRoute route;
  final JourneyHistoryService? historyService;
  final LocationService? locationService;

  const RouteDetailScreen({
    super.key,
    required this.route,
    this.historyService,
    this.locationService,
  });

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final MapControllerService _mapController = MapControllerService();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<AppMapMarker> _buildMarkers() {
    final route = widget.route;
    final ordered = route.orderedStops;
    final markers = <AppMapMarker>[];

    for (var index = 0; index < ordered.length; index++) {
      final stop = ordered[index];
      if (!stop.hasValidCoordinates) continue;

      final kind = index == 0
          ? AppMapMarkerKind.origin
          : index == ordered.length - 1
              ? AppMapMarkerKind.destination
              : AppMapMarkerKind.stop;

      markers.add(
        AppMapMarker(
          id: stop.id,
          point: stop.location,
          label: stop.name,
          subtitle: 'Parada ${stop.order}',
          kind: kind,
        ),
      );
    }

    return markers;
  }

  void _fitRoute() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.fitPoints(
        widget.route.polylinePoints,
        padding: const EdgeInsets.all(52),
      );
    });
  }

  void _openStop(RouteStop stop) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${stop.order}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stop.name,
                        style: AppTypography.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.route_rounded,
                  label:
                      'Parada ${stop.order} de ${widget.route.orderedStops.length}',
                ),
                if (stop.reference != null)
                  _InfoRow(
                    icon: Icons.signpost_outlined,
                    label: stop.reference!,
                  ),
                _InfoRow(
                  icon: stop.isAccessible
                      ? Icons.accessible_rounded
                      : Icons.info_outline_rounded,
                  label: stop.isAccessible
                      ? 'Parada accesible'
                      : 'Accesibilidad no registrada',
                ),
                _InfoRow(
                  icon: Icons.place_outlined,
                  label: '${stop.location.latitude.toStringAsFixed(5)}, '
                      '${stop.location.longitude.toStringAsFixed(5)}',
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  text: 'Calificar y contribuir',
                  icon: Icons.star_outline_rounded,
                  height: 48,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RateContributeScreen(
                          route: widget.route,
                          initialStopName: stop.name,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startTrip() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TripInProgressScreen(
          route: widget.route,
          historyService: widget.historyService,
          locationService: widget.locationService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ruta ${route.code}'),
        actions: [
          if (route.isDemo)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(child: DemoDataBadge()),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapHeight = math.min(
            math.max(constraints.maxHeight * 0.4, 220.0),
            360.0,
          );

          return Column(
            children: [
              SizedBox(
                height: mapHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppMapView(
                        controllerService: _mapController,
                        fitPoints: route.polylinePoints,
                        markers: _buildMarkers(),
                        polylines: [
                          AppRoutePolyline(
                            id: route.id,
                            points: route.polylinePoints,
                            color: AppColors.primary,
                          ),
                        ],
                        onMapReady: _fitRoute,
                        onMarkerTap: (marker) {
                          RouteStop? stop;
                          for (final item in route.orderedStops) {
                            if (item.id == marker.id) {
                              stop = item;
                              break;
                            }
                          }
                          if (stop != null) _openStop(stop);
                        },
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Column(
                        children: [
                          _MapButton(
                            icon: Icons.add_rounded,
                            tooltip: 'Acercar',
                            onPressed: _mapController.zoomIn,
                          ),
                          const SizedBox(height: 8),
                          _MapButton(
                            icon: Icons.remove_rounded,
                            tooltip: 'Alejar',
                            onPressed: _mapController.zoomOut,
                          ),
                          const SizedBox(height: 8),
                          _MapButton(
                            icon: Icons.center_focus_strong_rounded,
                            tooltip: 'Centrar recorrido',
                            onPressed: _fitRoute,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(route.name, style: AppTypography.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        route.companyName,
                        style: AppTypography.bodySmall.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatCard(
                            icon: Icons.payments_outlined,
                            label: 'Tarifa oficial',
                            value: route.fareLabel,
                            highlight: true,
                          ),
                          if (route.frequencyMinutes != null)
                            _StatCard(
                              icon: Icons.schedule_rounded,
                              label: 'Frecuencia',
                              value: 'Cada ${route.frequencyMinutes} min',
                            ),
                          if (route.estimatedDurationMinutes != null)
                            _StatCard(
                              icon: Icons.timelapse_rounded,
                              label: 'Duración',
                              value: '${route.estimatedDurationMinutes} min',
                            ),
                          if (route.distanceKm != null)
                            _StatCard(
                              icon: Icons.straighten_rounded,
                              label: 'Distancia',
                              value:
                                  '${route.distanceKm!.toStringAsFixed(1)} km',
                            ),
                          if (route.status != null)
                            _StatCard(
                              icon: Icons.info_outline_rounded,
                              label: 'Estado',
                              value: route.status!.label,
                            ),
                          if (route.occupancy != null)
                            _StatCard(
                              icon: Icons.groups_2_outlined,
                              label: 'Ocupación',
                              value: route.occupancy!.label,
                            ),
                        ],
                      ),
                      if (!route.hasRegisteredGeometry) ...[
                        const SizedBox(height: 14),
                        const _NoticeCard(
                          icon: Icons.alt_route_rounded,
                          text: 'La API aún no entrega la geometría oficial de '
                              'esta ruta. El mapa conecta las paradas '
                              'registradas en orden.',
                        ),
                      ],
                      if (route.isDemo) ...[
                        const SizedBox(height: 10),
                        const _NoticeCard(
                          icon: Icons.science_outlined,
                          text: MapConfig.demoNotice,
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Paradas de la ruta',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          Text(
                            '${route.orderedStops.length} paradas',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (final stop in route.orderedStops)
                        _StopTile(
                          stop: stop,
                          isLast: stop.order == route.orderedStops.last.order,
                          onTap: () => _openStop(stop),
                        ),
                      if (route.orderedStops.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'La API no devolvió paradas para esta ruta.',
                            style: AppTypography.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: AppPrimaryButton(
          text: 'Comenzar recorrido',
          icon: Icons.play_arrow_rounded,
          onPressed: route.orderedStops.isEmpty ? null : _startTrip,
        ),
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  final RouteStop stop;
  final bool isLast;
  final VoidCallback onTap;

  const _StopTile({
    required this.stop,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Center(
                    child: Text(
                      '${stop.order}',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutralDark,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 26,
                    color: AppColors.inputBorder,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stop.isAccessible ? 'Accesible' : 'Parada registrada',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.tertiary.withValues(alpha: 0.4)
            : AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.tertiary : AppColors.inputBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: highlight ? AppColors.primary : AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 9)),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: highlight ? AppColors.primary : AppColors.neutralDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NoticeCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: AppTypography.bodySmall.copyWith(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _MapButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: AppColors.neutralDark),
      ),
    );
  }
}
