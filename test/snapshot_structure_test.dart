import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/core/widgets/live_status_card.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:bustrack_mobile/features/splash/presentation/screens/splash_screen.dart';

void main() {
  group('BusTrack Mobile - Snapshot Estructural de Widgets', () {
    testWidgets('SplashScreen conserva estructura', (WidgetTester t) async {
      var started = false;
      await t.pumpWidget(
        MaterialApp(
          home: SplashScreen(onStart: () => started = true),
        ),
      );

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('V2.0 OFICIAL'), findsOneWidget);
      expect(find.text('Comenzar'), findsOneWidget);
      await t.tap(find.text('Comenzar'));
      expect(started, isTrue);
    });

    testWidgets('LoginScreen conserva estructura', (WidgetTester t) async {
      await t.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            onRegisterTap: () {},
            onLoginSuccess: () {},
            onForgotPasswordTap: () {},
            onDemoTap: () {},
          ),
        ),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(LiveStatusCard), findsOneWidget);
      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Ingresar'), findsOneWidget);
      expect(find.text('Regístrate aquí'), findsOneWidget);
    });
  });
}
