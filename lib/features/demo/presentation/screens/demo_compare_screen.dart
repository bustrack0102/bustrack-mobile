import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demo_mock_data.dart';

/// Pantalla 5 de la Demo: Comparación de alternativas de transporte.
class DemoCompareScreen extends StatelessWidget {
  const DemoCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Comparar Alternativas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.15)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.compare_rounded,
                        color: AppColors.secondary, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comparativa de Transporte',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Evalúa opciones de transporte metropolitano según costo, tiempo de recorrido y frecuencia de corrida.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neutralDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Opciones Evaluadas para el Corredor Central',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: 12),
              ...DemoMockData.routes.map((route) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.inputBorder),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            '\$${route.fareMxn.toStringAsFixed(2)} MXN',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(route.name, style: AppTypography.titleSmall),
                      const SizedBox(height: 4),
                      Text('Medio: ${route.transportMode}',
                          style: AppTypography.bodySmall),
                      Text('Empresa: ${route.company}',
                          style: AppTypography.bodySmall),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.speed_rounded,
                                  size: 15, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('Tiempo: ${route.estimatedDuration}',
                                  style: AppTypography.labelSmall),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.repeat_rounded,
                                  size: 15, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(route.frequencyText,
                                  style: AppTypography.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              const Text(
                'Directorio de Empresas Concesionarias (Demo)',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: 12),
              ...DemoMockData.companies.map((company) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            company.acronym,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(company.name, style: AppTypography.labelLarge),
                            const SizedBox(height: 2),
                            Text(
                              'Flota: ${company.fleetType} · ${company.totalUnits} uds.',
                              style: AppTypography.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cobertura: ${company.coverageArea}',
                              style: AppTypography.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 15, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            company.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        color: Color(0xFFD97706), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Recomendación inteligente: Para traslados rápidos en horas pico, la línea L-01 y el Troncal H-01 cuentan con carril exclusivo.',
                        style: TextStyle(fontSize: 11, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
