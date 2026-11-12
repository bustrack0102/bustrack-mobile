/// Tipo de registro del historial.
enum JourneyStatus { inProgress, completed, cancelled }

extension JourneyStatusLabel on JourneyStatus {
  String get label => switch (this) {
        JourneyStatus.inProgress => 'En curso',
        JourneyStatus.completed => 'Completado',
        JourneyStatus.cancelled => 'Cancelado',
      };
}

/// Búsqueda de rutas registrada por el usuario.
class RouteSearchRecord {
  final String id;
  final String origin;
  final String destination;
  final DateTime searchedAt;
  final String? routeId;
  final String? routeCode;
  final bool isDemo;

  const RouteSearchRecord({
    required this.id,
    required this.origin,
    required this.destination,
    required this.searchedAt,
    this.routeId,
    this.routeCode,
    this.isDemo = false,
  });
}

/// Recorrido realizado o en curso.
class JourneyRecord {
  final String id;
  final String routeId;
  final String routeCode;
  final String routeName;
  final String origin;
  final String destination;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final JourneyStatus status;
  final bool isDemo;

  const JourneyRecord({
    required this.id,
    required this.routeId,
    required this.routeCode,
    required this.routeName,
    required this.origin,
    required this.destination,
    required this.startedAt,
    required this.status,
    this.finishedAt,
    this.isDemo = false,
  });

  JourneyRecord copyWith({
    JourneyStatus? status,
    DateTime? finishedAt,
  }) {
    return JourneyRecord(
      id: id,
      routeId: routeId,
      routeCode: routeCode,
      routeName: routeName,
      origin: origin,
      destination: destination,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      isDemo: isDemo,
    );
  }
}
