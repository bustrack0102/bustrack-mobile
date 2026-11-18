import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/azure_route_repository.dart';
import '../../domain/models/transport_route.dart';
import '../../domain/repositories/route_repository.dart';
import 'admin_route_editor_screen.dart';

/// Pantalla administrativa para la gestión y alta de rutas en el mapa (Sección 3.3).
class AdminRouteManagementScreen extends StatefulWidget {
  final RouteRepository? repository;

  const AdminRouteManagementScreen({super.key, this.repository});

  @override
  State<AdminRouteManagementScreen> createState() =>
      _AdminRouteManagementScreenState();
}

class _AdminRouteManagementScreenState
    extends State<AdminRouteManagementScreen> {
  late final RouteRepository _repository;
  final _searchController = TextEditingController();

  List<TransportRoute> _routes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? AzureRouteRepository();
    _loadRoutes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final routes = await _repository.getRoutes(
        query: _searchController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _routes = routes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudieron cargar las rutas para administración.';
      });
    }
  }

  void _navigateToCreate() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AdminRouteEditorScreen(
          onSaved: () {
            _loadRoutes();
          },
        ),
      ),
    );
  }

  void _navigateToEdit(TransportRoute route) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AdminRouteEditorScreen(
          initialRoute: route,
          onSaved: () {
            _loadRoutes();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Gestión de Rutas y Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadRoutes,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera informativa de rol administrativo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.secondary,
              child: const Row(
                children: [
                  Icon(Icons.admin_panel_settings_rounded,
                      color: AppColors.surfaceWhite, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Módulo Administrativo: Creación y edición geográfica de rutas y paradas.',
                      style: TextStyle(
                        color: AppColors.surfaceWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buscador
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _loadRoutes(),
                decoration: InputDecoration(
                  hintText: 'Buscar por código, nombre o empresa...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.secondary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.primary),
                    onPressed: _loadRoutes,
                  ),
                ),
              ),
            ),

            // Lista de rutas
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_rounded,
                                    size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                Text(_errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMedium),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadRoutes,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _routes.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron rutas registradas.',
                                style: AppTypography.bodySmall,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              itemCount: _routes.length,
                              itemBuilder: (context, index) {
                                final route = _routes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceWhite,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppColors.inputBorder),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          route.code,
                                          style: const TextStyle(
                                            color: AppColors.surfaceWhite,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(route.name,
                                                style:
                                                    AppTypography.titleSmall),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${route.originName} → ${route.destinationName}',
                                              style: AppTypography.bodySmall,
                                            ),
                                            Text(
                                              'Empresa: ${route.companyName}',
                                              style: AppTypography.labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.edit_location_alt_rounded,
                                            color: AppColors.secondary),
                                        tooltip: 'Editar trazado y paradas',
                                        onPressed: () => _navigateToEdit(route),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt_rounded,
            color: AppColors.surfaceWhite),
        label: const Text('Nueva Ruta',
            style: TextStyle(
                color: AppColors.surfaceWhite, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
