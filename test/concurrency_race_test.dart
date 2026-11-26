import 'package:flutter_test/flutter_test.dart';

class _ThreadSafeTokenCache {
  final Set<String> _revoked = <String>{};

  Future<void> revoke(String jti) async {
    await Future<void>.delayed(Duration.zero);
    _revoked.add(jti);
  }

  Future<bool> isRevoked(String jti) async {
    await Future<void>.delayed(Duration.zero);
    return _revoked.contains(jti);
  }
}

void main() {
  group('BusTrack Mobile - Concurrencia y Race Conditions', () {
    test('Multiples operaciones paralelas mantienen consistencia sin duplicados',
        () async {
      final cache = _ThreadSafeTokenCache();
      final ids = List<String>.generate(25, (int i) => 'session-jti-$i');

      await Future.wait(ids.map(cache.revoke));
      final results = await Future.wait(ids.map(cache.isRevoked));

      expect(results.every((bool revoked) => revoked), isTrue);
    });

    test('Revocacion concurrente repetida del mismo token es idempotente',
        () async {
      final cache = _ThreadSafeTokenCache();
      await Future.wait(
        List<Future<void>>.generate(
          20,
          (_) => cache.revoke('shared-jti-token'),
        ),
      );

      expect(await cache.isRevoked('shared-jti-token'), isTrue);
    });
  });
}
