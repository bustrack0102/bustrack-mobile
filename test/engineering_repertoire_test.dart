import 'dart:convert';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2 || parts[0].length < 2) {
    return '***';
  }
  final local = parts[0];
  return '${local[0]}***${local[local.length - 1]}@${parts[1]}';
}

Map<String, dynamic> normalizeRoute(Map<String, dynamic> raw) {
  return <String, dynamic>{
    'rutaId': raw['rutaId'] ?? 'DESCONOCIDA',
    'tarifaMxn': (raw['tarifaMxn'] as num?)?.toDouble() ?? 0.0,
    'activa': raw['activa'] ?? true,
  };
}

void main() {
  group('BusTrack Mobile - Repertorio de Ingenieria', () {
    test('Property-based: maskEmail siempre oculta parte central', () {
      final rng = Random(2026);
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

      for (var i = 0; i < 50; i++) {
        final len = 3 + rng.nextInt(12);
        final user = List<String>.generate(
          len,
          (_) => chars[rng.nextInt(chars.length)],
        ).join();
        final email = '$user@uttt.edu.mx';
        final masked = maskEmail(email);

        expect(masked, contains('***'));
        expect(masked, endsWith('@uttt.edu.mx'));
        expect(masked, isNot(equals(email)));
      }
    });

    test('Golden Master: JSON canonico de ruta coincide con base', () {
      final normalized = normalizeRoute(<String, dynamic>{
        'rutaId': 'RUT-001',
        'tarifaMxn': 12,
      });
      final encoded = jsonEncode(normalized);
      expect(
        encoded,
        equals('{"rutaId":"RUT-001","tarifaMxn":12.0,"activa":true}'),
      );
    });

    test('Backwards compatibility: soporta payloads sin campos nuevos', () {
      final legacy = normalizeRoute(<String, dynamic>{'rutaId': 'RUT-OLD'});
      expect(legacy['rutaId'], equals('RUT-OLD'));
      expect(legacy['tarifaMxn'], equals(0.0));
      expect(legacy['activa'], isTrue);
    });

    test('Orden determinista de tarifas y fechas UTC', () {
      final fares = <double>[25.0, 12.0, 18.5]..sort();
      expect(fares, equals(<double>[12.0, 18.5, 25.0]));

      final t1 = DateTime.utc(2026, 12, 31, 23, 59, 59);
      final t2 = t1.add(const Duration(seconds: 2));
      expect(t2.year, equals(2027));
    });

    test('Fuzzing: entradas extremas no rompen maskEmail', () {
      final rng = Random(77);
      for (var i = 0; i < 100; i++) {
        final fuzzed = List<int>.generate(
          rng.nextInt(60),
          (_) => rng.nextInt(127),
        );
        final input = String.fromCharCodes(fuzzed);
        expect(() => maskEmail(input), returnsNormally);
      }
    });
  });
}
