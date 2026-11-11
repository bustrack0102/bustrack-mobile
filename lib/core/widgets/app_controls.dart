import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Casilla de verificación (Checkbox) accesible con etiqueta y área táctil >= 48dp.
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget? labelWidget;
  final String? labelText;
  final String? subtitleText;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelWidget,
    this.labelText,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                  checkColor: AppColors.surfaceWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  side: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (labelWidget != null) labelWidget!,
                    if (labelText != null && labelWidget == null)
                      Text(
                        labelText!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        subtitleText!,
                        style: AppTypography.bodySmall,
                      ),
                    ],
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

/// Interruptor (Switch) con diseño BusTrack y área táctil accesible.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        value ? AppColors.tertiary : AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: value ? AppColors.primary : AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralDark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.tertiary,
                inactiveThumbColor: AppColors.secondary,
                inactiveTrackColor: AppColors.inputBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
