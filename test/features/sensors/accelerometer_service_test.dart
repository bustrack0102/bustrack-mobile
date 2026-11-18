import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/features/sensors/domain/models/sensor_sample.dart';
import 'package:bustrack_mobile/features/sensors/domain/services/accelerometer_service.dart';

void main() {
  group('AccelerometerService Tests', () {
    late AccelerometerService service;

    setUp(() {
      service = AccelerometerService();
      service.revokeConsent();
    });

    test('1. Inicialmente no tiene consentimiento ni está activo', () {
      expect(service.hasConsent, isFalse);
      expect(service.isActive, isFalse);
    });

    test('2. No inicia captura si no se ha otorgado consentimiento', () {
      service.start();
      expect(service.isActive, isFalse);
    });

    test('3. Otorga consentimiento e inicia captura', () {
      service.grantConsent();
      expect(service.hasConsent, isTrue);

      service.start();
      expect(service.isActive, isTrue);

      service.stop();
      expect(service.isActive, isFalse);
    });

    test('4. Revocar consentimiento detiene captura y limpia estado', () {
      service.grantConsent();
      service.start();
      expect(service.isActive, isTrue);

      service.revokeConsent();
      expect(service.hasConsent, isFalse);
      expect(service.isActive, isFalse);
    });

    test('5. SensorSample calcula magnitud euclidiana correctamente', () {
      final sample = SensorSample(
        x: 3.0,
        y: 4.0,
        z: 0.0,
        timestamp: DateTime.now(),
      );
      expect(sample.magnitude, closeTo(5.0, 0.001));
    });
  });
}
