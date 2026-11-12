/// Categorías evaluables de la experiencia de viaje.
enum RatingCategory {
  cleanliness,
  punctuality,
  safeDriving,
  seating,
  airConditioning,
  music,
}

extension RatingCategoryLabel on RatingCategory {
  String get label => switch (this) {
        RatingCategory.cleanliness => 'Limpieza',
        RatingCategory.punctuality => 'Puntualidad',
        RatingCategory.safeDriving => 'Conducción segura',
        RatingCategory.seating => 'Asientos disponibles',
        RatingCategory.airConditioning => 'Aire acondicionado',
        RatingCategory.music => 'Música adecuada',
      };
}

/// Método de pago observado al reportar una tarifa.
enum PaymentMethod { cash, card, transfer, unknown }

extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Efectivo',
        PaymentMethod.card => 'Tarjeta',
        PaymentMethod.transfer => 'Transferencia',
        PaymentMethod.unknown => 'No especificado',
      };
}

/// Resultado de una contribución.
class ContributionResult {
  final bool storedLocally;
  final bool syncedWithApi;
  final String message;

  const ContributionResult({
    required this.storedLocally,
    required this.syncedWithApi,
    required this.message,
  });
}

class ContributionValidationException implements Exception {
  final String message;

  const ContributionValidationException(this.message);

  @override
  String toString() => message;
}
