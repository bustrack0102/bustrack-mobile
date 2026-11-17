// Modelos DTO de la API REST de BusTrack para Empresas, Rutas, Paradas, Horarios y Destinos.

class EmpresaModel {
  final String id;
  final String nombre;
  final String siglas;
  final String? descripcion;
  final String? municipioBase;
  final double calificacionPromedio;
  final int totalEvaluaciones;
  final String? logoUrl;

  EmpresaModel({
    required this.id,
    required this.nombre,
    required this.siglas,
    this.descripcion,
    this.municipioBase,
    required this.calificacionPromedio,
    required this.totalEvaluaciones,
    this.logoUrl,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      siglas: json['siglas']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      municipioBase: json['municipioBase']?.toString(),
      calificacionPromedio:
          (json['calificacionPromedio'] as num?)?.toDouble() ?? 0.0,
      totalEvaluaciones: (json['totalEvaluaciones'] as num?)?.toInt() ?? 0,
      logoUrl: json['logoUrl']?.toString(),
    );
  }
}

class MedioTransporteModel {
  final String id;
  final String clave;
  final String nombre;
  final String? descripcion;
  final String? iconoClave;

  MedioTransporteModel({
    required this.id,
    required this.clave,
    required this.nombre,
    this.descripcion,
    this.iconoClave,
  });

  factory MedioTransporteModel.fromJson(Map<String, dynamic> json) {
    return MedioTransporteModel(
      id: json['id']?.toString() ?? '',
      clave: json['clave']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      iconoClave: json['iconoClave']?.toString(),
    );
  }
}

class ParadaModel {
  final String id;
  final String? codigo;
  final String nombre;
  final String? referenciaVisual;
  final String? municipio;
  final bool esTerminal;
  final double latitud;
  final double longitud;
  final double? distanciaMetros;

  /// Orden de la parada dentro de la ruta (campo `orden`, `secuencia` o `posicion` en la API).
  final int? orden;

  /// Accesibilidad declarada por la API (campo `esAccesible` o `accesible`).
  final bool esAccesible;

  ParadaModel({
    required this.id,
    this.codigo,
    required this.nombre,
    this.referenciaVisual,
    this.municipio,
    this.esTerminal = false,
    required this.latitud,
    required this.longitud,
    this.distanciaMetros,
    this.orden,
    this.esAccesible = false,
  });

  factory ParadaModel.fromJson(Map<String, dynamic> json) {
    return ParadaModel(
      id: json['id']?.toString() ?? '',
      codigo: json['codigo']?.toString(),
      nombre: json['nombre']?.toString() ?? '',
      referenciaVisual: json['referenciaVisual']?.toString(),
      municipio: json['municipio']?.toString(),
      esTerminal: json['esTerminal'] == true,
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0.0,
      distanciaMetros: (json['distanciaMetros'] as num?)?.toDouble(),
      orden: (json['orden'] as num?)?.toInt() ??
          (json['secuencia'] as num?)?.toInt() ??
          (json['posicion'] as num?)?.toInt(),
      esAccesible: json['esAccesible'] == true || json['accesible'] == true,
    );
  }
}

class RutaApiModel {
  final String id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final String? empresaNombre;
  final String? medioTransporte;
  final String? paradaOrigenNombre;
  final String? paradaDestinoNombre;
  final int totalParadas;
  final double tarifaBaseMxn;
  final double? tiempoEstimadoMin;
  final double? distanciaTotalKm;

  RutaApiModel({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.empresaNombre,
    this.medioTransporte,
    this.paradaOrigenNombre,
    this.paradaDestinoNombre,
    this.totalParadas = 0,
    this.tarifaBaseMxn = 0.0,
    this.tiempoEstimadoMin,
    this.distanciaTotalKm,
  });

