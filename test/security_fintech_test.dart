import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/register_screen.dart';

void main() {
  group('BusTrack Mobile - Seguridad Fintech y PII', () {
    testWidgets('1. LoginScreen oculta contrasena', (WidgetTester t) async {
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

      final f = t.widgetList<EditableText>(find.byType(EditableText));
      expect(f.any((field) => field.obscureText), isTrue);
    });

    testWidgets('2. OtpVerificationScreen oculta PII', (WidgetTester t) async {
      await t.pumpWidget(
        MaterialApp(
          home: OtpVerificationScreen(
            email: 'usuario.privado@uttt.edu.mx',
            onBack: () {},
            onEditEmail: () {},
            onVerificationSuccess: () {},
          ),
        ),
      );

      expect(find.text('usuario.privado@uttt.edu.mx'), findsNothing);
      expect(find.textContaining('@uttt.edu.mx'), findsOneWidget);
      expect(find.textContaining('***'), findsOneWidget);
    });

    testWidgets('3. RegisterScreen oculta contrasena', (WidgetTester t) async {
      await t.pumpWidget(
        MaterialApp(
          home: RegisterScreen(
            onLoginTap: () {},
            onRegisterSuccess: (_) {},
            onDemoTap: () {},
          ),
        ),
      );

      final f = t.widgetList<EditableText>(find.byType(EditableText));
      expect(f.any((field) => field.obscureText), isTrue);
    });
  });
}
