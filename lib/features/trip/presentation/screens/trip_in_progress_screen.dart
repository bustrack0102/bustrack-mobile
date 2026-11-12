import 'package:flutter/material.dart';

import '../../../../core/map/location_service.dart';
import '../../../../core/map/map_controller_service.dart';
import '../../../../core/map/map_utils.dart';
import '../../../../core/map/map_view.dart';
import '../../../../core/map/models/app_map_marker.dart';
import '../../../../core/map/models/app_route_polyline.dart';
import '../../../../core/map/models/geo_point.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../../history/domain/journey_history_service.dart';
import '../../../history/domain/models/journey_record.dart';
import '../../../routes/domain/models/route_stop.dart';
import '../../../routes/domain/models/transport_route.dart';

/// Pantalla 8 – Viaje en curso.
///
/// No simula la posición de autobuses. La ubicación del usuario solo se usa si
/// autoriza el permiso y la ruta se dibuja con los datos registrados.
class TripInProgressScreen extends StatefulWidget {
  final TransportRoute route;
  final JourneyHistoryService? historyService;
  final LocationService? locationService;

  const TripInProgressScreen({
    super.key,
    required this.route,
    this.historyService,
    this.locationService,
  });

  @override
  State<TripInProgressScreen> createState() => _TripInProgressScreenState();
}

class _TripInProgressScreenState extends State<TripInProgressScreen> {
  final MapControllerService _mapController = MapControllerService();

  late final JourneyHistoryService _historyService;
  late final LocationService _locationService;
  late JourneyRecord _journey;

  GeoPoint? _userLocation;
  String? _locationMessage;
  bool _isRequestingLocation = false;
  late int _currentStopIndex;

  List<RouteStop> get _stops => widget.route.orderedStops;

  @override
  void initState() {
    super.initState();
    _historyService = widget.historyService ?? JourneyHistoryService.instance;
    _locationService =
        widget.locationService ?? const GeolocatorLocationService();
    _currentStopIndex = _stops.length > 1 ? 1 : 0;
    _journey = _historyService.startJourney(
      routeId: widget.route.id,
      routeCode: widget.route.code,
      routeName: widget.route.name,
      origin: widget.route.originName,
      destination: widget.route.destinationName,
      isDemo: widget.route.isDemo,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  RouteStop? get _nextStop {
    if (_stops.isEmpty) return null;
    return _stops[_currentStopIndex.clamp(0, _stops.length - 1)];
  }

  List<AppMapMarker> _buildMarkers() {
    final markers = <AppMapMarker>[];
    for (var index = 0; index < _stops.length; index++) {
      final stop = _stops[index];
      if (!stop.hasValidCoordinates) continue;

      final AppMapMarkerKind kind;
      if (index < _currentStopIndex) {
        kind = AppMapMarkerKind.stopPrevious;
      } else if (index == _currentStopIndex) {
        kind = AppMapMarkerKind.stopCurrent;
      } else if (index == _currentStopIndex + 1) {
        kind = AppMapMarkerKind.stopNext;
      } else {
        kind = AppMapMarkerKind.stop;
      }

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

    if (_userLocation != null) {
      markers.add(
        AppMapMarker(
          id: 'user-location',
          point: _userLocation!,
          label: 'Tu ubicación',
          kind: AppMapMarkerKind.userLocation,
        ),
      );
    }
    return markers;
  }

  List<AppRoutePolyline> _buildPolylines() {
    final polylines = <AppRoutePolyline>[
      AppRoutePolyline(
        id: '${widget.route.id}-full',
        points: widget.route.polylinePoints,
        color: AppColors.primary,
      ),
    ];

    if (!widget.route.hasRegisteredGeometry) {
      final traveled = _stops
          .take(_currentStopIndex + 1)
          .where((stop) => stop.hasValidCoordinates)
          .map((stop) => stop.location)
          .toList();
      if (traveled.length >= 2) {
        polylines.add(
          AppRoutePolyline(
            id: '${widget.route.id}-traveled',
            points: traveled,
            color: AppColors.secondary,
            strokeWidth: 4,
          ),
        );
      }
    }

    return polylines;
  }

  void _fitRoute({double bottomPadding = 280}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final points = [
        ...widget.route.polylinePoints,
        if (_userLocation != null) _userLocation!,
      ];
      _mapController.fitPoints(
        points,
        padding: EdgeInsets.fromLTRB(48, 64, 48, bottomPadding),
      );
    });
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isRequestingLocation = true;
      _locationMessage = null;
    });

    final result = await _locationService.requestCurrentPosition();
    if (!mounted) return;

    setState(() {
      _isRequestingLocation = false;
      if (result.isGranted) {
        _userLocation = result.position;
        _locationMessage = null;
      } else {
        _locationMessage = result.message;
      }
    });

