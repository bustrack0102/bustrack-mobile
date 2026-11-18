import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

/// Pantalla 6 de la Demo: Perfil demostrativo con información ficticia.
class DemoProfileScreen extends StatefulWidget {
  final VoidCallback onExitDemo;

  const DemoProfileScreen({
    super.key,
    required this.onExitDemo,
  });

  @override
  State<DemoProfileScreen> createState() => _DemoProfileScreenState();
}

class _DemoProfileScreenState extends State<DemoProfileScreen> {
  bool _mockNotifications = true;
  bool _mockHighContrast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Perfil Demostrativo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de usuario demo
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person_outline_rounded,
                            color: AppColors.secondary, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuario Demostración',
                              style: AppTypography.titleMedium),
                          SizedBox(height: 2),
                          Text('pasajero.demo@bustrack.app',
                              style: AppTypography.bodySmall),
                          SizedBox(height: 4),
                          Text('Cuenta simulada (Solo lectura)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Estadísticas de muestra
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                        '14', 'Viajes explorados', Icons.commute_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                        '3', 'Rutas guardadas', Icons.bookmark_border_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Preferencias visuales demostrativas
              const Text('Preferencias Visuales (Demostración)',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              Material(
                color: AppColors.surfaceWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Alertas de frecuencias',
                          style: AppTypography.bodyMedium),
                      subtitle: const Text('Simulación de notificaciones',
                          style: AppTypography.labelSmall),
                      activeColor: AppColors.primary,
                      value: _mockNotifications,
                      onChanged: (val) =>
                          setState(() => _mockNotifications = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Modo alto contraste',
                          style: AppTypography.bodyMedium),
                      subtitle: const Text('Mejora visual de paradas',
                          style: AppTypography.labelSmall),
                      activeColor: AppColors.primary,
                      value: _mockHighContrast,
                      onChanged: (val) =>
                          setState(() => _mockHighContrast = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Aclaración sobre sensores y backend
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: AppColors.secondary, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Restricciones de la Demo: No se recopilan datos del acelerómetro, no se solicitan permisos del teléfono ni se conectan servicios de base de datos.',
                        style: TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: AppColors.neutralDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Crear una cuenta real en BusTrack',
                icon: Icons.app_registration_rounded,
                onPressed: widget.onExitDemo,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.titleMedium),
              Text(label, style: AppTypography.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
