import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/main.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/otp_verification_screen.dart';

void main() {
  group('BusTrack Mobile - Seguridad Fintech y PII', () {
    testWidgets('1. LoginScreen oculta contrasena', (WidgetTester t) async {
      await t.pumpWidget(const BusTrackApp());
      await t.tap(find.text('Comenzar'));
      await t.pumpAndSettle();

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
      await t.pumpWidget(const BusTrackApp());
      await t.tap(find.text('Comenzar'));
      await t.pumpAndSettle();

      await t.tap(find.text('Regístrate aquí'));
      await t.pumpAndSettle();

      final f = t.widgetList<EditableText>(find.byType(EditableText));
      expect(f.any((field) => field.obscureText), isTrue);
    });
  });
}
