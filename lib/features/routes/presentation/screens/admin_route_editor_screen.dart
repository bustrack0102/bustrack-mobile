import 'package:flutter/material.dart';

import '../../../../core/map/map_config.dart';
import '../../../../core/map/map_controller_service.dart';
import '../../../../core/map/map_view.dart';
import '../../../../core/map/models/app_map_marker.dart';
import '../../../../core/map/models/app_route_polyline.dart';
import '../../../../core/map/models/geo_point.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/azure_catalog_remote_data_source.dart';
import '../../data/models/api_models.dart';
import '../../domain/models/route_stop.dart';
import '../../domain/models/transport_route.dart';

/// Editor cartográfico de rutas para administradores (Sección 3.3).
class AdminRouteEditorScreen extends StatefulWidget {
  final TransportRoute? initialRoute;
  final VoidCallback? onSaved;

  const AdminRouteEditorScreen({
    super.key,
    this.initialRoute,
    this.onSaved,
  });

  @override
  State<AdminRouteEditorScreen> createState() => _AdminRouteEditorScreenState();
}

class _AdminRouteEditorScreenState extends State<AdminRouteEditorScreen> {
  final MapControllerService _mapController = MapControllerService();
  final AzureCatalogRemoteDataSource _catalogSource =
      AzureCatalogRemoteDataSource();

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _fareController = TextEditingController();

  List<EmpresaModel> _empresas = [];
  String? _selectedEmpresaId;

  final List<RouteStop> _stops = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _fareController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    try {
      final empresas = await _catalogSource.getEmpresas();
      if (mounted) {
        setState(() => _empresas = empresas);
      }
    } catch (_) {}

