import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demo_mock_data.dart';

/// Pantalla 4 de la Demo: Detalle de ruta demostrativa.
class DemoRouteDetailScreen extends StatefulWidget {
  final DemoRouteItem route;

  const DemoRouteDetailScreen({
    super.key,
    required this.route,
  });

  @override
  State<DemoRouteDetailScreen> createState() => _DemoRouteDetailScreenState();
}

class _DemoRouteDetailScreenState extends State<DemoRouteDetailScreen> {
  String? _subidaStopId;
  String? _bajadaStopId;
  double? _calculatedFare;

  @override
  void initState() {
    super.initState();
    if (widget.route.stops.isNotEmpty) {
      _subidaStopId = widget.route.stops.first.id;
      _bajadaStopId = widget.route.stops.last.id;
      _calculatedFare = widget.route.fareMxn;
    }
  }

  void _calculateDemoFare() {
    if (_subidaStopId == null || _bajadaStopId == null) return;
    final startIndex =
        widget.route.stops.indexWhere((s) => s.id == _subidaStopId);
    final endIndex =
        widget.route.stops.indexWhere((s) => s.id == _bajadaStopId);

    if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
      setState(() => _calculatedFare = widget.route.fareMxn);
      return;
    }

    final stopCount = (endIndex - startIndex);
    final fare = 8.0 + (stopCount * 2.5);
    setState(() => _calculatedFare = fare.clamp(8.0, widget.route.fareMxn));
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(route.code),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de datos de demostración
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.secondary, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Vista demostrativa estática. Los horarios y tarifas son ejemplos para exploración previa al registro.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cabecera de la ruta
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.inputBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            route.code,
                            style: const TextStyle(
                              color: AppColors.surfaceWhite,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          route.transportMode,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(route.name, style: AppTypography.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      'Empresa concesionaria: ${route.company}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('Tarifa base',
                            '\$${route.fareMxn.toStringAsFixed(2)}'),
                        _buildStatColumn('Frecuencia', route.frequencyText),
                        _buildStatColumn(
                            'Recorrido aprox.', route.estimatedDuration),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calculadora de tarifa demostrativa
              const Text('Calculadora de Tarifa por Tramo (Simulación)',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _subidaStopId,
                      decoration: const InputDecoration(
                        labelText: 'Parada de subida',
                        prefixIcon: Icon(Icons.departure_board_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      items: route.stops
                          .map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.name,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => _subidaStopId = val);
                        _calculateDemoFare();
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _bajadaStopId,
                      decoration: const InputDecoration(
                        labelText: 'Parada de bajada',
                        prefixIcon: Icon(Icons.place_rounded,
                            color: AppColors.secondary, size: 20),
                      ),
                      items: route.stops
                          .map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.name,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => _bajadaStopId = val);
                        _calculateDemoFare();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_calculatedFare != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Costo estimado del tramo:',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '\$${_calculatedFare!.toStringAsFixed(2)} MXN',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Secuencia ordenada de paradas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Paradas Registradas',
                      style: AppTypography.titleMedium),
                  Text(
                    '${route.stops.length} paradas',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: route.stops.length,
                itemBuilder: (context, index) {
                  final stop = route.stops[index];
                  final isFirst = index == 0;
                  final isLast = index == route.stops.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isFirst
                                  ? AppColors.primary
                                  : (isLast
                                      ? AppColors.secondary
                                      : AppColors.surfaceWhite),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isFirst || isLast
                                    ? Colors.transparent
                                    : AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${stop.order}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isFirst || isLast
                                      ? AppColors.surfaceWhite
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 48,
                              color: AppColors.inputBorder,
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.inputBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stop.name, style: AppTypography.labelLarge),
                              const SizedBox(height: 2),
                              Text(stop.address,
                                  style: AppTypography.bodySmall),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded,
                                      size: 13, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Horario: ${stop.schedule}',
                                    style: AppTypography.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Sección de Reseñas y Calificaciones de demostración
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Opiniones de Pasajeros',
                      style: AppTypography.titleMedium),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${route.reviews.isNotEmpty ? (route.reviews.map((r) => r.stars).reduce((a, b) => a + b) / route.reviews.length).toStringAsFixed(1) : "5.0"} (Demo)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (route.reviews.isEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: const Center(
                    child: Text(
                      'Sé el primero en calificar esta ruta en modo demostración.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                )
              else
                ...route.reviews.map((rev) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rev.userName,
                                  style: AppTypography.labelLarge),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < rev.stars
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 14,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(rev.comment, style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Text(rev.date, style: AppTypography.labelSmall),
                        ],
                      ),
                    )),
              const SizedBox(height: 12),

              // Botón simulado para calificar en demo
              OutlinedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Calificar en Modo Demo'),
                      content: const Text(
                        'En el modo demostración tu calificación se registra localmente y no afecta la base de datos real de usuarios.',
                        style: AppTypography.bodySmall,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Entendido'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.rate_review_outlined, size: 16),
                label: const Text('Añadir reseña de prueba'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.neutralDark)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
