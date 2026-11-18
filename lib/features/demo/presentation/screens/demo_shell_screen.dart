import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'demo_compare_screen.dart';
import 'demo_home_screen.dart';
import 'demo_map_screen.dart';
import 'demo_profile_screen.dart';

/// Contenedor de la Simulación Demostrativa e Interactiva (Sección 7).
///
/// 100% aislada del backend, sin acelerómetro, sin permisos de teléfono ni BD.
class DemoShellScreen extends StatefulWidget {
  final VoidCallback onExitDemo;

  const DemoShellScreen({
    super.key,
    required this.onExitDemo,
  });

  @override
  State<DemoShellScreen> createState() => _DemoShellScreenState();
}

class _DemoShellScreenState extends State<DemoShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner superior indicativo de Modo Demostración
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.surfaceWhite, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Modo Demostración · Simulación local sin conexión',
                      style: TextStyle(
                        color: AppColors.surfaceWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onExitDemo,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Salir',
                            style: TextStyle(
                              color: AppColors.surfaceWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.close_rounded,
                              size: 14, color: AppColors.surfaceWhite),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pantallas de la demo
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                DemoHomeScreen(
                  onGoToMap: () => setState(() => _currentIndex = 1),
                  onGoToCompare: () => setState(() => _currentIndex = 2),
                ),
                const DemoMapScreen(),
                const DemoCompareScreen(),
                DemoProfileScreen(
                  onExitDemo: widget.onExitDemo,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.surfaceWhite,
        indicatorColor: AppColors.tertiary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Inicio Demo',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.primary),
            label: 'Mapa Demo',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_rounded),
            selectedIcon:
                Icon(Icons.compare_arrows_rounded, color: AppColors.primary),
            label: 'Comparar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Perfil Demo',
          ),
        ],
      ),
    );
  }
}
