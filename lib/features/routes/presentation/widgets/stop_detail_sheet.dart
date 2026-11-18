import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/route_stop.dart';

/// Tarjeta informativa modal para mostrar detalles completos al seleccionar una parada en el mapa.
class StopDetailSheet extends StatelessWidget {
  final RouteStop stop;
  final String? routeName;
  final String? companyName;
  final double? fareMxn;
  final String? scheduleText;
  final List<String> otherRoutes;
  final VoidCallback? onSetAsOrigin;
  final VoidCallback? onSetAsDestination;

  const StopDetailSheet({
    super.key,
    required this.stop,
    this.routeName,
    this.companyName,
    this.fareMxn,
    this.scheduleText,
    this.otherRoutes = const [],
    this.onSetAsOrigin,
    this.onSetAsDestination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.departure_board_rounded,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stop.name, style: AppTypography.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      stop.address ?? 'Ubicación sin dirección registrada',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          if (routeName != null) _buildInfoRow('Ruta actual:', routeName!),
          if (companyName != null)
            _buildInfoRow('Empresa responsable:', companyName!),
          if (scheduleText != null)
            _buildInfoRow('Horarios disponibles:', scheduleText!),
          if (fareMxn != null)
            _buildInfoRow(
                'Tarifa estimada:', '\$${fareMxn!.toStringAsFixed(2)} MXN'),
          if (otherRoutes.isNotEmpty)
            _buildInfoRow('Otras rutas que pasan:', otherRoutes.join(', ')),

          const SizedBox(height: 20),

          // Botones de acción rápida: Establecer como origen / destino
          Row(
            children: [
              if (onSetAsOrigin != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSetAsOrigin,
                    icon: const Icon(Icons.trip_origin_rounded,
                        size: 16, color: AppColors.primary),
                    label: const Text('Fijar Origen',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (onSetAsOrigin != null && onSetAsDestination != null)
                const SizedBox(width: 10),
              if (onSetAsDestination != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSetAsDestination,
                    icon: const Icon(Icons.flag_rounded, size: 16),
                    label: const Text('Fijar Destino',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
