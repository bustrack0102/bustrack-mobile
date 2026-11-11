import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Item de selección para [AppDropdown].
class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Selector y Menú Desplegable accesible y estilizado con la identidad BusTrack.
class AppDropdown<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final bool isEnabled;

  const AppDropdown({
    super.key,
    this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.neutralDark,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        Semantics(
          label: label ?? hint,
          hint: 'Toca para seleccionar una opción',
          child: Container(
            height: 52.0, // Cumple área táctil accesible
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.inputBackground : AppColors.disabled,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : AppColors.inputBorder,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.secondary,
                ),
                dropdownColor: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16.0),
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item.value,
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(item.icon, size: 20, color: AppColors.secondary),
                          const SizedBox(width: 10.0),
                        ],
                        Text(
                          item.label,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: isEnabled ? onChanged : null,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6.0),
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  errorText!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
