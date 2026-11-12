import 'package:bustrack_mobile/features/feedback/domain/contribution_service.dart';
import 'package:bustrack_mobile/features/feedback/domain/models/contribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributionService', () {
    late ContributionService service;

    setUp(() {
      service = ContributionService(delay: Duration.zero);
    });

    test('no hay sistema de recompensas implementado', () {
      expect(service.rewardsImplemented, isFalse);
    });

    test('valida la calificación general', () async {
      expect(
        () => service.submitExperience(
          routeId: 'ruta-102',
          overallRating: 0,
          categoryRatings: const {},
        ),
        throwsA(isA<ContributionValidationException>()),
      );
      expect(service.experiences, isEmpty);
    });

    test('guarda la calificación localmente sin sincronizar', () async {
      final result = await service.submitExperience(
        routeId: 'ruta-102',
        overallRating: 4,
        categoryRatings: const {
          RatingCategory.cleanliness: 5,
          RatingCategory.punctuality: 3,
        },
        comment: 'Buen servicio',
      );

      expect(result.storedLocally, isTrue);
      expect(result.syncedWithApi, isFalse);
      expect(service.experiences, hasLength(1));
    });

    test('valida y guarda reportes de tarifa', () async {
      expect(
        () => service.submitFareReport(
          routeId: 'ruta-102',
          officialFare: 10,
          reportedFare: 0,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(isA<ContributionValidationException>()),
      );

      final result = await service.submitFareReport(
        routeId: 'ruta-102',
        officialFare: 10,
        reportedFare: 12,
        paymentMethod: PaymentMethod.cash,
      );

      expect(result.syncedWithApi, isFalse);
      expect(service.fareReports, hasLength(1));
      expect(service.fareReports.first.reportedFare, 12);
    });

    test('validate y guarda reportes a la concesionaria', () async {
      expect(
        () => service.submitConcessionaireReport(
          routeId: 'ruta-102',
          subject: '',
          description: '',
          anonymous: false,
        ),
        throwsA(isA<ContributionValidationException>()),
      );

      final result = await service.submitConcessionaireReport(
        routeId: 'ruta-102',
        subject: 'Unidad',
        description: 'Sin aire acondicionado',
        anonymous: true,
      );

      expect(result.storedLocally, isTrue);
      expect(service.concessionaireReports, hasLength(1));
      expect(service.concessionaireReports.first.anonymous, isTrue);
    });
  });
}
