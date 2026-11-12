import 'package:bustrack_mobile/features/history/domain/journey_history_service.dart';
import 'package:bustrack_mobile/features/history/presentation/screens/trip_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TripHistoryScreen muestra estado vacío y navega a explorar',
      (tester) async {
    final service = JourneyHistoryService();
    var explored = false;

    await tester.pumpWidget(
      MaterialApp(
        home: TripHistoryScreen(
          historyService: service,
          onExplore: () => explored = true,
        ),
      ),
    );

    expect(find.text('Aún no tienes historial'), findsOneWidget);
    expect(find.text('Explorar rutas'), findsOneWidget);

    await tester.tap(find.text('Explorar rutas'));
    expect(explored, isTrue);
  });

  testWidgets('TripHistoryScreen lista una búsqueda registrada',
      (tester) async {
    final service = JourneyHistoryService();
    service.recordSearch(
      origin: 'Centro',
      destination: 'Campus',
      routeCode: '102',
      routeId: 'ruta-102',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TripHistoryScreen(historyService: service),
      ),
    );

    expect(find.text('Centro → Campus'), findsOneWidget);
    expect(find.text('102'), findsOneWidget);
    expect(find.text('Búsquedas recientes'), findsOneWidget);
  });
}
