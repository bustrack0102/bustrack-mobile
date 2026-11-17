import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/azure_catalog_remote_data_source.dart';
import '../../data/models/api_models.dart';

/// Campo de texto con autocompletado de paradas contra
/// `GET /api/v1/paradas/autocompletar`.
///
/// Reporta la parada seleccionada mediante [onParadaSelected]; si el usuario
/// edita el texto después de elegir una sugerencia, la selección se invalida
/// (se reporta `null`) para no buscar con un id obsoleto.
class ParadaAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final ValueChanged<String>? onSubmitted;
  final Widget? trailing;
  final ValueChanged<ParadaModel?> onParadaSelected;
  final AzureCatalogRemoteDataSource? dataSource;

  const ParadaAutocompleteField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.onParadaSelected,
    this.onSubmitted,
    this.trailing,
    this.dataSource,
  });

  @override
  State<ParadaAutocompleteField> createState() =>
      _ParadaAutocompleteFieldState();
}

class _ParadaAutocompleteFieldState extends State<ParadaAutocompleteField> {
  late final AzureCatalogRemoteDataSource _dataSource;
  Timer? _debounce;
  List<ParadaModel> _suggestions = const [];
  bool _loading = false;
  bool _suppressNextFetch = false;

  @override
  void initState() {
    super.initState();
    _dataSource = widget.dataSource ?? AzureCatalogRemoteDataSource();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _handleTextChanged() {
    if (_suppressNextFetch) {
      _suppressNextFetch = false;
      return;
    }
    // El usuario editó manualmente: invalidar la parada elegida.
    widget.onParadaSelected(null);
    _debounce?.cancel();
    final query = widget.controller.text.trim();
    if (query.length < 2) {
      setState(() {
        _suggestions = const [];
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _fetch(query));
  }

  Future<void> _fetch(String query) async {
    setState(() => _loading = true);
    try {
      final results = await _dataSource.autocompletarParadas(query);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = const [];
        _loading = false;
      });
    }
  }

  void _select(ParadaModel parada) {
    _suppressNextFetch = true;
    widget.controller.text = parada.nombre;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
    widget.onParadaSelected(parada);
    setState(() => _suggestions = const []);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          onSubmitted: widget.onSubmitted,
          textInputAction: TextInputAction.search,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: Icon(widget.icon, size: 18, color: widget.iconColor),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 38, minHeight: 38),
            suffixIcon: widget.trailing ??
                (_loading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 38, minHeight: 38),
          ),
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final parada = _suggestions[index];
                final subtitle = [
                  if (parada.municipio != null && parada.municipio!.isNotEmpty)
                    parada.municipio!,
                  if (parada.distanciaMetros != null)
                    '${parada.distanciaMetros!.toStringAsFixed(0)} m',
                ].join(' · ');
                return ListTile(
                  dense: true,
                  leading: Icon(
                    parada.esTerminal
                        ? Icons.directions_bus_filled_rounded
                        : Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                  title: Text(
                    parada.nombre,
                    style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                  ),
                  subtitle: subtitle.isEmpty
                      ? null
                      : Text(
                          subtitle,
                          style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        ),
                  onTap: () => _select(parada),
                );
              },
            ),
          ),
      ],
    );
  }
}
