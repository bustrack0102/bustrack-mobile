import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../sensors/domain/services/accelerometer_service.dart';
import '../../../sensors/presentation/widgets/accelerometer_consent_dialog.dart';
import '../../data/consentimientos_remote_data_source.dart';

/// Pantalla para gestionar y transparentar los permisos del dispositivo (Sección 6.4).
class PermissionsManagerScreen extends StatefulWidget {
  const PermissionsManagerScreen({super.key});

  @override
  State<PermissionsManagerScreen> createState() =>
      _PermissionsManagerScreenState();
}

class _PermissionsManagerScreenState extends State<PermissionsManagerScreen> {
  final _sensorService = AccelerometerService();
  bool _locationGranted = true;
  bool _notificationsGranted = false;

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String purpose,
    required String status,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
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
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleSmall),
                    Text('Estado: $status',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isEnabled
                              ? AppColors.success
                              : AppColors.textMuted,
                        )),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                activeColor: AppColors.primary,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 4),
          Text(
            purpose,
            style: AppTypography.bodySmall.copyWith(fontSize: 11, height: 1.3),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Administrador de Permisos'),
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
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.15)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security_rounded,
                        color: AppColors.secondary, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Control estricto de privacidad: BusTrack solo solicita los permisos esenciales cuando tú lo decides.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutralDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Permisos del Dispositivo',
                  style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              // 1. Ubicación
              _buildPermissionItem(
                icon: Icons.location_on_outlined,
                title: 'Ubicación en primer plano',
                purpose:
                    'Utilizada exclusivamente para centrar el mapa y sugerirte paradas cercanas cuando abres la app. No se recopila en segundo plano ni rastrea tus traslados.',
                status: _locationGranted ? 'Autorizado' : 'Inactivo',
                isEnabled: _locationGranted,
                onChanged: (val) => setState(() => _locationGranted = val),
              ),

              // 2. Acelerómetro
              ListenableBuilder(
                listenable: _sensorService,
                builder: (context, _) {
                  final hasConsent = _sensorService.hasConsent;
                  return _buildPermissionItem(
                    icon: Icons.sensors_rounded,
                    title: 'Sensor Acelerómetro',
                    purpose:
                        'Captura muestras de movimiento para que el modelo de Machine Learning reconozca posibles detenciones del autobús. No deduce ubicación ni velocidad exacta.',
                    status: hasConsent ? 'Consentimiento activo' : 'Revocado',
                    isEnabled: hasConsent,
                    onChanged: (val) async {
                      if (val) {
                        final granted =
                            await AccelerometerConsentDialog.show(context);
                        if (granted == true) {
                          try {
                            await ConsentimientosRemoteDataSource()
                                .otorgarConsentimiento();
                          } catch (_) {}
                        }
                      } else {
                        _sensorService.revokeConsent();
                        try {
                          await ConsentimientosRemoteDataSource()
                              .revocarConsentimiento();
                        } catch (_) {}
                      }
                      setState(() {});
                    },
                  );
                },
              ),

              // 3. Notificaciones
              _buildPermissionItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notificaciones del sistema',
                purpose:
                    'Avisos sobre cambios en horarios de corridas, incidencias reportadas en tu ruta favorita o confirmación de verificación de cuenta.',
                status: _notificationsGranted ? 'Activo' : 'Desactivado',
                isEnabled: _notificationsGranted,
                onChanged: (val) => setState(() => _notificationsGranted = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
