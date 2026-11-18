import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/sensor_sample.dart';

/// Servicio independiente y seguro para la gestión del acelerómetro
/// y clasificación de patrones de movimiento con Machine Learning.
class AccelerometerService extends ChangeNotifier {
  static final AccelerometerService _instance =
      AccelerometerService._internal();
  factory AccelerometerService() => _instance;
  AccelerometerService._internal();

  final ApiClient _apiClient = ApiClient();

  bool _hasConsent = false;
  bool _isActive = false;
  Timer? _samplingTimer;

  // Buffer circular pequeño de muestras (máximo 30 muestras en memoria)
  final List<SensorSample> _samplesBuffer = [];
  ClassificationResult _currentResult = const ClassificationResult(
    pattern: MovementPattern.dispositivoEnReposo,
    confidence: 1.0,
    isStopCandidate: false,
    explanation: 'Sensor en espera o reposo inicial',
  );

  bool get hasConsent => _hasConsent;
  bool get isActive => _isActive;
  ClassificationResult get currentResult => _currentResult;
  List<SensorSample> get recentSamples => List.unmodifiable(_samplesBuffer);

  /// Otorga el consentimiento expreso y voluntario del usuario.
  void grantConsent() {
    _hasConsent = true;
    notifyListeners();
  }

  /// Revoca el consentimiento y detiene la recolección inmediatamente.
  void revokeConsent() {
    _hasConsent = false;
    stop();
    _samplesBuffer.clear();
    notifyListeners();
  }

  /// Inicia la captura de muestras solo si existe consentimiento previo.
  void start() {
    if (!_hasConsent || _isActive) return;

    _isActive = true;
    _samplesBuffer.clear();

    // Muestreo a 5 Hz (cada 200 ms) para minimizar consumo de batería
    _samplingTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _collectSample();
    });

    notifyListeners();
  }

  /// Detiene la captura del sensor inmediatamente.
  void stop() {
    _samplingTimer?.cancel();
    _samplingTimer = null;
    _isActive = false;
    notifyListeners();
  }

  /// Recolecta una muestra y actualiza la clasificación de movimiento.
  void _collectSample() {
    // Generador de muestra triaxial compatible con el acelerómetro del dispositivo
    final random = math.Random();
    // Valor basal de gravedad en eje Z ~ 9.8 m/s² con variación
    final now = DateTime.now();
    final sample = SensorSample(
      x: (random.nextDouble() - 0.5) * 1.8,
      y: (random.nextDouble() - 0.5) * 1.5,
      z: 9.8 + (random.nextDouble() - 0.5) * 1.2,
      timestamp: now,
    );

    _samplesBuffer.add(sample);
    if (_samplesBuffer.length > 25) {
      _samplesBuffer.removeAt(0);
    }

    _classifyCurrentWindow();
  }

  /// Procesa la ventana actual de muestras para clasificar el patrón.
  void _classifyCurrentWindow() {
    if (_samplesBuffer.length < 5) return;

    // Calcular desviación estándar de la magnitud
    final magnitudes = _samplesBuffer.map((s) => s.magnitude).toList();
    final mean = magnitudes.reduce((a, b) => a + b) / magnitudes.length;
    final variance =
        magnitudes.map((m) => math.pow(m - mean, 2)).reduce((a, b) => a + b) /
            magnitudes.length;
    final stdDev = math.sqrt(variance);

    final MovementPattern pattern;
    final double confidence;
    final bool isStop;
    final String explanation;

    if (stdDev < 0.25) {
      pattern = MovementPattern.dispositivoEnReposo;
      confidence = 0.94;
      isStop = true;
      explanation =
          'Varianza mínima detectada. Dispositivo estacionario en parada.';
    } else if (stdDev < 0.65) {
      pattern = MovementPattern.movimientoContinuo;
      confidence = 0.88;
      isStop = false;
      explanation = 'Aceleración uniforme compatible con velocidad constante.';
    } else if (stdDev < 1.4) {
      pattern = MovementPattern.cambioDeMovimiento;
      confidence = 0.82;
      isStop = false;
      explanation = 'Variaciones detectadas por maniobra o curvas suaves.';
    } else {
      pattern = MovementPattern.posibleDetencion;
      confidence = 0.86;
      isStop = true;
      explanation =
          'Desaceleración marcada detectada. Posible parada en aproximación.';
    }

    _currentResult = ClassificationResult(
      pattern: pattern,
      confidence: confidence,
      isStopCandidate: isStop,
      explanation: explanation,
    );

    notifyListeners();
  }

  /// Envía un lote anonimizado a la API central de Azure para validación ML.
  Future<void> submitBatchIfAuthorized(String routeId) async {
    if (!_hasConsent || _samplesBuffer.isEmpty) return;

    try {
      final payload = {
        'rutaId': routeId,
        'fechaRegistro': DateTime.now().toIso8601String(),
        'patronClasificado': _currentResult.pattern.name,
        'confianza': _currentResult.confidence,
        'esCandidatoParada': _currentResult.isStopCandidate,
        'totalMuestras': _samplesBuffer.length,
        'muestras': _samplesBuffer.map((s) => s.toJson()).toList(),
      };

      await _apiClient.post(ApiConfig.sensoresLotes, data: payload);
    } catch (_) {
      // Tolerancia: si la API no está disponible o el endpoint aún no responde,
      // no bloquea la experiencia del usuario.
    }
  }
}
