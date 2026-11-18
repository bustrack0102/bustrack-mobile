import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/auth_repository_impl.dart';

/// Pantalla para ingresar el código y establecer una nueva contraseña.
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final VoidCallback onResetSuccess;
  final VoidCallback onBack;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.onResetSuccess,
    required this.onBack,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await _authRepository.restablecerPassword(
          correo: widget.email,
          token: _tokenController.text.trim(),
          nuevaPassword: _newPasswordController.text,
          confirmacionPassword: _confirmPasswordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogCtx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.success),
                SizedBox(width: 8),
                Text('Contraseña actualizada', style: TextStyle(fontSize: 16)),
              ],
            ),
            content: const Text(
              'Tu contraseña ha sido restablecida exitosamente. Ya puedes iniciar sesión con tu nueva clave de acceso.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                },
                child: const Text('Iniciar sesión',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        );

        if (!mounted) return;
        widget.onResetSuccess();
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('No se pudo restablecer', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: widget.onBack,
        ),
        title: const Text('Nueva contraseña'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.secondary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Código enviado a: ${widget.email}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Crea una nueva contraseña',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ingresa el código que recibiste por correo y define tu nueva contraseña segura.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Código de verificación / Token',
                  hintText: 'Ej. 123456',
                  controller: _tokenController,
                  prefixIcon: const Icon(Icons.key_rounded,
                      color: AppColors.secondary, size: 20),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa el código recibido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Nueva contraseña',
                  hintText: 'Mínimo 8 caracteres',
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.secondary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  validator: (val) {
                    if (val == null || val.length < 8) {
                      return 'Debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirmar nueva contraseña',
                  hintText: 'Repite tu nueva contraseña',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.secondary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (val) {
                    if (val != _newPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: 'Guardar y actualizar contraseña',
                  icon: Icons.check_circle_outline_rounded,
                  isLoading: _isLoading,
                  onPressed: _handleReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
