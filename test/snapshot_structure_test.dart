import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/main.dart';
import 'package:bustrack_mobile/core/widgets/live_status_card.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:bustrack_mobile/features/splash/presentation/screens/splash_screen.dart';

void main() {
  group('BusTrack Mobile - Snapshot Estructural de Widgets', () {
    testWidgets('SplashScreen conserva estructura de bienvenida y accion',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BusTrackApp());

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('V2.0 OFICIAL'), findsOneWidget);
      expect(find.text('Comenzar'), findsOneWidget);
    });

    testWidgets('LoginScreen conserva tarjeta de estado y boton de ingreso',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BusTrackApp());
      await tester.tap(find.text('Comenzar'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(LiveStatusCard), findsOneWidget);
      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Ingresar'), findsOneWidget);
      expect(find.text('Regístrate aquí'), findsOneWidget);
    });

    testWidgets('No renderiza overflow ni errores de layout en 390x844',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const BusTrackApp());
      expect(tester.takeException(), isNull);
    });
  });
}
