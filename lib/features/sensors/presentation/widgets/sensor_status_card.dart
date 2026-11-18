import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/sensor_sample.dart';
import '../../domain/services/accelerometer_service.dart';
import 'accelerometer_consent_dialog.dart';

/// Tarjeta de estado en tiempo real del acelerómetro y clasificador ML.
class SensorStatusCard extends StatefulWidget {
  final String? routeId;

  const SensorStatusCard({super.key, this.routeId});

  @override
  State<SensorStatusCard> createState() => _SensorStatusCardState();
}

class _SensorStatusCardState extends State<SensorStatusCard> {
  final _service = AccelerometerService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  Color _getPatternColor(MovementPattern pattern) {
    switch (pattern) {
      case MovementPattern.dispositivoEnReposo:
        return const Color(0xFF2563EB);
      case MovementPattern.movimientoContinuo:
        return AppColors.success;
      case MovementPattern.cambioDeMovimiento:
        return const Color(0xFFD97706);
      case MovementPattern.posibleDetencion:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConsent = _service.hasConsent;
    final isActive = _service.isActive;
    final result = _service.currentResult;
    final patternColor = _getPatternColor(result.pattern);

    return Container(
      padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: patternColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.sensors_rounded,
                        color: patternColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Acelerómetro & ML',
                          style: AppTypography.titleSmall),
                      Text('Detección de patrones de viaje',
                          style: AppTypography.labelSmall),
                    ],
                  ),
                ],
              ),
              Switch(
                value: isActive,
                activeColor: AppColors.primary,
                onChanged: (val) async {
                  if (val) {
                    if (!hasConsent) {
                      final granted =
                          await AccelerometerConsentDialog.show(context);
                      if (granted == true) {
                        _service.start();
                      }
                    } else {
                      _service.start();
                    }
                  } else {
                    _service.stop();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isActive) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: patternColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: patternColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: patternColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Patrón: ${result.pattern.label} (${(result.confidence * 100).toInt()}% conf.)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: patternColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              result.explanation,
              style: AppTypography.bodySmall.copyWith(fontSize: 11),
            ),
          ] else ...[
            Text(
              hasConsent
                  ? 'Sensor pausado. Activa el interruptor para clasificar patrones durante el viaje.'
                  : 'Requiere consentimiento explícito para procesar muestras triaxiales con Machine Learning.',
              style: AppTypography.bodySmall.copyWith(fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
