import 'package:flutter/foundation.dart';

import 'models/journey_record.dart';

/// Historial local en memoria de búsquedas y viajes.
///
/// La API central aún no expone historial de usuario; este servicio mantiene
/// el estado de la sesión actual y no se presenta como persistencia remota.
class JourneyHistoryService extends ChangeNotifier {
  JourneyHistoryService();

  static final JourneyHistoryService instance = JourneyHistoryService();

  final List<RouteSearchRecord> _searches = [];
  final List<JourneyRecord> _journeys = [];

  List<RouteSearchRecord> get searches => List.unmodifiable(_searches);
  List<JourneyRecord> get journeys => List.unmodifiable(_journeys);

  bool get isEmpty => _searches.isEmpty && _journeys.isEmpty;

  void recordSearch({
    required String origin,
    required String destination,
    String? routeId,
    String? routeCode,
    bool isDemo = false,
  }) {
    _searches.insert(
      0,
      RouteSearchRecord(
        id: 'search-${DateTime.now().microsecondsSinceEpoch}',
        origin:
            origin.trim().isEmpty ? 'Origen no especificado' : origin.trim(),
        destination: destination.trim().isEmpty
            ? 'Destino no especificado'
            : destination.trim(),
        searchedAt: DateTime.now(),
        routeId: routeId,
        routeCode: routeCode,
        isDemo: isDemo,
      ),
    );
    notifyListeners();
  }

  JourneyRecord startJourney({
    required String routeId,
    required String routeCode,
    required String routeName,
    required String origin,
    required String destination,
    bool isDemo = false,
  }) {
    final journey = JourneyRecord(
      id: 'journey-${DateTime.now().microsecondsSinceEpoch}',
      routeId: routeId,
      routeCode: routeCode,
      routeName: routeName,
      origin: origin,
      destination: destination,
      startedAt: DateTime.now(),
      status: JourneyStatus.inProgress,
      isDemo: isDemo,
    );
    _journeys.insert(0, journey);
    notifyListeners();
    return journey;
  }

  void completeJourney(String journeyId) {
    final index = _journeys.indexWhere((journey) => journey.id == journeyId);
    if (index == -1) return;
    _journeys[index] = _journeys[index].copyWith(
      status: JourneyStatus.completed,
      finishedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void cancelJourney(String journeyId) {
    final index = _journeys.indexWhere((journey) => journey.id == journeyId);
    if (index == -1) return;
    _journeys[index] = _journeys[index].copyWith(
      status: JourneyStatus.cancelled,
      finishedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void clear() {
    _searches.clear();
    _journeys.clear();
    notifyListeners();
  }
}
