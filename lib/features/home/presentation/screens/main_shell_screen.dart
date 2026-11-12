import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../history/presentation/screens/trip_history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../routes/presentation/screens/explore_routes_screen.dart';

/// Contenedor principal con navegación inferior de BusTrack.
class MainShellScreen extends StatefulWidget {
  final bool isDemoMode;
  final VoidCallback onLogout;

  const MainShellScreen({
    super.key,
    required this.isDemoMode,
    required this.onLogout,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  void _goToExplore() => setState(() => _selectedIndex = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const ExploreRoutesScreen(),
          TripHistoryScreen(onExplore: _goToExplore),
          ProfileScreen(
            isDemoMode: widget.isDemoMode,
            onLogout: widget.onLogout,
            onExplore: _goToExplore,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: AppColors.surfaceWhite,
        indicatorColor: AppColors.tertiary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded, color: AppColors.primary),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded, color: AppColors.primary),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
