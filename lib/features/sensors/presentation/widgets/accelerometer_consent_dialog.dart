import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/services/accelerometer_service.dart';

/// Diálogo de consentimiento informado y explícito para el sensor acelerómetro.
class AccelerometerConsentDialog extends StatelessWidget {
  const AccelerometerConsentDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => const AccelerometerConsentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.sensors_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Uso del Acelerómetro',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BusTrack contempla el uso del sensor acelerómetro para clasificar patrones de movimiento y apoyar en la detección de posibles paradas de autobús mediante Machine Learning.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 14),
            _buildCheckItem(
              Icons.check_circle_outline_rounded,
              'Finalidad: Clasificar si el vehículo está en reposo o en movimiento.',
            ),
            _buildCheckItem(
              Icons.not_listed_location_outlined,
              'Privacidad estricta: NO deduce tu ubicación ni coordenadas GPS.',
            ),
            _buildCheckItem(
              Icons.speed_outlined,
              'Restricción técnica: NO calcula velocidades exactas del vehículo.',
            ),
            _buildCheckItem(
              Icons.lock_clock_outlined,
              'Consentimiento revocable: Puedes desactivarlo en cualquier momento desde tu Perfil.',
            ),
            const SizedBox(height: 10),
            const Text(
              '¿Deseas autorizar la captura de muestras de aceleración durante tus viajes?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralDark,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No permitir',
              style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: () {
            AccelerometerService().grantConsent();
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Aceptar y Activar'),
        ),
      ],
    );
  }

  Widget _buildCheckItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child:
                Text(text, style: const TextStyle(fontSize: 11, height: 1.3)),
          ),
        ],
      ),
    );
  }
}
