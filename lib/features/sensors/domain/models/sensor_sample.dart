import 'dart:math' as math;

/// Clasificación de patrones de movimiento según el modelo de Machine Learning.
enum MovementPattern {
  /// Dispositivo en reposo / quieto (ej. autobús detenido en parada)
  dispositivoEnReposo(
      'Dispositivo en reposo', 'El transporte se encuentra detenido'),

  /// Movimiento continuo y regular a velocidad de crucero
  movimientoContinuo(
      'Movimiento continuo', 'Desplazamiento estable en la ruta'),

  /// Cambio de movimiento (frenado suave, aceleración o giro)
  cambioDeMovimiento('Cambio de movimiento', 'Variación en la aceleración'),

  /// Posible detención detectada para análisis de parada
  posibleDetencion(
      'Posible detención', 'Desaceleración compatible con abordaje/descenso');

  final String label;
  final String description;

  const MovementPattern(this.label, this.description);
}

/// Muestra de lectura triaxial del acelerómetro.
class SensorSample {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const SensorSample({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Magnitud euclidiana de la aceleración: sqrt(x² + y² + z²).
  double get magnitude => math.sqrt((x * x) + (y * y) + (z * z));

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'timestamp': timestamp.toIso8601String(),
      'magnitude': magnitude,
    };
  }
}

/// Resultado de clasificación de un lote por el modelo ML.
class ClassificationResult {
  final MovementPattern pattern;
  final double confidence;
  final bool isStopCandidate;
  final String explanation;

  const ClassificationResult({
    required this.pattern,
    required this.confidence,
    required this.isStopCandidate,
    required this.explanation,
  });
}
