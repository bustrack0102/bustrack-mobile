import 'models/geo_point.dart';

/// Proveedores de mapas evaluados por BusTrack.
enum MapProvider { openStreetMap }

/// Configuración centralizada del proveedor de mapas.
///
/// Decisión: se usa `flutter_map` con OpenStreetMap porque el proyecto no
/// cuenta con una API Key de Google Maps. Para migrar a `google_maps_flutter`
/// basta con sustituir la capa de presentación del mapa, manteniendo este
/// contrato de configuración.
class MapConfig {
  MapConfig._();

  static const MapProvider provider = MapProvider.openStreetMap;

  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String attributionText = 'OpenStreetMap contributors';

  /// Identifica la app ante el servicio de tiles de OpenStreetMap.
  static const String userAgentPackageName = 'com.bustrack.mobile';

  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;
  static const double defaultZoom = 12.5;

  /// Centro neutro de demostración. Los datos reales provienen de la API.
  static const GeoPoint defaultCenter = GeoPoint(25.6866, -100.3161);

  static const String demoNotice =
      'Datos de demostración. Las rutas, paradas y coordenadas reales deben '
      'provenir de la API central de BusTrack.';
}
