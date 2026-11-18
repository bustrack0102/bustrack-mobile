import '../../../core/map/models/geo_point.dart';

/// Modelo de datos para rutas en la simulación estática de demostración.
class DemoRouteItem {
  final String id;
  final String code;
  final String name;
  final String company;
  final String transportMode;
  final String originName;
  final String destinationName;
  final double fareMxn;
  final String frequencyText;
  final String estimatedDuration;
  final List<DemoStopItem> stops;
  final List<GeoPoint> polyline;

  const DemoRouteItem({
    required this.id,
    required this.code,
    required this.name,
    required this.company,
    required this.transportMode,
    required this.originName,
    required this.destinationName,
    required this.fareMxn,
    required this.frequencyText,
    required this.estimatedDuration,
    required this.stops,
    required this.polyline,
  });
}

/// Parada demostrativa de la simulación.
class DemoStopItem {
  final String id;
  final String name;
  final String address;
  final GeoPoint point;
  final int order;
  final List<String> availableRoutes;
  final String company;
  final String schedule;
  final double fareMxn;

  const DemoStopItem({
    required this.id,
    required this.name,
    required this.address,
    required this.point,
    required this.order,
    required this.availableRoutes,
    required this.company,
    required this.schedule,
    required this.fareMxn,
  });
}

/// Destino de ejemplo para búsqueda interactiva en demo.
class DemoDestinationItem {
  final String id;
  final String name;
  final String category;
  final String municipality;
  final String recommendedRoute;
  final String description;

  const DemoDestinationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.municipality,
    required this.recommendedRoute,
    required this.description,
  });
}

/// Catálogo de datos 100% estáticos y locales para el modo demostración.
class DemoMockData {
  DemoMockData._();

  static const List<DemoDestinationItem> destinations = [
    DemoDestinationItem(
      id: 'dest-01',
      name: 'Centro Histórico y Catedral',
      category: 'Turístico / Cultural',
      municipality: 'Zona Centro',
      recommendedRoute: 'Línea 102 - Metrobús Directo',
      description: 'Plaza principal, museos y zona peatonal de la ciudad.',
    ),
    DemoDestinationItem(
      id: 'dest-02',
      name: 'Parque Metropolitano y Lago',
      category: 'Ecológico / Recreativo',
      municipality: 'Zona Norte',
      recommendedRoute: 'Ruta 14 Express',
      description: 'Extensas áreas verdes, pista de atletismo y ciclovía.',
    ),
    DemoDestinationItem(
      id: 'dest-03',
      name: 'Campus Universitario Central',
      category: 'Educativo',
      municipality: 'Sector Poniente',
      recommendedRoute: 'Troncal 05 Universitario',
      description: 'Facultades principales, bibliotecas y hospital regional.',
    ),
    DemoDestinationItem(
      id: 'dest-04',
      name: 'Centro Comercial Plaza Mayor',
      category: 'Comercial',
      municipality: 'Corredor Industrial',
      recommendedRoute: 'Línea 102 - Metrobús Directo',
      description: 'Tiendas departamentales, restaurantes y cines.',
    ),
  ];

