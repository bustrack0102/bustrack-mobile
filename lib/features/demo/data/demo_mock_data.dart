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
  final List<DemoReviewItem> reviews;

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
    this.reviews = const [],
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
  final GeoPoint? location;

  const DemoDestinationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.municipality,
    required this.recommendedRoute,
    required this.description,
    this.location,
  });
}

/// Reseña / Calificación de demostración.
class DemoReviewItem {
  final String id;
  final String userName;
  final int stars;
  final String comment;
  final String date;

  const DemoReviewItem({
    required this.id,
    required this.userName,
    required this.stars,
    required this.comment,
    required this.date,
  });
}

/// Empresa de transporte para demostración.
class DemoCompanyItem {
  final String id;
  final String name;
  final String acronym;
  final String fleetType;
  final double averageRating;
  final int totalUnits;
  final String coverageArea;

  const DemoCompanyItem({
    required this.id,
    required this.name,
    required this.acronym,
    required this.fleetType,
    required this.averageRating,
    required this.totalUnits,
    required this.coverageArea,
  });
}

/// Catálogo de datos 100% estáticos y locales para el modo demostración.
/// Completamente aislado de la base de datos real y servicios de backend.
class DemoMockData {
  DemoMockData._();

  // Empresas representativas del corredor metropolitano
  static const List<DemoCompanyItem> companies = [
    DemoCompanyItem(
      id: 'comp-01',
      name: 'Autotransportes del Valle Metropolitano',
      acronym: 'AVM',
      fleetType: 'Autobús de Pasajeros y BRT',
      averageRating: 4.6,
      totalUnits: 120,
      coverageArea: 'Corredor Central y Ejes Troncales',
    ),
    DemoCompanyItem(
      id: 'comp-02',
      name: 'Líneas Metropolitanas Conectadas',
      acronym: 'LMC',
      fleetType: 'Autobús Urbano e Intermunicipal',
      averageRating: 4.4,
      totalUnits: 85,
      coverageArea: 'Conexión Periférica y Centros Escolares',
    ),
    DemoCompanyItem(
      id: 'comp-03',
      name: 'Red de Transporte Interurbano del Altiplano',
      acronym: 'RTIA',
      fleetType: 'Trolebús y Corredor Eléctrico',
      averageRating: 4.7,
      totalUnits: 45,
      coverageArea: 'Circuito Cultural y Parques Metropolitanos',
    ),
  ];

  // Destinos coherentes
  static const List<DemoDestinationItem> destinations = [
    DemoDestinationItem(
      id: 'dest-01',
      name: 'Zócalo y Centro Histórico',
      category: 'Turístico / Cultural',
      municipality: 'Cuauhtémoc',
      recommendedRoute: 'L-01 Corredor Central',
      description:
          'Catedral Metropolitana, Palacio Nacional y Museo del Templo Mayor.',
      location: GeoPoint(19.4326, -99.1332),
    ),
    DemoDestinationItem(
      id: 'dest-02',
      name: 'Bosque de Chapultepec y Museos',
      category: 'Ecológico / Recreativo',
      municipality: 'Miguel Hidalgo',
      recommendedRoute: 'L-01 Corredor Central',
      description: 'Castillo de Chapultepec, Museo de Antropología y lago.',
      location: GeoPoint(19.4204, -99.1819),
    ),
    DemoDestinationItem(
      id: 'dest-03',
      name: 'Ciudad Universitaria (CU)',
      category: 'Educativo / Cultural',
      municipality: 'Coyoacán',
      recommendedRoute: 'T-03 Eje Insurgentes',
      description:
          'Rectoría, Biblioteca Central y Estadio Olímpico Universitario.',
      location: GeoPoint(19.3328, -99.1866),
    ),
    DemoDestinationItem(
      id: 'dest-04',
      name: 'Plaza Independencia y Reloj Monumental',
      category: 'Histórico / Turístico',
      municipality: 'Pachuca Centro',
      recommendedRoute: 'H-01 Expreso Altiplano',
      description: 'Plaza cívica, Reloj Neoclásico y centro cultural.',
      location: GeoPoint(20.1287, -98.7303),
    ),
    DemoDestinationItem(
      id: 'dest-05',
      name: 'Parque Ecológico David Ben Gurión',
      category: 'Recreativo / Arte',
      municipality: 'Zona Plateada',
      recommendedRoute: 'H-02 Troncal Metropolitano',
      description:
          'Mosaico monumental Homenaje a la Mujer del Mundo y auditorio Gota de Plata.',
      location: GeoPoint(20.0931, -98.7770),
    ),
    DemoDestinationItem(
      id: 'dest-06',
      name: 'Pueblo Mágico Real del Monte',
      category: 'Turístico / Montaña',
      municipality: 'Mineral del Monte',
      recommendedRoute: 'H-03 Corredor de la Montaña',
      description: 'Arquitectura minera colonial, museos y gastronomía típica.',
      location: GeoPoint(20.1419, -98.6736),
    ),
  ];

