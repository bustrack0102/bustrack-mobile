import 'package:flutter_test/flutter_test.dart';
import 'package:bustrack_mobile/features/auth/data/models/user_model.dart';
import 'package:bustrack_mobile/features/routes/data/models/api_models.dart';

void main() {
  group('UserModel', () {
    test('fromJson tolera campos ausentes y aplica defaults', () {
      final user = UserModel.fromJson(const {'id': 'u1'});
      expect(user.id, 'u1');
      expect(user.rol, 'Usuario');
      expect(user.totalViajesGuardados, 0);
      expect(user.consentimientoSensoresActivo, isFalse);
    });

    test('AuthResponseModel parsea tokens y usuario anidado', () {
      final auth = AuthResponseModel.fromJson(const {
        'accessToken': 'a-token',
        'refreshToken': 'r-token',
        'expiraEnSegundos': 3600,
        'usuario': {
          'id': 'u1',
          'nombreCompleto': 'Ana Prueba',
          'correo': 'ana@example.com',
          'rol': 'Conductor',
        },
      });
      expect(auth.accessToken, 'a-token');
      expect(auth.refreshToken, 'r-token');
      expect(auth.expiraEnSegundos, 3600);
      expect(auth.usuario?.nombreCompleto, 'Ana Prueba');
      expect(auth.usuario?.rol, 'Conductor');
    });
  });

  group('ParadaModel', () {
    test('parsea orden y accesibilidad cuando la API los envía', () {
      final parada = ParadaModel.fromJson(const {
        'id': 'p1',
        'nombre': 'Central',
        'latitud': 19.43,
        'longitud': -99.13,
        'orden': 3,
        'esAccesible': true,
      });
      expect(parada.orden, 3);
      expect(parada.esAccesible, isTrue);
    });

    test('acepta campos alternos secuencia/accesible', () {
      final parada = ParadaModel.fromJson(const {
        'id': 'p2',
        'nombre': 'Mercado',
        'latitud': 19.4,
        'longitud': -99.1,
        'secuencia': 7,
        'accesible': true,
      });
      expect(parada.orden, 7);
      expect(parada.esAccesible, isTrue);
    });

    test('sin campos de orden ni accesibilidad: orden null, accesible false',
        () {
      final parada = ParadaModel.fromJson(const {
        'id': 'p3',
        'nombre': 'Central',
        'latitud': 19.43,
        'longitud': -99.13,
      });
      expect(parada.orden, isNull);
      expect(parada.esAccesible, isFalse);
    });
  });

  group('GeometriaRutaModel', () {
    test('invierte GeoJSON [lng, lat] a tupla interna [lat, lng]', () {
      final geometria = GeometriaRutaModel.fromJson(const {
        'rutaId': 'r1',
        'nombre': 'Ruta 1',
        'trazoGeoJson': {
          'type': 'LineString',
          'coordinates': [
            [-99.13, 19.43],
            [-99.10, 19.40],
          ],
        },
      });
      expect(geometria.coordenadasLineString, [
        [19.43, -99.13],
        [19.40, -99.10],
      ]);
    });

    test('sin trazoGeoJson devuelve lista vacía', () {
      final geometria = GeometriaRutaModel.fromJson(const {
        'rutaId': 'r1',
        'nombre': 'Ruta 1',
      });
      expect(geometria.coordenadasLineString, isEmpty);
    });
  });

  group('TarifaCalculoModel', () {
    test('parsea monto, nombres de paradas y leyenda', () {
      final tarifa = TarifaCalculoModel.fromJson(const {
        'rutaId': 'r1',
        'paradaSubida': {'nombre': 'Origen'},
        'paradaBajada': {'nombre': 'Destino'},
        'montoMxn': 12.5,
        'esCostoAproximado': true,
        'leyenda': 'Costo aproximado',
      });
      expect(tarifa.paradaSubidaNombre, 'Origen');
      expect(tarifa.paradaBajadaNombre, 'Destino');
      expect(tarifa.montoMxn, 12.5);
      expect(tarifa.esCostoAproximado, isTrue);
    });
  });

  group('EmpresaModel y DestinoTuristicoModel', () {
    test('EmpresaModel parsea catálogo con defaults', () {
      final empresa = EmpresaModel.fromJson(const {
        'id': 'e1',
        'nombre': 'Transportes del Valle',
        'siglas': 'TDV',
      });
      expect(empresa.calificacionPromedio, 0.0);
      expect(empresa.totalEvaluaciones, 0);
    });

    test('DestinoTuristicoModel parsea coordenadas', () {
      final destino = DestinoTuristicoModel.fromJson(const {
        'id': 'd1',
        'nombre': 'Mirador',
        'categoria': 'Naturaleza',
        'latitud': 19.5,
        'longitud': -99.2,
        'calificacionPromedio': 4.7,
      });
      expect(destino.latitud, 19.5);
      expect(destino.calificacionPromedio, 4.7);
    });
  });

  group('MedioTransporteModel', () {
    test('parsea catálogo de medios', () {
      final medio = MedioTransporteModel.fromJson(const {
        'id': 'm1',
        'clave': 'BUS',
        'nombre': 'Autobús',
      });
      expect(medio.clave, 'BUS');
      expect(medio.nombre, 'Autobús');
    });
  });
}
