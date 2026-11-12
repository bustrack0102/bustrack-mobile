import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../routes/data/demo_route_repository.dart';
import '../../../routes/domain/repositories/route_repository.dart';
import '../../../routes/presentation/screens/route_detail_screen.dart';
import '../../domain/journey_history_service.dart';
import '../../domain/models/journey_record.dart';

/// Pantalla 9 – Historial de viajes y búsquedas.
class TripHistoryScreen extends StatefulWidget {
  final JourneyHistoryService? historyService;
  final RouteRepository? repository;
  final VoidCallback? onExplore;

  const TripHistoryScreen({
    super.key,
    this.historyService,
    this.repository,
    this.onExplore,
  });

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  late final JourneyHistoryService _historyService;
  late final RouteRepository _repository;

  @override
  void initState() {
    super.initState();
    _historyService = widget.historyService ?? JourneyHistoryService.instance;
    _repository = widget.repository ?? const DemoRouteRepository();
  }

  Future<void> _openSearchRoute(RouteSearchRecord record) async {
    final routeId = record.routeId;
    if (routeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta búsqueda no tiene una ruta asociada.'),
        ),
      );
      return;
    }

    try {
      final route = await _repository.getRouteById(routeId);
      if (!mounted) return;
      if (route == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('La ruta ya no está disponible en la fuente de datos.'),
          ),
        );
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => RouteDetailScreen(route: route),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el detalle de la búsqueda.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: ListenableBuilder(
        listenable: _historyService,
        builder: (context, _) {
          final searches = _historyService.searches;
          final journeys = _historyService.journeys;

          if (searches.isEmpty && journeys.isEmpty) {
            return EmptyStateWidget(
              title: 'Aún no tienes historial',
              message:
                  'Tus búsquedas y recorridos de esta sesión aparecerán aquí. '
                  'La API central todavía no expone historial remoto.',
              icon: Icons.history_rounded,
              actionLabel: 'Explorar rutas',
              onActionPressed: widget.onExplore,
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const _LocalOnlyNotice(),
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Búsquedas recientes',
                count: searches.length,
              ),
              const SizedBox(height: 8),
              if (searches.isEmpty)
                const _EmptySectionText(
                  text: 'Todavía no registraste búsquedas.',
                )
              else
                for (final search in searches) ...[
                  _SearchHistoryCard(
                    record: search,
                    onTap: () => _openSearchRoute(search),
                  ),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 10),
              _SectionHeader(
                title: 'Viajes realizados',
                count: journeys.length,
              ),
              const SizedBox(height: 8),
              if (journeys.isEmpty)
                const _EmptySectionText(
                  text: 'Todavía no registraste recorridos.',
                )
              else
                for (final journey in journeys) ...[
                  _JourneyHistoryCard(record: journey),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTypography.titleMedium)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Text(
            '$count',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchHistoryCard extends StatelessWidget {
  final RouteSearchRecord record;
  final VoidCallback onTap;

  const _SearchHistoryCard({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 18,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.origin} → ${record.destination}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(record.searchedAt),
                  style: AppTypography.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          if (record.routeCode != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                record.routeCode!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 9,
                ),
              ),
            ),
          ],
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _JourneyHistoryCard extends StatelessWidget {
  final JourneyRecord record;

  const _JourneyHistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (record.status) {
      JourneyStatus.completed => AppColors.success,
      JourneyStatus.inProgress => AppColors.warning,
      JourneyStatus.cancelled => AppColors.error,
    };

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record.routeCode,
                  style: const TextStyle(
                    color: AppColors.surfaceWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.routeName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  record.status.label,
                  style: AppTypography.caption.copyWith(
                    color: statusColor,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${record.origin} → ${record.destination}',
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatDateTime(record.startedAt)}'
            '${record.finishedAt == null ? '' : ' · Fin ${_formatDateTime(record.finishedAt!)}'}',
            style: AppTypography.bodySmall.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _LocalOnlyNotice extends StatelessWidget {
  const _LocalOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.smartphone_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Historial local de esta sesión. La API central aún no expone '
              'historial de búsquedas ni de viajes.',
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySectionText extends StatelessWidget {
  final String text;

  const _EmptySectionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: AppTypography.bodySmall),
    );
  }
}

String _formatDateTime(DateTime value) {
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(value.day)}/${two(value.month)}/${value.year} · '
      '${two(value.hour)}:${two(value.minute)}';
}
