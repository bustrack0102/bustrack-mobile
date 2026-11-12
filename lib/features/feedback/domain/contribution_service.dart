import 'models/contribution.dart';

class ExperienceContribution {
  final String routeId;
  final int overallRating;
  final Map<RatingCategory, int> categoryRatings;
  final String comment;
  final DateTime submittedAt;

  const ExperienceContribution({
    required this.routeId,
    required this.overallRating,
    required this.categoryRatings,
    required this.comment,
    required this.submittedAt,
  });
}

class FareContribution {
  final String routeId;
  final double officialFare;
  final double reportedFare;
  final PaymentMethod paymentMethod;
  final DateTime submittedAt;

  const FareContribution({
    required this.routeId,
    required this.officialFare,
    required this.reportedFare,
    required this.paymentMethod,
    required this.submittedAt,
  });
}

class ConcessionaireContribution {
  final String routeId;
  final String subject;
  final String description;
  final bool anonymous;
  final DateTime submittedAt;

  const ConcessionaireContribution({
    required this.routeId,
    required this.subject,
    required this.description,
    required this.anonymous,
    required this.submittedAt,
  });
}

/// Servicio de contribuciones.
///
/// El backend (`POST /api/v1/calificaciones` y reportes de tarifa) está en
/// estado propuesto. Por eso las aportaciones se guardan únicamente en memoria
/// local y el resultado indica explícitamente `syncedWithApi: false`. No se
/// otorgan recompensas porque ese sistema no está implementado.
class ContributionService {
  ContributionService({this.delay = const Duration(milliseconds: 350)});

  static final ContributionService instance = ContributionService();

  final Duration delay;

  final List<ExperienceContribution> _experiences = [];
  final List<FareContribution> _fareReports = [];
  final List<ConcessionaireContribution> _concessionaireReports = [];

  bool get rewardsImplemented => false;

  List<ExperienceContribution> get experiences =>
      List.unmodifiable(_experiences);
  List<FareContribution> get fareReports => List.unmodifiable(_fareReports);
  List<ConcessionaireContribution> get concessionaireReports =>
      List.unmodifiable(_concessionaireReports);

  Future<ContributionResult> submitExperience({
    required String routeId,
    required int overallRating,
    required Map<RatingCategory, int> categoryRatings,
    String comment = '',
  }) async {
    await Future<void>.delayed(delay);

    if (overallRating < 1 || overallRating > 5) {
      throw const ContributionValidationException(
        'La calificación general debe estar entre 1 y 5 estrellas.',
      );
    }
    if (categoryRatings.values.any((value) => value < 0 || value > 5)) {
      throw const ContributionValidationException(
        'Cada categoría debe estar entre 0 y 5.',
      );
    }
    if (comment.trim().length > 500) {
      throw const ContributionValidationException(
        'El comentario no puede superar 500 caracteres.',
      );
    }

    _experiences.add(
      ExperienceContribution(
        routeId: routeId,
        overallRating: overallRating,
        categoryRatings: Map.unmodifiable(categoryRatings),
        comment: comment.trim(),
        submittedAt: DateTime.now(),
      ),
    );

    return const ContributionResult(
      storedLocally: true,
      syncedWithApi: false,
      message: 'Calificación guardada localmente. La sincronización con la API '
          'central está pendiente.',
    );
  }

  Future<ContributionResult> submitFareReport({
    required String routeId,
    required double officialFare,
    required double reportedFare,
    required PaymentMethod paymentMethod,
  }) async {
    await Future<void>.delayed(delay);

    if (reportedFare <= 0) {
      throw const ContributionValidationException(
        'El importe observado debe ser mayor que cero.',
      );
    }

    _fareReports.add(
      FareContribution(
        routeId: routeId,
        officialFare: officialFare,
        reportedFare: reportedFare,
        paymentMethod: paymentMethod,
        submittedAt: DateTime.now(),
      ),
    );

    return const ContributionResult(
      storedLocally: true,
      syncedWithApi: false,
      message:
          'Reporte de tarifa guardado localmente como pendiente de validación. '
          'La tarifa oficial no cambia automáticamente.',
    );
  }

  Future<ContributionResult> submitConcessionaireReport({
    required String routeId,
    required String subject,
    required String description,
    required bool anonymous,
  }) async {
    await Future<void>.delayed(delay);

    if (subject.trim().isEmpty || description.trim().isEmpty) {
      throw const ContributionValidationException(
        'Describe la situación antes de enviar el reporte.',
      );
    }
    if (description.trim().length > 1000) {
      throw const ContributionValidationException(
        'La descripción no puede superar 1000 caracteres.',
      );
    }

    _concessionaireReports.add(
      ConcessionaireContribution(
        routeId: routeId,
        subject: subject.trim(),
        description: description.trim(),
        anonymous: anonymous,
        submittedAt: DateTime.now(),
      ),
    );

    return const ContributionResult(
      storedLocally: true,
      syncedWithApi: false,
      message:
          'Reporte a la concesionaria guardado localmente. La API central aún '
          'no recibe esta contribución.',
    );
  }

  void clear() {
    _experiences.clear();
    _fareReports.clear();
    _concessionaireReports.clear();
  }
}
