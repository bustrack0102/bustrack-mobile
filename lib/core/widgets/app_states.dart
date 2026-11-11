import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_buttons.dart';

/// Vista de Estado Vacío (Empty State) para listados de rutas, paradas o búsquedas.
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Icon(icon, size: 36, color: AppColors.secondary),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(color: AppColors.neutralDark),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.secondary),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 20.0),
              AppSecondaryButton(
                text: actionLabel!,
                onPressed: onActionPressed,
                height: 44.0,
                width: 200.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Vista de Estado Sin Conexión (Offline State) con opción de reintentar.
class OfflineStateWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const OfflineStateWidget({
    super.key,
    required this.onRetry,
    this.message = 'No pudimos conectar con los servidores de BusTrack. Verifica tu conexión a internet.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 36, color: AppColors.offline),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Sin Conexión a Internet',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(color: AppColors.neutralDark),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.secondary),
            ),
            const SizedBox(height: 20.0),
            AppPrimaryButton(
              text: 'Reintentar',
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
              height: 46.0,
              width: 180.0,
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner discreto de conexión fuera de línea para colocar en la parte superior del Scaffold.
class OfflineBannerWidget extends StatelessWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: AppColors.offline,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.surfaceWhite),
          const SizedBox(width: 8.0),
          Text(
            'Modo sin conexión • Mostrando datos locales de rutas',
            style: AppTypography.caption.copyWith(color: AppColors.surfaceWhite),
          ),
        ],
      ),
    );
  }
}

/// Helper para desplegar SnackBars accesibles y estilizados con la identidad visual.
class AppFeedback {
  AppFeedback._();

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: AppColors.surfaceWhite),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.surfaceWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.surfaceWhite),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.surfaceWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
