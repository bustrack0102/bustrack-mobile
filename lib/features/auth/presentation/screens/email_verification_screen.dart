import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/auth_repository_impl.dart';

/// Pantalla de Verificación REAL del Correo Electrónico.
///
/// Gestiona la validación del token de verificación enviado al correo,
/// tiempo de espera (cooldown) para reenvío, expiración y cambio de correo.
class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerificationSuccess;
  final VoidCallback onBackToRegister;
  final ValueChanged<String>? onEmailChanged;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.onVerificationSuccess,
    required this.onBackToRegister,
    this.onEmailChanged,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late String _currentEmail;
  final _tokenController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();

  int _resendCooldown = 60;
  Timer? _timer;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentEmail = widget.email;
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tokenController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _resendCooldown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
      }
    });
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return 'u***@correo.com';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '${name[0]}***@$domain';
    return '${name[0]}***${name[name.length - 1]}@$domain';
  }

  Future<void> _verifyToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() => _errorMessage = 'Por favor ingresa el código o token');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final valid = await _authRepository.verificarCorreo(
        correo: _currentEmail,
        token: token,
      );

      if (!mounted) return;
      setState(() => _isVerifying = false);

      if (valid) {
        widget.onVerificationSuccess();
      } else {
        setState(() => _errorMessage =
            'El enlace o token de verificación es inválido o ha expirado. Solicita un nuevo reenvío.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _errorMessage =
            'No se pudo verificar el correo. Comprueba tu conexión o solicita un nuevo token.';
      });
    }
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.reenviarVerificacion(_currentEmail);
      if (!mounted) return;
      setState(() => _isResending = false);
      _startCooldown();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Se ha enviado un nuevo enlace de verificación a $_currentEmail',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isResending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          content: Text('Error al reenviar el correo. Intenta nuevamente.'),
        ),
      );
    }
  }

  void _showChangeEmailDialog() {
    final newEmailController = TextEditingController(text: _currentEmail);
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cambiar correo electrónico',
            style: AppTypography.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Si escribiste mal tu correo, corrígelo aquí para enviarte el código a la dirección correcta.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: newEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Nuevo correo',
                prefixIcon: Icon(Icons.mail_outline_rounded,
                    color: AppColors.secondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              final newMail = newEmailController.text.trim();
              if (newMail.isNotEmpty &&
                  newMail.contains('@') &&
                  newMail.contains('.')) {
                setState(() => _currentEmail = newMail);
                widget.onEmailChanged?.call(newMail);
                Navigator.of(dialogCtx).pop();
                _handleResend();
              }
            },
            child: const Text('Actualizar y Reenviar'),
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
          onPressed: widget.onBackToRegister,
        ),
        title: const Text('Verificación de Correo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  color: AppColors.primary,
                  size: 42,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirma tu correo electrónico',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Hemos enviado un código y enlace seguro de activación a la siguiente dirección:',
                style: AppTypography.bodySmall.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Tarjeta con correo y botón para editar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 18, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      _maskEmail(_currentEmail),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.neutralDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _showChangeEmailDialog,
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Cambiar',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Campo de token
              CustomTextField(
                label: 'Código de verificación / Token',
                hintText: 'Ingresa el código recibido en tu bandeja',
                controller: _tokenController,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.verified_outlined,
                    color: AppColors.secondary, size: 20),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Verificar y activar cuenta',
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isVerifying,
                onPressed: _verifyToken,
              ),

              const SizedBox(height: 24),

              // Sección de reenvío con cooldown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No recibiste el correo? ',
                    style: AppTypography.bodySmall,
                  ),
                  if (_resendCooldown > 0)
                    Text(
                      'Reenviar en ${_resendCooldown}s',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _isResending ? null : _handleResend,
                      child: Text(
                        _isResending ? 'Enviando...' : 'Reenviar enlace',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              TextButton.icon(
                onPressed: widget.onBackToRegister,
                icon: const Icon(Icons.arrow_back_rounded,
                    size: 16, color: AppColors.textMuted),
                label: const Text(
                  'Regresar a la pantalla de Registro',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
