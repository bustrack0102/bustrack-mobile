import 'package:bustrack_mobile/core/map/map_utils.dart';
import 'package:bustrack_mobile/core/map/models/geo_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapUtils', () {
    test('distancia entre el mismo punto es cero', () {
      const point = GeoPoint(25.6866, -100.3161);
      expect(MapUtils.distanceKm(point, point), closeTo(0, 0.000001));
    });

    test('un grado de latitud equivale aproximadamente a 111 km', () {
      const from = GeoPoint(0, 0);
      const to = GeoPoint(1, 0);
      expect(MapUtils.distanceKm(from, to), closeTo(111.19, 0.5));
    });

    test('formatDistance usa metros y kilómetros', () {
      expect(MapUtils.formatDistance(0.35), '350 m');
      expect(MapUtils.formatDistance(2.456), '2.5 km');
    });
  });
}
