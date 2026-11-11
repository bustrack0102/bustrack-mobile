import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/live_status_card.dart';

/// Pantalla Principal / Modo Demostración de BusTrack.
class HomeDemoScreen extends StatelessWidget {
  final bool isDemoMode;
  final VoidCallback onLogout;

  const HomeDemoScreen({
    super.key,
    this.isDemoMode = false,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutralDark,
            ),
            children: [
              TextSpan(text: 'Bus'),
              TextSpan(
                text: 'Track',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        actions: [
          if (isDemoMode)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'MODO DEMO',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.secondary),
            onPressed: onLogout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDemoMode
                                ? 'Explorando en Modo Demostración'
                                : '¡Sesión Iniciada con Éxito!',
                            style: AppTypography.bodyMedium
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Conexión activa con la API Central de BusTrack.',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LiveStatusCard(),
              const SizedBox(height: 24),
              const Text(
                'Rutas Metropolitanas Próximas',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _buildRouteCard(
                      lineNumber: 'Ruta 102',
                      originDestination:
                          'Terminal Central → Campus Universitario',
                      frequency: 'Cada 8 min',
                      fare: '\$10.00 MXN',
                    ),
                    const SizedBox(height: 10),
                    _buildRouteCard(
                      lineNumber: 'Ruta 204',
                      originDestination: 'Plaza Hidalgo → Parque Industrial',
                      frequency: 'Cada 12 min',
                      fare: '\$10.00 MXN',
                    ),
                    const SizedBox(height: 10),
                    _buildRouteCard(
                      lineNumber: 'Ruta 05 Express',
                      originDestination: 'Estación Norte → Corredor Poniente',
                      frequency: 'Cada 15 min',
                      fare: '\$12.50 MXN',
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

  Widget _buildRouteCard({
    required String lineNumber,
    required String originDestination,
    required String frequency,
    required String fare,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              lineNumber,
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
                Text(
                  originDestination,
                  style: AppTypography.bodyMedium
                      .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Frecuencia: $frequency • Tarifa: $fare',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
