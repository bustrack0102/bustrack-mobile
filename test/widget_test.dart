import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bustrack_mobile/main.dart';
import 'package:bustrack_mobile/features/splash/presentation/screens/splash_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:bustrack_mobile/features/demo/presentation/screens/demo_shell_screen.dart';
import 'package:bustrack_mobile/core/widgets/live_status_card.dart';

void main() {
  FlutterSecureStorage.setMockInitialValues({});

  group('BusTrack Mobile - Flujos y Pantallas Widget Tests', () {
    testWidgets('1. SplashScreen muestra logotipo y botón Comenzar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BusTrackApp());

      expect(find.byType(SplashScreen), findsOneWidget);
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
      },
    );

    testWidgets(
      '4. LoginScreen navega a ForgotPasswordScreen al presionar ¿Olvidaste tu contraseña?',
      (WidgetTester tester) async {
        await tester.pumpWidget(const BusTrackApp());

        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('¿Olvidaste tu contraseña?'));
        await tester.pumpAndSettle();

        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
        expect(find.text('Recuperar contraseña'), findsOneWidget);
      },
    );

    testWidgets(
      '5. LoginScreen navega a DemoShellScreen al presionar Modo Demo',
      (WidgetTester tester) async {
        await tester.pumpWidget(const BusTrackApp());

        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Modo Demo'));
        await tester.pumpAndSettle();

        expect(find.byType(DemoShellScreen), findsOneWidget);
        expect(find.text('Modo Demostración · Simulación local sin conexión'),
            findsOneWidget);
      },
    );

    testWidgets(
      '6. EmailVerificationScreen muestra correo enmascarado y controles de token',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: EmailVerificationScreen(
              email: 'carlos.mendoza@correo.com',
              onVerificationSuccess: () {},
              onBackToRegister: () {},
            ),
          ),
        );

        expect(find.text('Confirma tu correo electrónico'), findsOneWidget);
        expect(find.text('Verificar y activar cuenta'), findsOneWidget);
        expect(find.text('c***a@correo.com'), findsOneWidget);
      },
    );
  });
}
