import 'package:flutter/material.dart';

/// Paleta de colores oficial de BusTrack según especificación UI/UX.
class AppColors {
  AppColors._();

  /// Primario: Rojo BusTrack (#CF1818)
  static const Color primary = Color(0xFFCF1818);

  /// Primario Oscuro para estados hover/pressed (#9B1010)
  static const Color primaryDark = Color(0xFF9B1010);

  /// Secundario: Tonos complementarios (#906D6D)
  static const Color secondary = Color(0xFF906D6D);

  /// Terciario: Fondos suaves y destacados (#FFD0C5)
  static const Color tertiary = Color(0xFFFFD0C5);

  /// Neutro: Textos y elementos oscuros (#333333)
  static const Color neutralDark = Color(0xFF333333);

  /// Blanco: Fondos principales (#FFFFFF)
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Fondo para campos de texto (#F8FAFC)
  static const Color inputBackground = Color(0xFFF8FAFC);

  /// Borde para campos de texto (#E2E8F0)
  static const Color inputBorder = Color(0xFFE2E8F0);

  /// Verde para estados activos y confirmaciones (#059669)
  static const Color success = Color(0xFF059669);

  /// Naranja/Ámbar para advertencias y avisos amigables (#D97706)
  static const Color warning = Color(0xFFD97706);

  /// Rojo de alerta para errores y validaciones fallidas (#DC2626)
  static const Color error = Color(0xFFDC2626);

  /// Gris pizarra para banners de estado sin conexión (#475569)
  static const Color offline = Color(0xFF475569);

  /// Gris suave para bordes o componentes deshabilitados (#E2E8F0)
  static const Color disabled = Color(0xFFE2E8F0);

  /// Gris de texto para elementos deshabilitados (#94A3B8)
  static const Color disabledText = Color(0xFF94A3B8);
}

