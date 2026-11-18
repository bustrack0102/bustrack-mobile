import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../../auth/data/auth_repository_impl.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../routes/presentation/screens/admin_route_management_screen.dart';
import '../../../sensors/presentation/widgets/sensor_status_card.dart';
import '../../domain/account_service.dart';
import 'edit_profile_screen.dart';
import 'permissions_manager_screen.dart';
import 'privacy_policy_screen.dart';

/// Pantalla 10 – Perfil de usuario conectado a Azure Backend.
class ProfileScreen extends StatefulWidget {
  final bool isDemoMode;
  final VoidCallback onLogout;
  final VoidCallback onExplore;
  final AccountService? accountService;

  const ProfileScreen({
    super.key,
    required this.isDemoMode,
    required this.onLogout,
    required this.onExplore,
    this.accountService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AccountService _accountService;
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  UserModel? _userProfile;
  bool _isLoadingProfile = true;
  bool _notificationsEnabled = true;
  bool _promotionsEnabled = false;
  String? _deletionMessage;

  @override
  void initState() {
    super.initState();
    _accountService = widget.accountService ?? AccountService();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (widget.isDemoMode) {
      setState(() => _isLoadingProfile = false);
      return;
    }

    try {
      final user = await _authRepository.getPerfilMe();
      if (mounted) {
        setState(() {
          _userProfile = user;
          _isLoadingProfile = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await AppDialogs.showConfirmation(
      context: context,
      title: 'Cerrar sesión',
      message: '¿Deseas salir de tu cuenta de BusTrack?',
      confirmLabel: 'Cerrar sesión',
    );
    if (confirmed == true) {
      await _authRepository.logout();
      widget.onLogout();
    }
  }

  Future<void> _deleteAccount() async {
    _deletionMessage = null;
    final deleted = await AppDialogs.showAccountDeletionDialog(
      context: context,
      onConfirmDelete: (password) async {
        final result = await _accountService.requestDeletion(
          passwordConfirmacion: password,
        );
        _deletionMessage = result.message;
        return result.deleted;
      },
    );

    if (!mounted) return;
    if (deleted == true) {
      widget.onLogout();
      return;
    }

    if (_deletionMessage != null) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Eliminación no disponible'),
          content: Text(
            _deletionMessage!,
            style: AppTypography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }

  void _showInfo({
    required String title,
    required String body,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(body, style: AppTypography.bodyMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.isDemoMode
        ? 'Usuario Demo'
        : (_userProfile?.nombreCompleto.isNotEmpty == true
            ? _userProfile!.nombreCompleto
            : 'Pasajero BusTrack');

    final email = widget.isDemoMode
        ? 'demo@bustrack.com'
        : (_userProfile?.correo.isNotEmpty == true
            ? _userProfile!.correo
            : 'pasajero@bustrack.com');

    final initials =
        name.length >= 2 ? name.substring(0, 2).toUpperCase() : 'BT';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          if (widget.isDemoMode)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(child: DemoDataBadge(label: 'MODO DEMO')),
            ),
        ],
      ),
      body: _isLoadingProfile
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                _ProfileHeader(
                  name: name,
                  email: email,
                  initials: initials,
                  isDemoMode: widget.isDemoMode,
                  userProfile: _userProfile,
                  onEditTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => EditProfileScreen(
                          user: _userProfile,
                          onSaved: _loadProfile,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Sección: Sensores del teléfono & Machine Learning
                const _SectionTitle('Sensores & Detección de Movimiento'),
                const SizedBox(height: 8),
                const SensorStatusCard(),
                const SizedBox(height: 20),

                // Sección: Administración de Rutas en Mapa (Sección 3.3)
                const _SectionTitle('Herramientas Operativas'),
                const SizedBox(height: 8),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: _MenuTile(
                    icon: Icons.map_rounded,
                    label: 'Administración Geográfica de Rutas',
                    subtitle:
                        'Crear rutas, colocar paradas y ordenar el recorrido',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AdminRouteManagementScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                const _SectionTitle('Rutas favoritas'),
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Explora las rutas registradas en el sistema y planifica tus viajes.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onExplore,
                        child: const Text('Explorar'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Preferencias de notificaciones'),
                const SizedBox(height: 4),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      AppSwitch(
                        value: _notificationsEnabled,
                        onChanged: (value) =>
                            setState(() => _notificationsEnabled = value),
                        title: 'Avisos de servicio',
                        subtitle: 'Recibe alertas sobre cambios en rutas.',
                        icon: Icons.notifications_none_rounded,
                      ),
                      const Divider(height: 1, color: AppColors.inputBorder),
                      AppSwitch(
                        value: _promotionsEnabled,
                        onChanged: (value) =>
                            setState(() => _promotionsEnabled = value),
                        title: 'Novedades y promociones',
                        subtitle: 'Nuevos destinos turísticos y sugerencias.',
                        icon: Icons.campaign_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Privacidad y Seguridad'),
                const SizedBox(height: 8),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.shield_outlined,
                        label: 'Privacidad y Protección de Datos',
                        subtitle: 'Consulta el tratamiento integral de datos',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppColors.inputBorder),
                      _MenuTile(
                        icon: Icons.phonelink_lock_rounded,
                        label: 'Administrador de Permisos',
                        subtitle: 'Ubicación, notificaciones y acelerómetro',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PermissionsManagerScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppColors.inputBorder),
                      _MenuTile(
                        icon: Icons.help_outline_rounded,
                        label: 'Centro de ayuda',
                        onTap: () => _showInfo(
                          title: 'Centro de ayuda',
                          body:
                              'Para dudas sobre rutas, paradas y tarifas, consulta la información mostrada en la app. Si detectas datos incorrectos, usa "Calificar y contribuir" desde el detalle de la ruta.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppSecondaryButton(
                  text: 'Cerrar sesión',
                  icon: Icons.logout_rounded,
                  height: 48,
                  onPressed: _confirmLogout,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _deleteAccount,
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.error,
                    size: 18,
                  ),
                  label: const Text(
                    'Eliminar cuenta permanentemente',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String initials;
  final bool isDemoMode;
  final UserModel? userProfile;
  final VoidCallback? onEditTap;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
    required this.isDemoMode,
    this.userProfile,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.surfaceWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTypography.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        userProfile?.rol ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onEditTap != null && !isDemoMode)
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      size: 20, color: AppColors.secondary),
                  onPressed: onEditTap,
                ),
            ],
          ),
          if (userProfile != null && !isDemoMode) ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.inputBorder, height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Viajes registrados',
                    '${userProfile!.totalViajesGuardados}'),
                _buildStatItem(
                    'Calificaciones', '${userProfile!.totalCalificaciones}'),
                _buildStatItem(
                    'Sensores',
                    userProfile!.consentimientoSensoresActivo
                        ? 'Activo'
                        : 'Opcional'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: AppColors.neutralDark,
          ),
        ),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(fontSize: 15),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary, size: 22),
      title: Text(label, style: AppTypography.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTypography.labelSmall)
          : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.disabledText,
      ),
      onTap: onTap,
    );
  }
}