  static const List<DemoRouteItem> routes = [
    DemoRouteItem(
      id: 'demo-rt-01',
      code: 'L-102',
      name: 'Metrobús Directo: Centro — Plaza Mayor',
      company: 'Autotransportes Metropolitanos S.A.',
      transportMode: 'Autobús BRT / Carril Exclusivo',
      originName: 'Terminal Centro',
      destinationName: 'Plaza Mayor',
      fareMxn: 13.50,
      frequencyText: 'Cada 6 a 8 minutos',
      estimatedDuration: '32 min',
      stops: [
        DemoStopItem(
          id: 'stp-1',
          name: 'Terminal Centro (Andén 1)',
          address: 'Av. Hidalgo esq. Juárez',
          point: GeoPoint(21.1220, -101.6820),
          order: 1,
          availableRoutes: ['L-102', 'T-05'],
          company: 'Autotransportes Metropolitanos',
          schedule: '05:30 - 23:00',
          fareMxn: 13.50,
        ),
        DemoStopItem(
          id: 'stp-2',
          name: 'Estación Parque Hidalgo',
          address: 'Blvd. López Mateos #450',
          point: GeoPoint(21.1290, -101.6850),
          order: 2,
          availableRoutes: ['L-102', 'R-14'],
          company: 'Autotransportes Metropolitanos',
          schedule: '05:40 - 22:50',
          fareMxn: 13.50,
        ),
        DemoStopItem(
          id: 'stp-3',
          name: 'Estación Poliforum / Explanada',
          address: 'Blvd. López Mateos esq. Blvd. Vasco de Quiroga',
          point: GeoPoint(21.1370, -101.6780),
          order: 3,
          availableRoutes: ['L-102', 'T-05', 'R-14'],
          company: 'Autotransportes Metropolitanos',
          schedule: '05:50 - 22:45',
          fareMxn: 13.50,
        ),
        DemoStopItem(
          id: 'stp-4',
          name: 'Terminal Plaza Mayor',
          address: 'Av. Cerro Gordo #120',
          point: GeoPoint(21.1490, -101.6910),
          order: 4,
          availableRoutes: ['L-102'],
          company: 'Autotransportes Metropolitanos',
          schedule: '06:00 - 22:30',
          fareMxn: 13.50,
        ),
      ],
      polyline: [
        GeoPoint(21.1220, -101.6820),
        GeoPoint(21.1250, -101.6835),
        GeoPoint(21.1290, -101.6850),
        GeoPoint(21.1330, -101.6815),
        GeoPoint(21.1370, -101.6780),
        GeoPoint(21.1430, -101.6840),
        GeoPoint(21.1490, -101.6910),
      ],
    ),
    DemoRouteItem(
      id: 'demo-rt-02',
      code: 'T-05',
      name: 'Troncal 05: San Jerónimo — Ciudad Universitaria',
      company: 'Colectivos del Bajío',
      transportMode: 'Autobús Estándar',
      originName: 'Transfer San Jerónimo',
      destinationName: 'Campus Universidad',
      fareMxn: 12.00,
      frequencyText: 'Cada 10 a 12 minutos',
      estimatedDuration: '45 min',
      stops: [
        DemoStopItem(
          id: 'stp-5',
          name: 'Estación San Jerónimo',
          address: 'Blvd. Campestre #800',
          point: GeoPoint(21.1550, -101.6980),
          order: 1,
          availableRoutes: ['T-05'],
          company: 'Colectivos del Bajío',
          schedule: '06:00 - 22:00',
          fareMxn: 12.00,
        ),
        DemoStopItem(
          id: 'stp-6',
          name: 'Parada Hospital Regional',
          address: 'Av. 20 de Noviembre #302',
          point: GeoPoint(21.1380, -101.6750),
          order: 2,
          availableRoutes: ['T-05', 'L-102'],
          company: 'Colectivos del Bajío',
          schedule: '06:15 - 22:15',
          fareMxn: 12.00,
        ),
        DemoStopItem(
          id: 'stp-7',
          name: 'Campus Universidad (Acceso Norte)',
          address: 'Circuito Universitario #1',
          point: GeoPoint(21.1150, -101.6620),
          order: 3,
          availableRoutes: ['T-05'],
          company: 'Colectivos del Bajío',
          schedule: '06:30 - 21:45',
          fareMxn: 12.00,
        ),
      ],
      polyline: [
        GeoPoint(21.1550, -101.6980),
        GeoPoint(21.1460, -101.6860),
        GeoPoint(21.1380, -101.6750),
        GeoPoint(21.1260, -101.6690),
        GeoPoint(21.1150, -101.6620),
      ],
    ),
  ];
}
