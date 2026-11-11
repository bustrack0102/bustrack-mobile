import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tarjeta base del sistema de diseño BusTrack con radio 16dp y elevación discreta.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final double elevation;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor = AppColors.surfaceWhite,
    this.borderColor = AppColors.inputBorder,
    this.onTap,
    this.elevation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final Widget cardBody = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: elevation > 0
            ? [
                const BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}
