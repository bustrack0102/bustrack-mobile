import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demo_mock_data.dart';
import 'demo_route_detail_screen.dart';

/// Pantalla 1 de la Demo: Inicio demostrativo con presentación y búsqueda.
class DemoHomeScreen extends StatefulWidget {
  final VoidCallback onGoToMap;
  final VoidCallback onGoToCompare;

  const DemoHomeScreen({
    super.key,
    required this.onGoToMap,
    required this.onGoToCompare,
  });

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  final _searchController = TextEditingController();
  List<DemoDestinationItem> _filteredDestinations = DemoMockData.destinations;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    final query = text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredDestinations = DemoMockData.destinations;
      } else {
        _filteredDestinations = DemoMockData.destinations
            .where((d) =>
                d.name.toLowerCase().contains(query) ||
                d.category.toLowerCase().contains(query) ||
                d.municipality.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo y presentación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explorando BusTrack',
                        style: AppTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Simulación estática del sistema de transporte',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.2)),
                    ),
                    child: const Text(
                      'DEMO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Buscador de destinos demostrativo
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: 'Buscar destino de ejemplo (ej. Centro, Lago)...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.secondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Botones de acción rápida en Demo
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.map_outlined,
                      title: 'Ver Mapa Demo',
                      subtitle: 'Rutas y paradas',
                      color: AppColors.primary,
                      onTap: widget.onGoToMap,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.compare_arrows_rounded,
                      title: 'Comparar',
                      subtitle: 'Empresas y tarifas',
                      color: AppColors.secondary,
                      onTap: widget.onGoToCompare,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Tarjeta de Asistente IA en Demostración
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: AppColors.surfaceWhite, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Asistente de Viaje IA (Demostración)',
                          style: TextStyle(
                            color: AppColors.surfaceWhite,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Prueba cómo el asistente inteligente recomienda la mejor ruta y tarifa evaluando opciones del corredor metropolitano.',
                      style: TextStyle(
                        color: AppColors.tertiary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDemoAiDialog(context);
                      },
                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                      label: const Text('Consultar recomendación IA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceWhite,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Destinos encontrados o sugeridos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Destinos Populares',
                      style: AppTypography.titleMedium),
                  Text(
                    '${_filteredDestinations.length} encontrados',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ..._filteredDestinations.map((dest) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.inputBorder, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.place_rounded,
                              color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dest.name, style: AppTypography.labelLarge),
                              const SizedBox(height: 2),
                              Text('${dest.category} · ${dest.municipality}',
                                  style: AppTypography.bodySmall),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Ruta recomendada: ${dest.recommendedRoute}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 20),

              // Rutas de demostración disponibles
              const Text('Rutas de Simulación',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              ...DemoMockData.routes.map((route) => Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: AppColors.inputBorder, width: 1),
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
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                route.code,
                                style: const TextStyle(
                                  color: AppColors.surfaceWhite,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              '\$${route.fareMxn.toStringAsFixed(2)} MXN',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(route.name, style: AppTypography.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          'Empresa: ${route.company}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined,
                                size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(route.frequencyText,
                                style: AppTypography.bodySmall),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => DemoRouteDetailScreen(
                                      route: route,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Ver detalle',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoAiDialog(BuildContext context) {
    final originCtrl = TextEditingController(text: 'Terminal Indios Verdes');
    final destCtrl = TextEditingController(text: 'Plaza Independencia (Reloj)');
    Map<String, dynamic>? recommendationResult;

    showStatefulBuilder(BuildContext ctx) {
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Asistente IA Demo',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulación local de recomendaciones asistidas sin consumo de APIs externas ni exposición de datos privados.',
                      style: AppTypography.labelSmall,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: originCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Origen de prueba',
                        isDense: true,
                        prefixIcon: Icon(Icons.trip_origin_rounded,
                            size: 18, color: AppColors.success),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: destCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Destino de prueba',
                        isDense: true,
                        prefixIcon: Icon(Icons.flag_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            recommendationResult =
                                DemoMockData.generateDemoAiRecommendation(
                              origin: originCtrl.text,
                              destination: destCtrl.text,
                            );
                          });
                        },
                        icon: const Icon(Icons.search_rounded, size: 16),
                        label: const Text('Generar recomendación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    if (recommendationResult != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  AppColors.secondary.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recommendationResult!['suggestedRoute']
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendationResult!['itinerary'].toString(),
                              style:
                                  const TextStyle(fontSize: 12, height: 1.35),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Costo estimado: \$${recommendationResult!['costMxn']} MXN · ${recommendationResult!['estimatedMinutes']} min.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        ),
      );
    }

    showStatefulBuilder(context);
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }
}