  factory RutaApiModel.fromJson(Map<String, dynamic> json) {
    return RutaApiModel(
      id: json['id']?.toString() ?? json['rutaId']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      nombre:
          json['nombre']?.toString() ?? json['nombreRuta']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      empresaNombre: json['empresa'] != null && json['empresa'] is Map
          ? json['empresa']['nombre']?.toString()
          : json['empresaNombre']?.toString(),
      medioTransporte: json['medioTransporte']?.toString(),
      paradaOrigenNombre:
          json['paradaOrigen'] != null && json['paradaOrigen'] is Map
              ? json['paradaOrigen']['nombre']?.toString()
              : json['paradaOrigenNombre']?.toString(),
      paradaDestinoNombre:
          json['paradaDestino'] != null && json['paradaDestino'] is Map
              ? json['paradaDestino']['nombre']?.toString()
              : json['paradaDestinoNombre']?.toString(),
      totalParadas: (json['totalParadas'] as num?)?.toInt() ?? 0,
      tarifaBaseMxn: (json['tarifaBaseMxn'] as num?)?.toDouble() ??
          (json['tarifaAproximadaMxn'] as num?)?.toDouble() ??
          0.0,
      tiempoEstimadoMin: (json['tiempoEstimadoMin'] as num?)?.toDouble() ??
          (json['tiempoTotalEstimadoMin'] as num?)?.toDouble(),
      distanciaTotalKm: (json['distanciaTotalKm'] as num?)?.toDouble(),
    );
  }
}

class GeometriaRutaModel {
  final String rutaId;
  final String nombre;
  final List<double>? boundingBox;
  final List<List<double>> coordenadasLineString;

  GeometriaRutaModel({
    required this.rutaId,
    required this.nombre,
    this.boundingBox,
    required this.coordenadasLineString,
  });

  factory GeometriaRutaModel.fromJson(Map<String, dynamic> json) {
    List<List<double>> coords = [];
    if (json['trazoGeoJson'] != null &&
        json['trazoGeoJson']['coordinates'] is List) {
      final list = json['trazoGeoJson']['coordinates'] as List;
      for (var point in list) {
        if (point is List && point.length >= 2) {
          final lng = (point[0] as num).toDouble();
          final lat = (point[1] as num).toDouble();
          coords.add([lat, lng]);
        }
      }
    }

    List<double>? bbox;
    if (json['boundingBox'] is List) {
      bbox = (json['boundingBox'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    return GeometriaRutaModel(
      rutaId: json['rutaId']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      boundingBox: bbox,
      coordenadasLineString: coords,
    );
  }
}

class TarifaCalculoModel {
  final String rutaId;
  final String paradaSubidaNombre;
  final String paradaBajadaNombre;
  final double montoMxn;
  final bool esCostoAproximado;
  final String leyenda;

  TarifaCalculoModel({
    required this.rutaId,
    required this.paradaSubidaNombre,
    required this.paradaBajadaNombre,
    required this.montoMxn,
    required this.esCostoAproximado,
    required this.leyenda,
  });

  factory TarifaCalculoModel.fromJson(Map<String, dynamic> json) {
    return TarifaCalculoModel(
      rutaId: json['rutaId']?.toString() ?? '',
      paradaSubidaNombre:
          json['paradaSubida'] != null && json['paradaSubida'] is Map
              ? json['paradaSubida']['nombre']?.toString() ?? ''
              : '',
      paradaBajadaNombre:
          json['paradaBajada'] != null && json['paradaBajada'] is Map
              ? json['paradaBajada']['nombre']?.toString() ?? ''
              : '',
      montoMxn: (json['montoMxn'] as num?)?.toDouble() ?? 0.0,
      esCostoAproximado: json['esCostoAproximado'] == true,
      leyenda: json['leyenda']?.toString() ??
          'Costo aproximado sujeto a tarifa vigente',
    );
  }
}

class DestinoTuristicoModel {
  final String id;
  final String nombre;
  final String categoria;
  final String? descripcion;
  final String? municipio;
  final String? horarioVisita;
  final String? imagenUrl;
  final double latitud;
  final double longitud;
  final double calificacionPromedio;

  DestinoTuristicoModel({
    required this.id,
    required this.nombre,
    required this.categoria,
    this.descripcion,
    this.municipio,
    this.horarioVisita,
    this.imagenUrl,
    required this.latitud,
    required this.longitud,
    required this.calificacionPromedio,
  });

  factory DestinoTuristicoModel.fromJson(Map<String, dynamic> json) {
    return DestinoTuristicoModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      municipio: json['municipio']?.toString(),
      horarioVisita: json['horarioVisita']?.toString(),
      imagenUrl: json['imagenUrl']?.toString(),
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0.0,
      calificacionPromedio:
          (json['calificacionPromedio'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
