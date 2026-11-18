import 'package:flutter/material.dart';

import '../../../../core/map/map_controller_service.dart';
import '../../../../core/map/map_view.dart';
import '../../../../core/map/models/app_map_marker.dart';
import '../../../../core/map/models/app_route_polyline.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demo_mock_data.dart';

/// Pantalla 3 de la Demo: Mapa interactivo demostrativo.
class DemoMapScreen extends StatefulWidget {
  const DemoMapScreen({super.key});

  @override
  State<DemoMapScreen> createState() => _DemoMapScreenState();
}

class _DemoMapScreenState extends State<DemoMapScreen> {
  final MapControllerService _mapController = MapControllerService();
  int _selectedRouteIndex = 0;
  DemoStopItem? _selectedStop;

  DemoStopItem? get selectedStop => _selectedStop;

  DemoRouteItem get _currentRoute => DemoMockData.routes[_selectedRouteIndex];

  List<AppMapMarker> _buildMarkers() {
    return _currentRoute.stops.map((stop) {
      final isFirst = stop.order == 1;
      final isLast = stop.order == _currentRoute.stops.length;
      final kind = isFirst
          ? AppMapMarkerKind.origin
          : (isLast ? AppMapMarkerKind.destination : AppMapMarkerKind.stop);

      return AppMapMarker(
        id: stop.id,
        point: stop.point,
        label: stop.name,
        subtitle: stop.address,
        kind: kind,
      );
    }).toList();
  }

  void _onMarkerTapped(AppMapMarker marker) {
    final match =
        _currentRoute.stops.where((s) => s.id == marker.id).firstOrNull;
    if (match != null) {
      setState(() => _selectedStop = match);
      _showStopDetailSheet(match);
    }
  }

  void _showStopDetailSheet(DemoStopItem stop) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.departure_board_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stop.name, style: AppTypography.titleMedium),
                      Text(stop.address, style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),
            _buildDetailRow(
                'Líneas que pasan:', stop.availableRoutes.join(', ')),
            _buildDetailRow('Empresa responsable:', stop.company),
            _buildDetailRow('Horarios de corrida:', stop.schedule),
            _buildDetailRow('Tarifa correspondiente:',
                '\$${stop.fareMxn.toStringAsFixed(2)} MXN'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cerrar información'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = _currentRoute;
    final polylines = [
      AppRoutePolyline(
        id: route.id,
        points: route.polyline,
        color: AppColors.primary,
        strokeWidth: 4.5,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          AppMapView(
            controllerService: _mapController,
            initialCenter: route.stops.first.point,
            initialZoom: 13.0,
            fitPoints: route.polyline,
            markers: _buildMarkers(),
            polylines: polylines,
            onMarkerTap: _onMarkerTapped,
          ),

          // Selector superior de rutas de demostración
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_bus_rounded,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedRouteIndex,
                              isExpanded: true,
                              items: List.generate(
                                DemoMockData.routes.length,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(
                                    DemoMockData.routes[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedRouteIndex = val);
                                  _mapController.centerOnPoints(
                                      DemoMockData.routes[val].polyline);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tarjeta inferior flotante de la ruta seleccionada
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      route.code,
                      style: const TextStyle(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${route.originName} → ${route.destinationName}',
                          style: AppTypography.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${route.stops.length} paradas · ${route.frequencyText}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${route.fareMxn.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
