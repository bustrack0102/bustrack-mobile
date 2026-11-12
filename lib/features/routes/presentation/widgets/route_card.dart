import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../domain/models/transport_route.dart';

/// Tarjeta reutilizable de ruta encontrada.
class RouteCard extends StatelessWidget {
  final TransportRoute route;
  final VoidCallback onDetail;
  final VoidCallback? onSelect;
  final bool isSelected;

  const RouteCard({
    super.key,
    required this.route,
    required this.onDetail,
    this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onSelect,
      borderColor: isSelected ? AppColors.primary : AppColors.inputBorder,
      elevation: isSelected ? 2 : 0,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  route.code,
                  style: const TextStyle(
                    color: AppColors.surfaceWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            route.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (route.isDemo) const DemoDataBadge(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      route.companyName,
                      style: AppTypography.bodySmall.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    route.fareLabel,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (route.nextArrivalMinutes != null)
                    Text(
                      'Llega ~${route.nextArrivalMinutes} min',
                      style: AppTypography.bodySmall.copyWith(fontSize: 10),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.trip_origin_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${route.originName} → ${route.destinationName}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.neutralDark,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (route.frequencyMinutes != null)
                _MetaChip(
                  icon: Icons.schedule_rounded,
                  label: 'Cada ${route.frequencyMinutes} min',
                ),
              if (route.estimatedDurationMinutes != null)
                _MetaChip(
                  icon: Icons.timelapse_rounded,
                  label: '${route.estimatedDurationMinutes} min',
                ),
              if (route.distanceKm != null)
                _MetaChip(
                  icon: Icons.straighten_rounded,
                  label: '${route.distanceKm!.toStringAsFixed(1)} km',
                ),
              if (route.status != null)
                _MetaChip(
                  icon: Icons.info_outline_rounded,
                  label: route.status!.label,
                  highlight: route.status == RouteStatus.suspended,
                ),
              if (route.occupancy != null)
                _MetaChip(
                  icon: Icons.groups_2_outlined,
                  label: route.occupancy!.label,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onDetail,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(48, 40),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver detalle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.error : AppColors.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFE4E6) : AppColors.inputBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlight ? const Color(0xFFFECDD3) : AppColors.inputBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
