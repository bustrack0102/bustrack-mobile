import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String input) {
  final clean = input.trim();
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(clean);
}

bool isValidOtpCode(String input) {
  return RegExp(r'^\d{6}$').hasMatch(input.trim());
}

bool isStrongPassword(String input) {
  return input.length >= 8 &&
      RegExp(r'[A-Z]').hasMatch(input) &&
      RegExp(r'[a-z]').hasMatch(input) &&
      RegExp(r'\d').hasMatch(input);
}

void main() {
  group('BusTrack Mobile - Pruebas Unitarias y Sensibilidad Mutacional', () {
    test('Valida formatos de correo institucional y personal', () {
      expect(isValidEmail('alumno@uttt.edu.mx'), isTrue);
      expect(isValidEmail('  usuario@bustrack.mx  '), isTrue);
      expect(isValidEmail('correo-sin-arroba.com'), isFalse);
      expect(isValidEmail(''), isFalse);
    });

    test('Valida codigo OTP estrictamente de 6 digitos', () {
      expect(isValidOtpCode('482910'), isTrue);
      expect(isValidOtpCode('48291'), isFalse);
      expect(isValidOtpCode('4829101'), isFalse);
      expect(isValidOtpCode('48291a'), isFalse);
    });

    test('Valida politica de contrasena en fronteras (boundary +/- 1)', () {
      expect(isStrongPassword('Abcdef1'), isFalse);
      expect(isStrongPassword('Abcdef12'), isTrue);
      expect(isStrongPassword('abcdef12'), isFalse);
      expect(isStrongPassword('Abcdefgh'), isFalse);
    });
  });
}
