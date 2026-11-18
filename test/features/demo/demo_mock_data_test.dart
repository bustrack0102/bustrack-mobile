import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/features/demo/data/demo_mock_data.dart';

void main() {
  group('DemoMockData Tests', () {
    test('1. Contiene destinos de ejemplo estructurados', () {
      expect(DemoMockData.destinations, isNotEmpty);
      for (final dest in DemoMockData.destinations) {
        expect(dest.id, isNotEmpty);
        expect(dest.name, isNotEmpty);
        expect(dest.category, isNotEmpty);
        expect(dest.recommendedRoute, isNotEmpty);
      }
    });

    test('2. Rutas de demostración tienen paradas y polilíneas válidas', () {
      expect(DemoMockData.routes, isNotEmpty);
      for (final route in DemoMockData.routes) {
        expect(route.id, isNotEmpty);
        expect(route.code, isNotEmpty);
        expect(route.fareMxn, greaterThan(0));
        expect(route.stops.length, greaterThanOrEqualTo(2));
        expect(route.polyline.length, greaterThanOrEqualTo(2));

        for (final stop in route.stops) {
          expect(stop.point.isValid, isTrue);
          expect(stop.name, isNotEmpty);
        }
      }
    });
  });
}
