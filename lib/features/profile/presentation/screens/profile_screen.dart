import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_dialogs.dart';
import '../../../../core/widgets/demo_data_badge.dart';
import '../../domain/account_service.dart';

/// Pantalla 10 – Perfil de usuario.
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

  bool _notificationsEnabled = true;
  bool _promotionsEnabled = false;
  String? _deletionMessage;

  @override
  void initState() {
    super.initState();
    _accountService = widget.accountService ?? const AccountService();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await AppDialogs.showConfirmation(
      context: context,
      title: 'Cerrar sesión',
      message: '¿Deseas salir de tu cuenta de BusTrack?',
      confirmLabel: 'Cerrar sesión',
    );
    if (confirmed == true) widget.onLogout();
  }

  Future<void> _deleteAccount() async {
    _deletionMessage = null;
    final deleted = await AppDialogs.showAccountDeletionDialog(
      context: context,
      onConfirmDelete: () async {
        final result = await _accountService.requestDeletion();
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
    final name = widget.isDemoMode ? 'Usuario Demo' : 'Pasajero BusTrack';
    final email =
        widget.isDemoMode ? 'demo@bustrack.com' : 'pasajero@bustrack.com';
    final initials = widget.isDemoMode ? 'UD' : 'PB';

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _ProfileHeader(
            name: name,
            email: email,
            initials: initials,
            isDemoMode: widget.isDemoMode,
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
                    'Sin rutas favoritas guardadas. La API de favoritos aún no '
                    'está disponible.',
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
                  subtitle: 'Preferencia local; sincronización pendiente.',
                  icon: Icons.notifications_none_rounded,
                ),
                const Divider(height: 1, color: AppColors.inputBorder),
                AppSwitch(
                  value: _promotionsEnabled,
                  onChanged: (value) =>
                      setState(() => _promotionsEnabled = value),
                  title: 'Novedades y promociones',
                  subtitle: 'Preferencia local; sincronización pendiente.',
                  icon: Icons.campaign_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Configuración del mapa'),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'OpenStreetMap · mapa interactivo',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'La ubicación solo se solicita al activarla en Explorar o en '
                  'Viaje en curso. No hay rastreo en segundo plano.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Ayuda y legal'),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Centro de ayuda',
                  onTap: () => _showInfo(
                    title: 'Centro de ayuda',
                    body:
                        'Para dudas sobre rutas, paradas y tarifas, consulta la '
                        'información mostrada en la app. Si detectas datos '
                        'incorrectos, usa “Calificar y contribuir” desde el '
                        'detalle de la ruta. El historial y las recompensas aún '
                        'no se sincronizan con la API central.',
                  ),
                ),
                const Divider(height: 1, color: AppColors.inputBorder),
                _MenuTile(
                  icon: Icons.description_outlined,
                  label: 'Términos de servicio',
                  onTap: () => _showInfo(
                    title: 'Términos de servicio',
                    body: 'El documento legal oficial está pendiente de '
                        'publicación. No se muestran condiciones inventadas en '
                        'la aplicación.',
                  ),
                ),
                const Divider(height: 1, color: AppColors.inputBorder),
                _MenuTile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Aviso de privacidad',
                  onTap: () => _showInfo(
                    title: 'Aviso de privacidad',
                    body:
                        'La app solicita ubicación en primer plano solo cuando '
                        'la activas para una función concreta. No hay captura '
                        'de acelerómetro sin consentimiento ni rastreo continuo. '
                        'El aviso legal completo está pendiente de publicación.',
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
              'Eliminar cuenta',
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

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
    required this.isDemoMode,
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
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceWhite, width: 3),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.surfaceWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleMedium),
                const SizedBox(height: 2),
                Text(email, style: AppTypography.bodySmall),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDemoMode
                        ? AppColors.inputBackground
                        : AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDemoMode
                          ? AppColors.inputBorder
                          : AppColors.success.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDemoMode
                            ? Icons.science_outlined
                            : Icons.verified_rounded,
                        size: 12,
                        color: isDemoMode
                            ? AppColors.secondary
                            : AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isDemoMode
                            ? 'Cuenta de demostración'
                            : 'Cuenta verificada',
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          color: isDemoMode
                              ? AppColors.secondary
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.titleMedium);
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: AppColors.secondary),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(fontSize: 13),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.secondary,
      ),
    );
  }
}
