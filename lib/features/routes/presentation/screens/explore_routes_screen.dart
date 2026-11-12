import 'package:flutter/material.dart';

import '../../../../core/map/location_service.dart';
import '../../../../core/map/map_config.dart';
import '../../../../core/map/map_controller_service.dart';
import '../../../../core/map/map_view.dart';
import '../../../../core/map/models/app_map_marker.dart';
import '../../../../core/map/models/app_route_polyline.dart';
import '../../../../core/map/models/geo_point.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../../history/domain/journey_history_service.dart';
import '../../data/demo_route_repository.dart';
import '../../domain/models/transport_route.dart';
import '../../domain/repositories/route_repository.dart';
import '../widgets/route_card.dart';
import 'route_detail_screen.dart';

/// Pantalla 6 – Buscador de rutas / Explorar con mapa interactivo.
class ExploreRoutesScreen extends StatefulWidget {
  final RouteRepository? repository;
  final JourneyHistoryService? historyService;
  final LocationService? locationService;

  const ExploreRoutesScreen({
    super.key,
    this.repository,
    this.historyService,
    this.locationService,
  });

  @override
  State<ExploreRoutesScreen> createState() => _ExploreRoutesScreenState();
}

class _ExploreRoutesScreenState extends State<ExploreRoutesScreen> {
  late final RouteRepository _repository;
  late final JourneyHistoryService _historyService;
  late final LocationService _locationService;
  final MapControllerService _mapController = MapControllerService();

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  List<TransportRoute> _routes = const [];
  TransportRoute? _selectedRoute;
  TransportMode? _selectedMode;
  GeoPoint? _userLocation;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? const DemoRouteRepository();
    _historyService = widget.historyService ?? JourneyHistoryService.instance;
    _locationService =
        widget.locationService ?? const GeolocatorLocationService();
    _loadRoutes();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes({bool recordSearch = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final query = _destinationController.text.trim().isNotEmpty
        ? _destinationController.text
        : _originController.text;

    try {
      final routes = await _repository.getRoutes(
        query: query,
        mode: _selectedMode,
      );
      if (!mounted) return;

      setState(() {
        _routes = routes;
        _selectedRoute = routes.isEmpty ? null : routes.first;
        _isLoading = false;
      });

      if (recordSearch) {
        _historyService.recordSearch(
          origin: _originController.text,
          destination: _destinationController.text,
          routeId: _selectedRoute?.id,
          routeCode: _selectedRoute?.code,
          isDemo: _selectedRoute?.isDemo ?? false,
        );
      }

      _fitSelectedRoute(padding: const EdgeInsets.fromLTRB(48, 280, 48, 220));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No pudimos cargar las rutas. Revisa tu conexión.';
        _routes = const [];
        _selectedRoute = null;
      });
    }
  }

  void _fitSelectedRoute({EdgeInsets? padding}) {
    final route = _selectedRoute;
    if (route == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.fitPoints(
        route.polylinePoints,
        padding: padding ?? const EdgeInsets.all(48),
      );
    });
  }

  void _selectRoute(TransportRoute route) {
    setState(() => _selectedRoute = route);
    _fitSelectedRoute();
  }

  void _swapLocations() {
    final origin = _originController.text;
    setState(() {
      _originController.text = _destinationController.text;
      _destinationController.text = origin;
    });
  }

  Future<void> _useMyLocationAsOrigin() async {
    final result = await _locationService.requestCurrentPosition();
    if (!mounted) return;

    if (result.isGranted) {
      setState(() {
        _userLocation = result.position;
        _originController.text = 'Mi ubicación';
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.offline,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          result.message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.surfaceWhite,
          ),
        ),
      ),
    );
  }

  void _openRouteDetail(TransportRoute route) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RouteDetailScreen(
          route: route,
          historyService: _historyService,
          locationService: _locationService,
        ),
      ),
    );
  }

  List<AppMapMarker> _buildMarkers(TransportRoute route) {
    final markers = <AppMapMarker>[];
    final ordered = route.orderedStops;

    if (route.originPoint != null) {
      markers.add(
        AppMapMarker(
          id: '${route.id}-origin',
          point: route.originPoint!,
          label: route.originName,
          kind: AppMapMarkerKind.origin,
        ),
      );
    }
    if (route.destinationPoint != null) {
      markers.add(
        AppMapMarker(
          id: '${route.id}-destination',
          point: route.destinationPoint!,
          label: route.destinationName,
          kind: AppMapMarkerKind.destination,
        ),
      );
    }

    for (final stop in ordered) {
      if (!stop.hasValidCoordinates) continue;
      if (stop.order == ordered.first.order) continue;
      if (stop.order == ordered.last.order) continue;
      markers.add(
        AppMapMarker(
          id: stop.id,
          point: stop.location,
          label: stop.name,
          kind: AppMapMarkerKind.stop,
          subtitle: 'Parada ${stop.order}',
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

  @override
  Widget build(BuildContext context) {
    final selectedRoute = _selectedRoute;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AppMapView(
              controllerService: _mapController,
              markers: selectedRoute == null
                  ? const []
                  : _buildMarkers(selectedRoute),
              polylines: selectedRoute == null
                  ? const []
                  : [
                      AppRoutePolyline(
                        id: selectedRoute.id,
                        points: selectedRoute.polylinePoints,
                        color: AppColors.primary,
                      ),
                    ],
              onMapReady: () => _fitSelectedRoute(
                padding: const EdgeInsets.fromLTRB(48, 280, 48, 220),
              ),
              onMarkerTap: (marker) {
                if (marker.kind == AppMapMarkerKind.userLocation) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: Text(marker.label),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: _buildSearchPanel(),
            ),
          ),
          Positioned(
            right: 12,
            top: MediaQuery.of(context).size.height * 0.42,
            child: _buildMapControls(),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          DraggableScrollableSheet(
            initialChildSize: 0.34,
            minChildSize: 0.16,
            maxChildSize: 0.82,
            builder: (context, scrollController) {
              return _buildResultsSheet(scrollController);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Explorar rutas',
                  style: AppTypography.titleMedium,
                ),
              ),
              DemoDataBadge(
                tooltip: MapConfig.demoNotice,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _LocationField(
                      controller: _originController,
                      hint: 'Origen',
                      icon: Icons.trip_origin_rounded,
                      iconColor: AppColors.success,
                      onSubmitted: (_) => _loadRoutes(recordSearch: true),
                      trailing: IconButton(
                        tooltip: 'Usar mi ubicación como origen',
                        icon: const Icon(
                          Icons.my_location_rounded,
                          size: 18,
                          color: AppColors.secondary,
                        ),
                        onPressed: _useMyLocationAsOrigin,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _LocationField(
                      controller: _destinationController,
                      hint: 'Destino',
                      icon: Icons.flag_rounded,
                      iconColor: AppColors.primary,
                      onSubmitted: (_) => _loadRoutes(recordSearch: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Intercambiar origen y destino',
                onPressed: _swapLocations,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.inputBackground,
                  side: const BorderSide(color: AppColors.inputBorder),
                ),
                icon: const Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: AppPrimaryButton(
              text: 'Buscar rutas',
              icon: Icons.search_rounded,
              height: 44,
              onPressed:
                  _isLoading ? null : () => _loadRoutes(recordSearch: true),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ModeChip(
                  label: 'Todas',
                  selected: _selectedMode == null,
                  onSelected: () {
                    setState(() => _selectedMode = null);
                    _loadRoutes();
                  },
                ),
                for (final mode in TransportMode.values) ...[
                  const SizedBox(width: 6),
                  _ModeChip(
                    label: mode.label,
                    selected: _selectedMode == mode,
                    onSelected: () {
                      setState(() => _selectedMode = mode);
                      _loadRoutes();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _MapControlButton(
          icon: Icons.add_rounded,
          tooltip: 'Acercar',
          onPressed: _mapController.zoomIn,
        ),
        const SizedBox(height: 8),
        _MapControlButton(
          icon: Icons.remove_rounded,
          tooltip: 'Alejar',
          onPressed: _mapController.zoomOut,
        ),
        const SizedBox(height: 8),
        _MapControlButton(
          icon: Icons.center_focus_strong_rounded,
          tooltip: 'Centrar ruta',
          onPressed: () => _fitSelectedRoute(),
        ),
      ],
    );
  }

  Widget _buildResultsSheet(ScrollController scrollController) {
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
              const Expanded(
                child: Text(
                  'Rutas encontradas',
                  style: AppTypography.titleMedium,
                ),
              ),
              Text(
                '${_routes.length}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Toca una ruta para verla en el mapa.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 12),
          if (_errorMessage != null)
            OfflineStateWidget(
              message: _errorMessage!,
              onRetry: () => _loadRoutes(),
            )
          else if (!_isLoading && _routes.isEmpty)
            EmptyStateWidget(
              title: 'Sin rutas para esta búsqueda',
              message: 'Prueba con otro destino, cambia el filtro o limpia los '
                  'campos de búsqueda.',
              icon: Icons.route_rounded,
              actionLabel: 'Limpiar filtros',
              onActionPressed: () {
                _originController.clear();
                _destinationController.clear();
                setState(() => _selectedMode = null);
                _loadRoutes();
              },
            )
          else
            for (final route in _routes) ...[
              RouteCard(
                route: route,
                isSelected: route.id == _selectedRoute?.id,
                onSelect: () => _selectRoute(route),
                onDetail: () => _openRouteDetail(route),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final ValueChanged<String>? onSubmitted;
  final Widget? trailing;

  const _LocationField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
    this.onSubmitted,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        prefixIcon: Icon(icon, size: 18, color: iconColor),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 38, minHeight: 38),
        suffixIcon: trailing,
        suffixIconConstraints:
            const BoxConstraints(minWidth: 38, minHeight: 38),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: AppTypography.bodySmall.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: selected ? AppColors.surfaceWhite : AppColors.neutralDark,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.inputBackground,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.inputBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      showCheckmark: false,
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _MapControlButton({
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
        icon: Icon(icon, color: AppColors.neutralDark, size: 20),
      ),
    );
  }
}
