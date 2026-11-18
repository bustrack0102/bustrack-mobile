import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Botón principal rojo intenso (#CF1B1B) con bordes redondeados y soporte para
/// estados: normal, presionado, deshabilitado y cargando.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 52.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final baseColor = backgroundColor ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: baseColor,
          foregroundColor: AppColors.surfaceWhite,
          disabledBackgroundColor: const Color(0xFFE2E8F0),
          disabledForegroundColor: AppColors.disabledText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isEnabled ? 2 : 0,
          shadowColor: baseColor.withValues(alpha: 0.35),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.surfaceWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTypography.button.copyWith(
                      fontSize: 15,
                      color: isEnabled
                          ? AppColors.surfaceWhite
                          : AppColors.disabledText,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      icon,
                      size: 19,
                      color: isEnabled
                          ? AppColors.surfaceWhite
                          : AppColors.disabledText,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
