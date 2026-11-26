import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/main.dart';
import 'package:bustrack_mobile/features/auth/presentation/screens/otp_verification_screen.dart';

void main() {
  group('BusTrack Mobile - Seguridad Fintech y PII', () {
    testWidgets(
      '1. LoginScreen oculta el campo de contrasena',
      (WidgetTester tester) async {
        await tester.pumpWidget(const BusTrackApp());
        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();

        final fields = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(fields.any((field) => field.obscureText), isTrue);
      },
    );

    testWidgets(
      '2. OtpVerificationScreen enmascara el correo PII',
      (WidgetTester tester) async {
        await tester.pumpWidget(
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
      },
    );

    testWidgets(
      '3. RegisterScreen protege campos sensibles',
      (WidgetTester tester) async {
        await tester.pumpWidget(const BusTrackApp());
        await tester.tap(find.text('Comenzar'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Regístrate aquí'));
        await tester.pumpAndSettle();

        final fields = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(fields.any((field) => field.obscureText), isTrue);
      },
    );
  });
}
