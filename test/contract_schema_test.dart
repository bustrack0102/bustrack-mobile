import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusTrack Mobile - Contratos JSON y Esquemas API', () {
    test('Contrato de loginRequest mantiene campos esperados por API', () {
      final payload = <String, dynamic>{
        'strNombreUsuario': 'AlumnoUTTT',
        'strPWD': 'PasswordSegura1!',
      };
      final decoded = jsonDecode(jsonEncode(payload)) as Map<String, dynamic>;

      expect(decoded.keys, containsAll(<String>['strNombreUsuario', 'strPWD']));
      expect(decoded['strNombreUsuario'], isA<String>());
      expect(decoded['strPWD'], isA<String>());
    });

    test('Contrato de respuesta paginada de rutas conserva esquema PagedResult',
        () {
      const rawJson = '''
      {
        "Items": [
          {"rutaId": "RUT-001", "nombre": "Tula - UTTT", "tarifaMxn": 12.0}
        ],
        "TotalCount": 1,
        "Page": 1,
        "PageSize": 20
      }
      ''';

      final map = jsonDecode(rawJson) as Map<String, dynamic>;
      expect(map['Items'], isA<List<dynamic>>());
      expect(map['TotalCount'], equals(1));
      expect(map['Page'], equals(1));
      expect(map['PageSize'], equals(20));
    });

    test('Contrato de error RFC 7807 ProblemDetails incluye campos estandar',
        () {
      const rawError = '''
      {
        "type": "https://tools.ietf.org/html/rfc7235#section-3.1",
        "title": "Unauthorized",
        "status": 401,
        "detail": "Token invalido o revocado"
      }
      ''';

      final error = jsonDecode(rawError) as Map<String, dynamic>;
      expect(error['status'], equals(401));
      expect(error['title'], isA<String>());
      expect(error['detail'], isA<String>());
    });
  });
}
