import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../routes/data/azure_catalog_remote_data_source.dart';
import '../../../routes/data/models/api_models.dart';

/// Pantalla "Descubrir" – Catálogos oficiales de la API de Azure:
/// medios de transporte, directorio de empresas y destinos turísticos.
class DiscoverScreen extends StatefulWidget {
  final AzureCatalogRemoteDataSource? dataSource;

  const DiscoverScreen({super.key, this.dataSource});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final AzureCatalogRemoteDataSource _dataSource;
  final TextEditingController _searchController = TextEditingController();

  List<MedioTransporteModel> _medios = const [];
  List<EmpresaModel> _empresas = const [];
  List<DestinoTuristicoModel> _destinos = const [];

  bool _loading = true;
  bool _searching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dataSource = widget.dataSource ?? AzureCatalogRemoteDataSource();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final query = _searchController.text.trim();
      final results = await Future.wait([
        _dataSource.getMediosTransporte(),
        _dataSource.getEmpresas(q: query.isEmpty ? null : query),
        _dataSource.getDestinos(),
      ]);
      if (!mounted) return;
      setState(() {
        _medios = results[0] as List<MedioTransporteModel>;
        _empresas = results[1] as List<EmpresaModel>;
        _destinos = results[2] as List<DestinoTuristicoModel>;
        _loading = false;
        _searching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _searching = false;
        _errorMessage =
            'No pudimos cargar los catálogos. Revisa tu conexión e inténtalo de nuevo.';
      });
    }
  }

  Future<void> _searchEmpresas(String value) async {
    setState(() => _searching = true);
    try {
      final query = value.trim();
      final empresas = await _dataSource.getEmpresas(
        q: query.isEmpty ? null : query,
      );
      if (!mounted) return;
      setState(() {
        _empresas = empresas;
        _searching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _searching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('No se pudieron filtrar las empresas.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        child: Builder(
          builder: (context) {
            if (_loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_errorMessage != null) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  OfflineStateWidget(
                    message: _errorMessage!,
                    onRetry: _loadAll,
                  ),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _SectionHeader(
                  title: 'Medios de transporte',
                  count: _medios.length,
                ),
                const SizedBox(height: 8),
                if (_medios.isEmpty)
                  const _EmptyHint(
                    text: 'La API no reportó medios de transporte registrados.',
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final medio in _medios)
                        Chip(
                          avatar: const Icon(
                            Icons.directions_bus_rounded,
                            size: 16,
                          ),
                          label: Text(medio.nombre),
                          backgroundColor: AppColors.inputBackground,
                          side: const BorderSide(color: AppColors.inputBorder),
                        ),
                    ],
                  ),
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Empresas y líneas',
                  count: _empresas.length,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  onSubmitted: _searchEmpresas,
                  textInputAction: TextInputAction.search,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Buscar empresa o línea…',
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.arrow_forward_rounded),
                            onPressed: () =>
                                _searchEmpresas(_searchController.text),
                          ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                if (_empresas.isEmpty)
                  const _EmptyHint(
                    text:
                        'Sin resultados. Prueba con otro término de búsqueda.',
                  )
                else
                  for (final empresa in _empresas) ...[
                    _EmpresaCard(empresa: empresa),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Destinos turísticos',
                  count: _destinos.length,
                ),
                const SizedBox(height: 8),
                if (_destinos.isEmpty)
                  const _EmptyHint(
                    text: 'La API no reportó destinos turísticos registrados.',
                  )
                else
                  for (final destino in _destinos) ...[
                    _DestinoCard(destino: destino),
                    const SizedBox(height: 10),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppTypography.titleMedium),
        ),
        Text(
          '$count',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(color: AppColors.neutralDark),
      ),
    );
  }
}

class _EmpresaCard extends StatelessWidget {
  final EmpresaModel empresa;

  const _EmpresaCard({required this.empresa});

  @override
  Widget build(BuildContext context) {
    final details = [
      if (empresa.siglas.isNotEmpty) empresa.siglas,
      if (empresa.municipioBase != null && empresa.municipioBase!.isNotEmpty)
        empresa.municipioBase!,
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                empresa.siglas.isNotEmpty
                    ? empresa.siglas
                        .substring(
                          0,
                          empresa.siglas.length > 3 ? 3 : empresa.siglas.length,
                        )
                        .toUpperCase()
                    : empresa.nombre
                        .substring(
                          0,
                          empresa.nombre.length > 2 ? 2 : empresa.nombre.length,
                        )
                        .toUpperCase(),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empresa.nombre,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (details.isNotEmpty)
                  Text(
                    details,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                  ),
                if (empresa.totalEvaluaciones > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${empresa.calificacionPromedio.toStringAsFixed(1)} '
                        '(${empresa.totalEvaluaciones})',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinoCard extends StatelessWidget {
  final DestinoTuristicoModel destino;

  const _DestinoCard({required this.destino});

  @override
  Widget build(BuildContext context) {
    final details = [
      if (destino.categoria.isNotEmpty) destino.categoria,
      if (destino.municipio != null && destino.municipio!.isNotEmpty)
        destino.municipio!,
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.place_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destino.nombre,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (details.isNotEmpty)
                  Text(
                    details,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                  ),
                if (destino.descripcion != null &&
                    destino.descripcion!.isNotEmpty)
                  Text(
                    destino.descripcion!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                  ),
              ],
            ),
          ),
          if (destino.calificacionPromedio > 0)
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  destino.calificacionPromedio.toStringAsFixed(1),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
