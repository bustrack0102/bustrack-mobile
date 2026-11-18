import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Utilidades y diálogos modales estándar para BusTrack.
class AppDialogs {
  AppDialogs._();

  /// Diálogo de confirmación estándar.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: isDestructive ? AppColors.error : AppColors.neutralDark,
            ),
          ),
          content: Text(
            message,
            style: AppTypography.bodyMedium,
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(
                    cancelLabel,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDestructive ? AppColors.error : AppColors.primary,
                    foregroundColor: AppColors.surfaceWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                  ),
                  child: Text(
                    confirmLabel,
                    style: AppTypography.button,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Diálogo modal formal de Eliminación de Cuenta conforme al estándar de Google Play Store.
  static Future<bool?> showAccountDeletionDialog({
    required BuildContext context,
    required Future<bool> Function(String password) onConfirmDelete,
  }) {
    String password = '';
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isDeleting = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_forever_rounded,
                        color: AppColors.error, size: 22),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      'Eliminar Cuenta',
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Esta acción es definitiva e irreversible en Azure. Se eliminarán:',
                      style: AppTypography.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    _buildBulletPoint(
                        'Tus rutas y paradas favoritas guardadas.'),
                    _buildBulletPoint('Historial de viajes y preferencias.'),
                    _buildBulletPoint(
                        'Tus credenciales y sesiones de acceso seguro.'),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Por seguridad, ingresa tu contraseña para confirmar la baja:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutralDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Contraseña actual',
                        prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
                      ),
                      onChanged: (val) => password = val,
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              actions: [
                if (!isDeleting) ...[
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(
                      'Cancelar',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.secondary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (password.trim().isEmpty) {
                        setState(() => errorMessage =
                            'Ingresa tu contraseña para confirmar');
                        return;
                      }
                      setState(() {
                        isDeleting = true;
                        errorMessage = null;
                      });
                      final success = await onConfirmDelete(password.trim());
                      if (context.mounted) {
                        Navigator.of(dialogContext).pop(success);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.surfaceWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                    ),
                    child: const Text('Eliminar definitivamente'),
                  ),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.error),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}
