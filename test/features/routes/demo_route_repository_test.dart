import 'package:bustrack_mobile/features/routes/data/demo_route_repository.dart';
import 'package:bustrack_mobile/features/routes/domain/models/transport_route.dart';
import 'package:bustrack_mobile/features/routes/domain/repositories/route_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoRouteRepository', () {
    const repository = DemoRouteRepository(delay: Duration.zero);

    test('devuelve rutas de demostración con paradas y coordenadas válidas',
        () async {
      final routes = await repository.getRoutes();

      expect(routes, isNotEmpty);
      for (final route in routes) {
        expect(route.isDemo, isTrue);
        expect(route.stops.length, greaterThanOrEqualTo(2));
        expect(route.fare, greaterThan(0));
        expect(
          route.orderedStops.every((stop) => stop.hasValidCoordinates),
          isTrue,
        );
        expect(route.polylinePoints.length, greaterThanOrEqualTo(2));
      }
    });

    test('filtra por modo de transporte', () async {
      final routes = await repository.getRoutes(mode: TransportMode.express);

      expect(routes, isNotEmpty);
      expect(
          routes.every((route) => route.mode == TransportMode.express), isTrue);
    });

    test('busca por texto ignorando mayúsculas y acentos', () async {
      final routes = await repository.getRoutes(query: 'UNIVERSIDAD');

      expect(routes, isNotEmpty);
      expect(
        routes.any(
          (route) => route.stops.any(
            (stop) => stop.name.toLowerCase().contains('universidad'),
          ),
        ),
        isTrue,
      );
    });

    test('obtiene una ruta por id y devuelve null si no existe', () async {
      final route = await repository.getRouteById('ruta-102');
      final missing = await repository.getRouteById('ruta-inexistente');

      expect(route, isNotNull);
      expect(route!.code, '102');
      expect(missing, isNull);
    });

    test('simula fallo de red con RouteRepositoryException', () async {
      const failing = DemoRouteRepository(
        delay: Duration.zero,
        simulateFailure: true,
      );

      expect(
        () => failing.getRoutes(),
        throwsA(isA<RouteRepositoryException>()),
      );
    });
  });
}
