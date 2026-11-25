import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../routes/data/recomendaciones_remote_data_source.dart';

/// Pantalla interactiva del Asistente de Viaje Inteligente impulsado por IA Generativa.
class AiTripAssistantScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AiTripAssistantScreen({super.key, this.onBack});

  @override
  State<AiTripAssistantScreen> createState() => _AiTripAssistantScreenState();
}

class _AiTripAssistantScreenState extends State<AiTripAssistantScreen> {
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();
  final _preferenciasController = TextEditingController();
  final _dataSource = RecomendacionesRemoteDataSource();

  bool _isLoading = false;
  RecomendacionResponse? _currentRecommendation;
  List<RecomendacionResponse> _historial = const [];
  bool _feedbackSent = false;
  String? _errorMessage;

  final List<String> _quickPreferences = [
    'Ruta más rápida',
    'Menor costo',
    'Menos transbordos',
    'Unidades con accesibilidad',
    'Horario pico matutino',
  ];
  final Set<String> _selectedQuickPrefs = {};

  @override
  void initState() {
    super.initState();
    _loadHistorial();
  }

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    _preferenciasController.dispose();
    super.dispose();
  }

  Future<void> _loadHistorial() async {
    try {
      final items = await _dataSource.getHistorial();
      if (mounted) {
        setState(() => _historial = items);
      }
    } catch (_) {}
  }

  Future<void> _handleSolicitar() async {
    final origen = _origenController.text.trim();
    final destino = _destinoController.text.trim();

    if (origen.isEmpty || destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          content: Text('Por favor ingresa tanto el origen como el destino.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _feedbackSent = false;
    });

    final prefsList = [
      ..._selectedQuickPrefs,
      if (_preferenciasController.text.trim().isNotEmpty)
        _preferenciasController.text.trim(),
    ];

    try {
      final res = await _dataSource.solicitarRecomendacion(
        RecomendacionRequest(
          origen: origen,
          destino: destino,
          horario: TimeOfDay.now().format(context),
          preferencias: prefsList.isEmpty ? null : prefsList,
        ),
      );

      if (!mounted) return;

      if (res != null) {
        setState(() {
          _currentRecommendation = res;
          _isLoading = false;
        });
        _loadHistorial();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'El servicio de IA está procesando solicitudes en Azure. Intenta nuevamente en unos instantes.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo conectar con el servicio de IA: $e';
      });
    }
  }

  Future<void> _handleFeedback(bool util) async {
    final recId = _currentRecommendation?.id;
    if (recId == null || _feedbackSent) return;

    final ok = await _dataSource.enviarRetroalimentacion(
      recomendacionId: recId,
      util: util,
    );

    if (mounted && ok) {
      setState(() => _feedbackSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          content: Text('¡Gracias por tu retroalimentación!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Asistente de Viaje IA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Hero con estética BusTrack
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.surfaceWhite,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Planificación Inteligente',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.surfaceWhite,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Describe a dónde deseas trasladarte y recibe itinerarios óptimos asistidos por IA.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.tertiary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Formulario de Origen y Destino
              const Text('¿A dónde viajas?', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.inputBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _origenController,
                      decoration: const InputDecoration(
                        labelText: 'Punto de partida u origen',
                        hintText: 'Ej. Centro Histórico o Terminal',
                        prefixIcon: Icon(Icons.trip_origin_rounded,
                            color: AppColors.success, size: 20),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _destinoController,
                      decoration: const InputDecoration(
                        labelText: 'Destino final',
                        hintText: 'Ej. Campus Universitario o Hospital',
                        prefixIcon: Icon(Icons.flag_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Preferencias de viaje (opcional):',
                        style: AppTypography.labelSmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _quickPreferences.map((pref) {
                        final selected = _selectedQuickPrefs.contains(pref);
                        return FilterChip(
                          label: Text(pref),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedQuickPrefs.add(pref);
                              } else {
                                _selectedQuickPrefs.remove(pref);
                              }
                            });
                          },
                          selectedColor: AppColors.tertiary,
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.secondary
                                : AppColors.neutralDark,
                          ),
                          backgroundColor: AppColors.inputBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.inputBorder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _preferenciasController,
                      decoration: const InputDecoration(
                        labelText: 'Otra indicación específica',
                        hintText: 'Ej. Evitar transbordos largos a pie',
                        prefixIcon: Icon(Icons.tune_rounded,
                            color: AppColors.secondary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Consultar Itinerario IA',
                      icon: Icons.auto_awesome_rounded,
                      isLoading: _isLoading,
                      onPressed: _handleSolicitar,
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Resultado de Recomendación
              if (_currentRecommendation != null) ...[
                const SizedBox(height: 24),
                const Text('Recomendación generada',
                    style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Itinerario Asistido',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (_currentRecommendation!.costoAproximadoMxn !=
                              null)
                            Text(
                              '\$${_currentRecommendation!.costoAproximadoMxn!.toStringAsFixed(2)} MXN',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentRecommendation!.recomendacion,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: AppColors.neutralDark,
                        ),
                      ),
                      if (_currentRecommendation!
                          .rutasSugeridas.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        const Divider(color: AppColors.inputBorder),
                        const SizedBox(height: 8),
                        const Text('Rutas sugeridas:',
                            style: AppTypography.labelSmall),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: _currentRecommendation!.rutasSugeridas
                              .map((r) => Chip(
                                    label: Text(r),
                                    backgroundColor: AppColors.inputBackground,
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.secondary,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Feedback de utilidad
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '¿Te resultó útil?',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 20,
                              color: _feedbackSent
                                  ? AppColors.disabledText
                                  : AppColors.success,
                            ),
                            onPressed: _feedbackSent
                                ? null
                                : () => _handleFeedback(true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.thumb_down_alt_outlined,
                              size: 20,
                              color: _feedbackSent
                                  ? AppColors.disabledText
                                  : AppColors.error,
                            ),
                            onPressed: _feedbackSent
                                ? null
                                : () => _handleFeedback(false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Historial reciente de consultas
              if (_historial.isNotEmpty) ...[
                const SizedBox(height: 28),
                const Text('Consultas anteriores',
                    style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                for (final h in _historial.take(3)) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.recomendacion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.neutralDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          h.fechaCreacion,
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
