import 'package:bustrack_mobile/core/map/models/geo_point.dart';
import 'package:bustrack_mobile/features/routes/data/demo_route_repository.dart';
import 'package:bustrack_mobile/features/routes/domain/models/route_stop.dart';
import 'package:bustrack_mobile/features/routes/domain/models/transport_route.dart';
import 'package:bustrack_mobile/features/routes/presentation/widgets/route_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RouteCard muestra datos condicionales y abre el detalle',
      (tester) async {
    final route = demoRoutes.first;
    var opened = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: RouteCard(
              route: route,
              onDetail: () => opened = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text(route.code), findsOneWidget);
    expect(find.text(route.name), findsOneWidget);
    expect(find.text(route.companyName), findsOneWidget);
    expect(find.text('Ver detalle'), findsOneWidget);
    expect(find.text('Activa'), findsOneWidget);

    await tester.tap(find.text('Ver detalle'));
    expect(opened, isTrue);
  });

  testWidgets('RouteCard no inventa estado u ocupación cuando son nulos',
      (tester) async {
    const withoutOptional = TransportRoute(
      id: 'sin-estado',
      code: 'X',
      name: 'Ruta sin estado',
      companyName: 'Transportes Demo',
      mode: TransportMode.urban,
      originName: 'Origen',
      destinationName: 'Destino',
      fare: 5,
      stops: [
        RouteStop(
          id: 's1',
          name: 'Origen',
          location: GeoPoint(25.0, -100.0),
          order: 1,
        ),
        RouteStop(
          id: 's2',
          name: 'Destino',
          location: GeoPoint(25.1, -100.1),
          order: 2,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: RouteCard(
              route: withoutOptional,
              onDetail: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Activa'), findsNothing);
    expect(find.text('Ocupación media'), findsNothing);
  });
}
