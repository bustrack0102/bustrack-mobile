import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/main.dart';
import 'package:bustrack_mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:bustrack_mobile/core/widgets/live_status_card.dart';

void main() {
  group('BusTrack Mobile - Primeras Pantallas Widget Tests', () {
    testWidgets('1. SplashScreen muestra logotipo, textos y botón Comenzar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BusTrackApp());

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('BusTrack'), findsNothing); // Is RichText
      expect(find.text('Comenzar'), findsOneWidget);
      expect(find.text('V2.0 OFICIAL'), findsOneWidget);
    });

    testWidgets('2. SplashScreen navega a Login al presionar Comenzar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BusTrackApp());

      await tester.tap(find.text('Comenzar'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.byType(LiveStatusCard), findsOneWidget);
      expect(find.text('Ingresar'), findsOneWidget);
    });

    testWidgets(
      '3. LoginScreen navega a RegisterScreen al presionar Regístrate aquí',
      (WidgetTester tester) async {
        await tester.pumpWidget(const BusTrackApp());

        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Regístrate aquí'));
        await tester.pumpAndSettle();

        expect(find.byType(RegisterScreen), findsOneWidget);
        expect(find.text('Crear Cuenta'), findsOneWidget);
        expect(find.text('Alertas GPS de líneas favoritas'), findsOneWidget);
      },
    );

    testWidgets(
      '4. OtpVerificationScreen muestra casillas de código, paso 3 de 3 y correo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: OtpVerificationScreen(
              email: 'carlos@ejemplo.com',
              onBack: () {},
              onEditEmail: () {},
              onVerificationSuccess: () {},
            ),
          ),
        );

        expect(find.text('PASO 3 DE 3'), findsOneWidget);
        expect(find.text('Verifica tu correo'), findsOneWidget);
        expect(find.text('c***s@ejemplo.com'), findsOneWidget);
        expect(find.text('Verificar'), findsOneWidget);
      },
    );
  });
}
