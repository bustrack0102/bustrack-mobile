import 'package:geolocator/geolocator.dart';

import 'models/geo_point.dart';

/// Estado del acceso a la ubicación del usuario.
enum LocationAccessStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

/// Resultado tipado de una solicitud de ubicación.
class UserLocationResult {
  final LocationAccessStatus status;
  final GeoPoint? position;
  final String message;

  const UserLocationResult({
    required this.status,
    required this.message,
    this.position,
  });

  bool get isGranted =>
      status == LocationAccessStatus.granted && position != null;

  factory UserLocationResult.granted(GeoPoint position) => UserLocationResult(
        status: LocationAccessStatus.granted,
        position: position,
        message: 'Ubicación autorizada.',
      );

  factory UserLocationResult.denied() => const UserLocationResult(
        status: LocationAccessStatus.denied,
        message:
            'Permiso de ubicación rechazado. Puedes seguir usando el mapa y la '
            'ruta sin tu posición.',
      );

  factory UserLocationResult.deniedForever() => const UserLocationResult(
        status: LocationAccessStatus.deniedForever,
        message:
            'El permiso de ubicación está bloqueado. Actívalo desde los ajustes '
            'del sistema si deseas ver tu posición.',
      );

  factory UserLocationResult.serviceDisabled() => const UserLocationResult(
        status: LocationAccessStatus.serviceDisabled,
        message:
            'El servicio de ubicación del dispositivo está desactivado. El '
            'mapa sigue disponible.',
      );

  factory UserLocationResult.error() => const UserLocationResult(
        status: LocationAccessStatus.error,
        message: 'No se pudo obtener tu ubicación. Puedes continuar sin ella.',
      );
}

/// Contrato de acceso controlado a la ubicación.
abstract class LocationService {
  Future<UserLocationResult> requestCurrentPosition();
}

/// Implementación con `geolocator`.
///
/// La ubicación solo se solicita cuando el usuario activa una función que la
/// necesita. No se usa ubicación en segundo plano ni se persiste.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<UserLocationResult> requestCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return UserLocationResult.serviceDisabled();
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return UserLocationResult.denied();
      }
      if (permission == LocationPermission.deniedForever) {
        return UserLocationResult.deniedForever();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return UserLocationResult.granted(
        GeoPoint(position.latitude, position.longitude),
      );
    } catch (_) {
      return UserLocationResult.error();
    }
  }
}
