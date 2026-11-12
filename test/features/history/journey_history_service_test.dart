import 'package:bustrack_mobile/features/history/domain/journey_history_service.dart';
import 'package:bustrack_mobile/features/history/domain/models/journey_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JourneyHistoryService', () {
    late JourneyHistoryService service;

    setUp(() {
      service = JourneyHistoryService();
    });

    test('inicia vacío', () {
      expect(service.isEmpty, isTrue);
      expect(service.searches, isEmpty);
      expect(service.journeys, isEmpty);
    });

    test('registra búsquedas con valores por defecto y notifica', () {
      var notifications = 0;
      service.addListener(() => notifications++);

      service.recordSearch(origin: '  ', destination: 'Campus');

      expect(service.searches, hasLength(1));
      expect(service.searches.first.origin, 'Origen no especificado');
      expect(service.searches.first.destination, 'Campus');
      expect(notifications, 1);
    });

    test('inicia y completa un viaje', () {
      final journey = service.startJourney(
        routeId: 'ruta-102',
        routeCode: '102',
        routeName: 'Centro – Campus',
        origin: 'Centro',
        destination: 'Campus',
        isDemo: true,
      );

      expect(service.journeys, hasLength(1));
      expect(service.journeys.first.status, JourneyStatus.inProgress);

      service.completeJourney(journey.id);

      expect(service.journeys.first.status, JourneyStatus.completed);
      expect(service.journeys.first.finishedAt, isNotNull);
    });

    test('clear elimina el historial', () {
      service.recordSearch(origin: 'A', destination: 'B');
      service.startJourney(
        routeId: 'r',
        routeCode: 'R',
        routeName: 'Ruta',
        origin: 'A',
        destination: 'B',
      );

      service.clear();

      expect(service.isEmpty, isTrue);
    });
  });
}