    final initial = widget.initialRoute;
    if (initial != null) {
      _codeController.text = initial.code;
      _nameController.text = initial.name;
      _originController.text = initial.originName;
      _destinationController.text = initial.destinationName;
      _fareController.text = initial.fareMxn.toString();
      _stops.addAll(initial.orderedStops);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _addStopAtCenter() {
    const center = MapConfig.defaultCenter;
    final newOrder = _stops.length + 1;
    final newStop = RouteStop(
      id: 'temp-stop-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Nueva Parada #$newOrder',
      location: GeoPoint(
        center.latitude + (newOrder * 0.003),
        center.longitude + (newOrder * 0.003),
      ),
      order: newOrder,
      address: 'Coordenadas seleccionadas',
    );

    setState(() => _stops.add(newStop));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Parada #$newOrder agregada al recorrido.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeStop(int index) {
    setState(() {
      _stops.removeAt(index);
      for (int i = 0; i < _stops.length; i++) {
        _stops[i] = _stops[i].copyWith(order: i + 1);
      }
    });
  }

  void _moveStopUp(int index) {
    if (index > 0) {
      setState(() {
        final item = _stops.removeAt(index);
        _stops.insert(index - 1, item);
        for (int i = 0; i < _stops.length; i++) {
          _stops[i] = _stops[i].copyWith(order: i + 1);
        }
      });
    }
  }

  void _moveStopDown(int index) {
    if (index < _stops.length - 1) {
      setState(() {
        final item = _stops.removeAt(index);
        _stops.insert(index + 1, item);
        for (int i = 0; i < _stops.length; i++) {
          _stops[i] = _stops[i].copyWith(order: i + 1);
        }
      });
    }
  }

  void _editStopCoordinates(int index) {
    final stop = _stops[index];
    final latController =
        TextEditingController(text: stop.latitude?.toString() ?? '');
    final lngController =
        TextEditingController(text: stop.longitude?.toString() ?? '');
    final nameController = TextEditingController(text: stop.name);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Editar Parada #${stop.order}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre de parada'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: latController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Latitud'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lngController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Longitud'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final lat = double.tryParse(latController.text);
              final lng = double.tryParse(lngController.text);
              if (lat != null && lng != null) {
                setState(() {
                  _stops[index] = stop.copyWith(
                    name: nameController.text.trim(),
                    latitude: lat,
                    longitude: lng,
                  );
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_stops.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
                'Una ruta debe tener al menos 2 paradas (Origen y Destino)'),
          ),
        );
        return;
      }

      setState(() => _isSaving = true);

      // Simulación de envío y persistencia en Azure REST API
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Ruta y secuencia de paradas guardadas exitosamente.'),
        ),
      );

      widget.onSaved?.call();
      Navigator.of(context).pop();
    }
  }

  List<AppMapMarker> _buildMarkers() {
    return _stops
        .where((s) => s.hasValidCoordinates)
        .map((s) => AppMapMarker(
              id: s.id,
              point: s.point,
              label: '${s.order}. ${s.name}',
              subtitle: 'Lat: ${s.latitude}, Lng: ${s.longitude}',
              kind: s.order == 1
                  ? AppMapMarkerKind.origin
                  : (s.order == _stops.length
                      ? AppMapMarkerKind.destination
                      : AppMapMarkerKind.stop),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final validPoints =
        _stops.where((s) => s.hasValidCoordinates).map((s) => s.point).toList();

    final polyline = AppRoutePolyline(
      id: 'admin-preview-route',
      points: validPoints,
      color: AppColors.primary,
      strokeWidth: 4.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialRoute == null
            ? 'Crear Nueva Ruta'
            : 'Editar Ruta: ${_codeController.text}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.primary),
            onPressed: _isSaving ? null : _handleSave,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mitad superior: Mapa interactivo de trazado
                  SizedBox(
                    height: 240,
                    child: Stack(
                      children: [
                        AppMapView(
                          controllerService: _mapController,
                          initialCenter: validPoints.isNotEmpty
                              ? validPoints.first
                              : MapConfig.defaultCenter,
                          initialZoom: 13.0,
                          markers: _buildMarkers(),
                          polylines: [polyline],
                        ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: FloatingActionButton.small(
                            heroTag: 'add_stop_map_btn',
                            backgroundColor: AppColors.primary,
                            onPressed: _addStopAtCenter,
                            tooltip: 'Agregar punto de parada',
                            child: const Icon(Icons.add_location_rounded,
                                color: AppColors.surfaceWhite),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mitad inferior: Formulario y secuencia de paradas
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  label: 'Código de Ruta',
                                  hintText: 'Ej. R-102',
                                  controller: _codeController,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Requerido'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  label: 'Tarifa (MXN)',
                                  hintText: '13.50',
                                  controller: _fareController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Nombre Completo de la Ruta',
                            hintText: 'Ej. Troncal Sur - San Jerónimo',
                            controller: _nameController,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Requerido' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Punto de Origen',
                                  hintText: 'Terminal Norte',
                                  controller: _originController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Destino Final',
                                  hintText: 'Centro Histórico',
                                  controller: _destinationController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Empresa responsable
                          if (_empresas.isNotEmpty) ...[
                            const Text('Empresa Responsable',
                                style: AppTypography.labelLarge),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedEmpresaId ?? _empresas.first.id,
                              items: _empresas
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.nombre),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedEmpresaId = v),
                            ),
                            const SizedBox(height: 18),
                          ],

                          // Secuencia de Paradas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Secuencia de Paradas (${_stops.length})',
                                style: AppTypography.titleMedium,
                              ),
                              TextButton.icon(
                                onPressed: _addStopAtCenter,
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('Agregar parada'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _stops.length,
                            itemBuilder: (context, index) {
                              final stop = _stops[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: index == 0
                                        ? AppColors.primary
                                        : (index == _stops.length - 1
                                            ? AppColors.secondary
                                            : AppColors.inputBorder),
                                    child: Text(
                                      '${stop.order}',
                                      style: TextStyle(
                                        color: index == 0 ||
                                                index == _stops.length - 1
                                            ? AppColors.surfaceWhite
                                            : AppColors.neutralDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(stop.name,
                                      style: AppTypography.labelLarge),
                                  subtitle: Text(
                                    'Lat: ${stop.latitude?.toStringAsFixed(4)}, Lng: ${stop.longitude?.toStringAsFixed(4)}',
                                    style: AppTypography.labelSmall,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.edit_location_rounded,
                                            size: 20),
                                        onPressed: () =>
                                            _editStopCoordinates(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.arrow_upward_rounded,
                                            size: 18),
                                        onPressed: index > 0
                                            ? () => _moveStopUp(index)
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.arrow_downward_rounded,
                                            size: 18),
                                        onPressed: index < _stops.length - 1
                                            ? () => _moveStopDown(index)
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                            size: 20),
                                        onPressed: () => _removeStop(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: 'Guardar Ruta y Conexiones en Backend',
                            isLoading: _isSaving,
                            icon: Icons.save_rounded,
                            onPressed: _handleSave,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