    if (result.isGranted) {
      _fitRoute();
    }
  }

  Future<void> _finishTrip() async {
    final confirmed = await AppDialogs.showConfirmation(
      context: context,
      title: 'Finalizar recorrido',
      message:
          '¿Deseas finalizar este recorrido? Se guardará en el historial local '
          'de esta sesión.',
      confirmLabel: 'Finalizar',
      cancelLabel: 'Continuar',
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return;

    _historyService.completeJourney(_journey.id);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Recorrido finalizado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.route.code} · ${widget.route.name}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.route.originName} → '
                '${widget.route.destinationName}',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 12),
              const Text(
                'El recorrido se guardó en el historial local de esta sesión. '
                'La sincronización con la API central está pendiente.',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final nextStop = _nextStop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viaje en curso'),
        actions: [
          if (widget.route.isDemo)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(child: DemoDataBadge()),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AppMapView(
              controllerService: _mapController,
              fitPoints: [
                ...widget.route.polylinePoints,
                if (_userLocation != null) _userLocation!,
              ],
              markers: _buildMarkers(),
              polylines: _buildPolylines(),
              onMapReady: () => _fitRoute(),
              onMarkerTap: (marker) {
                if (marker.kind == AppMapMarkerKind.userLocation) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: Text(
                      marker.subtitle == null
                          ? marker.label
                          : '${marker.label} · ${marker.subtitle}',
                    ),
                  ),
                );
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.46,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nextStop == null
                                ? 'Sin paradas registradas'
                                : 'Siguiente: ${nextStop.name}',
                            style: AppTypography.titleMedium,
                          ),
                        ),
                        if (nextStop != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Parada ${nextStop.order}/${_stops.length}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontSize: 9,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.route.code} · ${widget.route.name}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    _TripInfoTile(
                      icon: Icons.my_location_rounded,
                      title: 'Ubicación del usuario',
                      detail: _locationMessage ??
                          (_userLocation == null
                              ? 'No activada. La ruta puede consultarse sin ubicación.'
                              : 'Ubicación activa solo en este viaje.'),
                      action: _userLocation == null
                          ? TextButton(
                              onPressed: _isRequestingLocation
                                  ? null
                                  : _requestLocation,
                              child: Text(
                                _isRequestingLocation
                                    ? 'Solicitando…'
                                    : 'Activar',
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _TripInfoTile(
                      icon: Icons.straighten_rounded,
                      title: 'Distancia a la siguiente parada',
                      detail: _distanceLabel(nextStop),
                    ),
                    const SizedBox(height: 10),
                    _TripInfoTile(
                      icon: Icons.schedule_rounded,
                      title: 'Tiempo estimado de llegada',
                      detail: widget.route.nextArrivalMinutes == null
                          ? 'No disponible: no hay datos en tiempo real de la unidad.'
                          : 'Llegada programada aproximada: '
                              '${widget.route.nextArrivalMinutes} min.',
                    ),
                    const SizedBox(height: 10),
                    const _TripInfoTile(
                      icon: Icons.sensors_off_rounded,
                      title: 'Acelerómetro',
                      detail:
                          'Desactivado. Requiere consentimiento explícito y el '
                          'procesamiento de sensores aún no está habilitado.',
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SummaryChip(
                          icon: Icons.payments_outlined,
                          label: widget.route.fareLabel,
                        ),
                        if (widget.route.frequencyMinutes != null)
                          _SummaryChip(
                            icon: Icons.repeat_rounded,
                            label: 'Cada ${widget.route.frequencyMinutes} min',
                          ),
                        if (widget.route.status != null)
                          _SummaryChip(
                            icon: Icons.info_outline_rounded,
                            label: widget.route.status!.label,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Próximas paradas',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_stops.isEmpty)
                      const Text(
                        'La API no devolvió paradas para esta ruta.',
                        style: AppTypography.bodySmall,
                      )
                    else
                      for (var index = _currentStopIndex;
                          index < _stops.length;
                          index++)
                        _UpcomingStopTile(
                          stop: _stops[index],
                          isCurrent: index == _currentStopIndex,
                          isNext: index == _currentStopIndex + 1,
                        ),
                    const SizedBox(height: 18),
                    AppPrimaryButton(
                      text: 'Finalizar recorrido',
                      icon: Icons.stop_circle_outlined,
                      onPressed: _finishTrip,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _distanceLabel(RouteStop? nextStop) {
    if (_userLocation == null) {
      return 'Activa tu ubicación para calcular la distancia en línea recta.';
    }
    if (nextStop == null || !nextStop.hasValidCoordinates) {
      return 'No hay coordenadas de la siguiente parada.';
    }
    final distance = MapUtils.distanceKm(_userLocation!, nextStop.location);
    return '${MapUtils.formatDistance(distance)} en línea recta (estimación).';
  }
}

class _TripInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final Widget? action;

  const _TripInfoTile({
    required this.icon,
    required this.title,
    required this.detail,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingStopTile extends StatelessWidget {
  final RouteStop stop;
  final bool isCurrent;
  final bool isNext;

  const _UpcomingStopTile({
    required this.stop,
    required this.isCurrent,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCurrent
        ? AppColors.primary
        : isNext
            ? AppColors.warning
            : AppColors.secondary;
    final label = isCurrent
        ? 'Siguiente parada'
        : isNext
            ? 'Después'
            : 'Más adelante';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(Icons.place_rounded, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          if (stop.isAccessible)
            const Icon(
              Icons.accessible_rounded,
              size: 16,
              color: AppColors.secondary,
            ),
        ],
      ),
    );
  }
}