  // Rutas con polilíneas y paradas con coordenadas válidas
  static const List<DemoRouteItem> routes = [
    DemoRouteItem(
      id: 'demo-rt-01',
      code: 'L-01',
      name: 'Línea 01: Insurgentes Indios Verdes — El Caminero',
      company: 'Autotransportes del Valle Metropolitano',
      transportMode: 'Autobús BRT / Carril Confinado',
      originName: 'Indios Verdes',
      destinationName: 'El Caminero',
      fareMxn: 10.00,
      frequencyText: 'Cada 4 a 6 minutos',
      estimatedDuration: '48 min',
      reviews: [
        DemoReviewItem(
          id: 'rev-01',
          userName: 'Mariana Ríos',
          stars: 5,
          comment: 'Muy puntual en horas pico gracias al carril exclusivo.',
          date: '14 Nov 2026',
        ),
        DemoReviewItem(
          id: 'rev-02',
          userName: 'Carlos Santana',
          stars: 4,
          comment: 'Unidades limpias y buena señalización en estaciones.',
          date: '10 Nov 2026',
        ),
      ],
      stops: [
        DemoStopItem(
          id: 'stp-cdmx-01',
          name: 'Terminal Indios Verdes',
          address: 'Av. Insurgentes Norte esq. Ticomán',
          point: GeoPoint(19.4975, -99.1197),
          order: 1,
          availableRoutes: ['L-01'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '05:00 - 23:45',
          fareMxn: 10.00,
        ),
        DemoStopItem(
          id: 'stp-cdmx-02',
          name: 'Estación Buenavista / Tren',
          address: 'Av. Insurgentes Norte esq. Mosqueta',
          point: GeoPoint(19.4475, -99.1533),
          order: 2,
          availableRoutes: ['L-01', 'T-03'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '05:15 - 23:40',
          fareMxn: 10.00,
        ),
        DemoStopItem(
          id: 'stp-cdmx-03',
          name: 'Glorieta de Insurgentes / Reforma',
          address: 'Av. Insurgentes Sur esq. Paseo de la Reforma',
          point: GeoPoint(19.4268, -99.1633),
          order: 3,
          availableRoutes: ['L-01', 'T-03'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '05:30 - 23:30',
          fareMxn: 10.00,
        ),
        DemoStopItem(
          id: 'stp-cdmx-04',
          name: 'Estación Chilpancingo',
          address: 'Av. Insurgentes Sur esq. Baja California',
          point: GeoPoint(19.4061, -99.1685),
          order: 4,
          availableRoutes: ['L-01'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '05:40 - 23:20',
          fareMxn: 10.00,
        ),
        DemoStopItem(
          id: 'stp-cdmx-05',
          name: 'Estación Dr. Gálvez / San Ángel',
          address: 'Av. Insurgentes Sur esq. Miguel Ángel de Quevedo',
          point: GeoPoint(19.3402, -99.1882),
          order: 5,
          availableRoutes: ['L-01', 'T-03'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '05:55 - 23:05',
          fareMxn: 10.00,
        ),
        DemoStopItem(
          id: 'stp-cdmx-06',
          name: 'Terminal El Caminero',
          address: 'Av. Insurgentes Sur esq. Viaducto Tlalpan',
          point: GeoPoint(19.2825, -99.1678),
          order: 6,
          availableRoutes: ['L-01'],
          company: 'Autotransportes del Valle Metropolitano',
          schedule: '06:10 - 23:00',
          fareMxn: 10.00,
        ),
      ],
      polyline: [
        GeoPoint(19.4975, -99.1197),
        GeoPoint(19.4710, -99.1380),
        GeoPoint(19.4475, -99.1533),
        GeoPoint(19.4268, -99.1633),
        GeoPoint(19.4061, -99.1685),
        GeoPoint(19.3735, -99.1790),
        GeoPoint(19.3402, -99.1882),
        GeoPoint(19.3090, -99.1760),
        GeoPoint(19.2825, -99.1678),
      ],
    ),
    DemoRouteItem(
      id: 'demo-rt-02',
      code: 'H-01',
      name: 'Troncal Tuzobús: Centro Histórico — Téllez',
      company: 'Líneas Metropolitanas Conectadas',
      transportMode: 'Autobús Troncal Rápido',
      originName: 'Plaza Independencia Centro',
      destinationName: 'Terminal Téllez',
      fareMxn: 10.50,
      frequencyText: 'Cada 7 a 9 minutos',
      estimatedDuration: '36 min',
      reviews: [
        DemoReviewItem(
          id: 'rev-03',
          userName: 'Jorge Mendoza',
          stars: 5,
          comment:
              'La mejor opción para cruzar la zona metropolitana hacia Téllez.',
          date: '18 Nov 2026',
        ),
        DemoReviewItem(
          id: 'rev-04',
          userName: 'Sofía Valdés',
          stars: 4,
          comment: 'Rápido y económico, paradas bien iluminadas.',
          date: '12 Nov 2026',
        ),
      ],
      stops: [
        DemoStopItem(
          id: 'stp-hgo-01',
          name: 'Plaza Independencia (Reloj)',
          address: 'Plaza Independencia Centro',
          point: GeoPoint(20.1287, -98.7303),
          order: 1,
          availableRoutes: ['H-01'],
          company: 'Líneas Metropolitanas Conectadas',
          schedule: '05:30 - 22:30',
          fareMxn: 10.50,
        ),
        DemoStopItem(
          id: 'stp-hgo-02',
          name: 'Estación Central de Autobuses',
          address: 'Blvd. Javier Rojo Gómez esq. Felipe Ángeles',
          point: GeoPoint(20.1065, -98.7618),
          order: 2,
          availableRoutes: ['H-01', 'H-02'],
          company: 'Líneas Metropolitanas Conectadas',
          schedule: '05:42 - 22:40',
          fareMxn: 10.50,
        ),
        DemoStopItem(
          id: 'stp-hgo-03',
          name: 'Estación Zona Plateada / Tecnológico',
          address: 'Blvd. Felipe Ángeles esq. Camino Real',
          point: GeoPoint(20.0895, -98.7792),
          order: 3,
          availableRoutes: ['H-01'],
          company: 'Líneas Metropolitanas Conectadas',
          schedule: '05:55 - 22:45',
          fareMxn: 10.50,
        ),
        DemoStopItem(
          id: 'stp-hgo-04',
          name: 'Estación Matilde / Fraccionamientos',
          address: 'Carretera México - Pachuca Km 78',
          point: GeoPoint(20.0460, -98.8021),
          order: 4,
          availableRoutes: ['H-01'],
          company: 'Líneas Metropolitanas Conectadas',
          schedule: '06:08 - 22:50',
          fareMxn: 10.50,
        ),
        DemoStopItem(
          id: 'stp-hgo-05',
          name: 'Terminal de Integración Téllez',
          address: 'Entronque Autopista Arco Norte',
          point: GeoPoint(20.0125, -98.8189),
          order: 5,
          availableRoutes: ['H-01'],
          company: 'Líneas Metropolitanas Conectadas',
          schedule: '06:20 - 23:00',
          fareMxn: 10.50,
        ),
      ],
      polyline: [
        GeoPoint(20.1287, -98.7303),
        GeoPoint(20.1170, -98.7450),
        GeoPoint(20.1065, -98.7618),
        GeoPoint(20.0895, -98.7792),
        GeoPoint(20.0680, -98.7910),
        GeoPoint(20.0460, -98.8021),
        GeoPoint(20.0125, -98.8189),
      ],
    ),
    DemoRouteItem(
      id: 'demo-rt-03',
      code: 'M-05',
      name: 'Corredor Turístico: Pachuca — Real del Monte',
      company: 'Red de Transporte Interurbano del Altiplano',
      transportMode: 'Autobús Panorámico / Montaña',
      originName: 'Central Pachuca Poniente',
      destinationName: 'Plaza Principal Real del Monte',
      fareMxn: 18.00,
      frequencyText: 'Cada 15 minutos',
      estimatedDuration: '28 min',
      reviews: [
        DemoReviewItem(
          id: 'rev-05',
          userName: 'Fernando Cruz',
          stars: 5,
          comment:
              'Vistas panorámicas excelentes durante el ascenso a la sierra.',
          date: '20 Nov 2026',
        ),
      ],
      stops: [
        DemoStopItem(
          id: 'stp-rdm-01',
          name: 'Central Poniente (Loreto)',
          address: 'Calle Loreto esq. Viaducto Nuevo Hidalgo',
          point: GeoPoint(20.1340, -98.7240),
          order: 1,
          availableRoutes: ['M-05'],
          company: 'Red de Transporte Interurbano del Altiplano',
          schedule: '06:00 - 21:00',
          fareMxn: 18.00,
        ),
        DemoStopItem(
          id: 'stp-rdm-02',
          name: 'Mirador de la Montaña',
          address: 'Carretera Corredor de la Montaña Km 6',
          point: GeoPoint(20.1395, -98.7010),
          order: 2,
          availableRoutes: ['M-05'],
          company: 'Red de Transporte Interurbano del Altiplano',
          schedule: '06:12 - 21:12',
          fareMxn: 18.00,
        ),
        DemoStopItem(
          id: 'stp-rdm-03',
          name: 'Plaza Principal Real del Monte',
          address: 'Av. Hidalgo frente al Museo del Paste',
          point: GeoPoint(20.1419, -98.6736),
          order: 3,
          availableRoutes: ['M-05'],
          company: 'Red de Transporte Interurbano del Altiplano',
          schedule: '06:28 - 21:30',
          fareMxn: 18.00,
        ),
      ],
      polyline: [
        GeoPoint(20.1340, -98.7240),
        GeoPoint(20.1370, -98.7120),
        GeoPoint(20.1395, -98.7010),
        GeoPoint(20.1410, -98.6850),
        GeoPoint(20.1419, -98.6736),
      ],
    ),
  ];

  /// Simulación funcional e interactiva del Asistente IA para el modo Demo.
  /// 100% autónomo y aislado del backend y servicios externos.
  static Map<String, dynamic> generateDemoAiRecommendation({
    required String origin,
    required String destination,
    String? preference,
  }) {
    final cleanDest = destination.toLowerCase();

    if (cleanDest.contains('reloj') ||
        cleanDest.contains('téllez') ||
        cleanDest.contains('pachuca') ||
        cleanDest.contains('plateada') ||
        cleanDest.contains('ben gurión')) {
      return {
        'itinerary':
            'Te sugerimos tomar el Troncal Tuzobús H-01. Cuenta con carril confinado, salidas garantizadas cada 7 minutos y una tarifa accesible de \$10.50 MXN con excelente puntuación ciudadana (4.8 estrellas).',
        'costMxn': 10.50,
        'estimatedMinutes': 35,
        'suggestedRoute': 'H-01 Troncal Tuzobús',
        'reason':
            'Opción con menor tiempo de traslado y mejor valoración por usuarios frecuentes en el corredor.',
      };
    } else if (cleanDest.contains('monte') || cleanDest.contains('montaña')) {
      return {
        'itinerary':
            'Para tu trayecto hacia la sierra te recomendamos la Línea Panorámica M-05 desde Central Poniente. Ofrece ascenso directo, unidades con operadores certificados y frecuencia cada 15 min.',
        'costMxn': 18.00,
        'estimatedMinutes': 28,
        'suggestedRoute': 'M-05 Corredor Turístico',
        'reason':
            'Recomendada por seguridad en pendientes y vistas panorámicas panorámicas.',
      };
    } else {
      return {
        'itinerary':
            'Para este recorrido metropolitano te recomendamos la Línea 01 por el Eje Central Insurgentes. Evita congestionamiento vehicular en horas pico y conecta directamente con centros universitarios y culturales.',
        'costMxn': 10.00,
        'estimatedMinutes': 42,
        'suggestedRoute': 'L-01 Corredor Insurgentes',
        'reason':
            'Ruta troncal de alta capacidad con menor tiempo de espera estimado (4 min).',
      };
    }
  }
}
