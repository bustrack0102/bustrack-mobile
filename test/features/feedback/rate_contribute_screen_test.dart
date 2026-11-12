import 'package:bustrack_mobile/features/feedback/domain/contribution_service.dart';
import 'package:bustrack_mobile/features/feedback/presentation/screens/rate_contribute_screen.dart';
import 'package:bustrack_mobile/features/routes/data/demo_route_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'RateContributeScreen muestra las cuatro secciones sin recompensas',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RateContributeScreen(
          route: demoRoutes.first,
          contributionService: ContributionService(delay: Duration.zero),
        ),
      ),
    );

    final scrollable = find.byType(Scrollable).first;

    expect(find.text('A. Calificar experiencia'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('B. Reportar tarifa'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('B. Reportar tarifa'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('C. Reportar a la concesionaria'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('C. Reportar a la concesionaria'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('D. Recompensas'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('D. Recompensas'), findsOneWidget);
    expect(
      find.textContaining('sistema de recompensas aún no está implementado'),
      findsOneWidget,
    );
  });
}
