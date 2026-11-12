import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../routes/domain/models/transport_route.dart';
import '../../domain/contribution_service.dart';
import '../../domain/models/contribution.dart';

/// Pantalla 11 – Calificar y contribuir.
class RateContributeScreen extends StatefulWidget {
  final TransportRoute route;
  final String? initialStopName;
  final ContributionService? contributionService;

  const RateContributeScreen({
    super.key,
    required this.route,
    this.initialStopName,
    this.contributionService,
  });

  @override
  State<RateContributeScreen> createState() => _RateContributeScreenState();
}

class _RateContributeScreenState extends State<RateContributeScreen> {
  late final ContributionService _service;

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _fareController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _overallRating = 0;
  final Map<RatingCategory, int> _categoryRatings = {
    for (final category in RatingCategory.values) category: 0,
  };
  PaymentMethod _paymentMethod = PaymentMethod.unknown;
  bool _anonymous = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _service = widget.contributionService ?? ContributionService.instance;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _fareController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _runSubmission(Future<void> Function() action) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      await action();
    } on ContributionValidationException catch (error) {
      if (mounted) AppFeedback.showError(context, error.message);
    } catch (_) {
      if (mounted) {
        AppFeedback.showError(
          context,
          'No se pudo guardar la contribución. Intenta de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitExperience() async {
    if (_overallRating == 0) {
      AppFeedback.showError(
        context,
        'Selecciona una calificación general de 1 a 5 estrellas.',
      );
      return;
    }

    await _runSubmission(() async {
      final result = await _service.submitExperience(
        routeId: widget.route.id,
        overallRating: _overallRating,
        categoryRatings: Map<RatingCategory, int>.from(_categoryRatings),
        comment: _commentController.text,
      );
      if (!mounted) return;
      AppFeedback.showSuccess(context, result.message);
    });
  }

  Future<void> _submitFare() async {
    final amount = double.tryParse(
      _fareController.text.replaceAll(',', '.').trim(),
    );
    if (amount == null || amount <= 0) {
      AppFeedback.showError(
          context, 'Ingresa un importe válido mayor que cero.');
      return;
    }

    await _runSubmission(() async {
      final result = await _service.submitFareReport(
        routeId: widget.route.id,
        officialFare: widget.route.fare,
        reportedFare: amount,
        paymentMethod: _paymentMethod,
      );
      if (!mounted) return;
      AppFeedback.showSuccess(context, result.message);
    });
  }

  Future<void> _submitConcessionaireReport() async {
    if (_subjectController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      AppFeedback.showError(
        context,
        'Completa el asunto y la descripción de la situación.',
      );
      return;
    }

    await _runSubmission(() async {
      final result = await _service.submitConcessionaireReport(
        routeId: widget.route.id,
        subject: _subjectController.text,
        description: _descriptionController.text,
        anonymous: _anonymous,
      );
      if (!mounted) return;
      AppFeedback.showSuccess(context, result.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificar y contribuir'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _ContextCard(
            route: widget.route,
            stopName: widget.initialStopName,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.star_outline_rounded,
            title: 'A. Calificar experiencia',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calificación general',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 6),
                _StarRating(
                  value: _overallRating,
                  size: 34,
                  onChanged: (value) => setState(() => _overallRating = value),
                ),
                const SizedBox(height: 12),
                for (final category in RatingCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.label,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.neutralDark,
                            ),
                          ),
                        ),
                        _StarRating(
                          value: _categoryRatings[category] ?? 0,
                          size: 22,
                          onChanged: (value) => setState(
                            () => _categoryRatings[category] = value,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
                _TextFieldBlock(
                  controller: _commentController,
                  label: 'Comentario opcional',
                  hint: 'Cuéntanos cómo fue tu experiencia',
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 4),
                AppPrimaryButton(
                  text: 'Enviar calificación',
                  icon: Icons.send_rounded,
                  height: 48,
                  isLoading: _isSubmitting,
                  onPressed: _submitExperience,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.payments_outlined,
            title: 'B. Reportar tarifa',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 18,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tarifa oficial registrada: ',
                        style: AppTypography.bodySmall.copyWith(fontSize: 12),
                      ),
                      Text(
                        widget.route.fareLabel,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _TextFieldBlock(
                  controller: _fareController,
                  label: 'Importe observado',
                  hint: 'Ej. 12.50',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                AppDropdown<PaymentMethod>(
                  label: 'Método de pago',
                  hint: 'Selecciona si aplica',
                  value: _paymentMethod,
                  items: [
                    for (final method in PaymentMethod.values)
                      AppDropdownItem(
                        value: method,
                        label: method.label,
                      ),
                  ],
                  onChanged: (value) => setState(
                    () => _paymentMethod = value ?? PaymentMethod.unknown,
                  ),
                ),
                const SizedBox(height: 10),
                const _Disclaimer(
                  text:
                      'Las aportaciones son reportes pendientes de validación. '
                      'No modifican automáticamente la tarifa oficial.',
                ),
                const SizedBox(height: 12),
                AppPrimaryButton(
                  text: 'Reportar tarifa',
                  icon: Icons.flag_outlined,
                  height: 48,
                  isLoading: _isSubmitting,
                  onPressed: _submitFare,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.campaign_outlined,
            title: 'C. Reportar a la concesionaria',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextFieldBlock(
                  controller: _subjectController,
                  label: 'Asunto',
                  hint: 'Ej. Unidad sin aire acondicionado',
                ),
                const SizedBox(height: 10),
                _TextFieldBlock(
                  controller: _descriptionController,
                  label: 'Descripción de la situación',
                  hint: 'Describe qué ocurrió y en qué parada o tramo',
                  maxLines: 4,
                  maxLength: 1000,
                ),
                AppCheckbox(
                  value: _anonymous,
                  onChanged: (value) =>
                      setState(() => _anonymous = value ?? false),
                  labelText: 'Contribución anónima',
                  subtitleText:
                      'Tu nombre no se mostrará a la concesionaria. La API aún '
                      'no recibe estos reportes.',
                ),
                const SizedBox(height: 8),
                AppPrimaryButton(
                  text: 'Enviar contribución',
                  icon: Icons.send_rounded,
                  height: 48,
                  isLoading: _isSubmitting,
                  onPressed: _submitConcessionaireReport,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            icon: Icons.card_giftcard_rounded,
            title: 'D. Recompensas',
            child: _service.rewardsImplemented
                ? const Text(
                    'El sistema de recompensas está habilitado.',
                    style: AppTypography.bodySmall,
                  )
                : const Text(
                    'El sistema de recompensas aún no está implementado. No se '
                    'otorgan puntos ni beneficios por estas contribuciones.',
                    style: AppTypography.bodySmall,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContextCard extends StatelessWidget {
  final TransportRoute route;
  final String? stopName;

  const _ContextCard({required this.route, this.stopName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              route.code,
              style: const TextStyle(
                color: AppColors.surfaceWhite,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stopName == null
                      ? route.companyName
                      : '$stopName · ${route.companyName}',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: AppTypography.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int value;
  final double size;
  final ValueChanged<int> onChanged;

  const _StarRating({
    required this.value,
    required this.size,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= 5; star++)
          GestureDetector(
            onTap: () => onChanged(star),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(
                star <= value ? Icons.star_rounded : Icons.star_border_rounded,
                size: size,
                color:
                    star <= value ? AppColors.warning : AppColors.disabledText,
              ),
            ),
          ),
      ],
    );
  }
}

class _TextFieldBlock extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  const _TextFieldBlock({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            counterStyle: AppTypography.bodySmall.copyWith(fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  final String text;

  const _Disclaimer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
