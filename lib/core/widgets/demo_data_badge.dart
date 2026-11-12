import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Aviso discreto para datos de demostración.
class DemoDataBadge extends StatelessWidget {
  final String label;
  final String? tooltip;

  const DemoDataBadge({
    super.key,
    this.label = 'DATOS DEMO',
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.primary,
          fontSize: 9,
        ),
      ),
    );

    if (tooltip == null) return badge;
    return Tooltip(message: tooltip!, child: badge);
  }
}
