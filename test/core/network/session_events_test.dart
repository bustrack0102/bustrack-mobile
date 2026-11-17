import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/core/network/session_events.dart';

void main() {
  group('SessionEvents', () {
    test('notifySessionExpired incrementa el notifier en 1', () {
      final before = SessionEvents.sessionExpired.value;
      SessionEvents.notifySessionExpired();
      expect(SessionEvents.sessionExpired.value, before + 1);
    });
  });
}
