import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/auth_repository_impl.dart';

/// Pantalla para solicitar la recuperación de contraseña por correo.
class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;
  final ValueChanged<String> onCodeSent;

  const ForgotPasswordScreen({
    super.key,
    required this.onBackToLogin,
    required this.onCodeSent,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();

  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      try {
        await _authRepository.solicitarRecuperacionPassword(email);
      } catch (_) {
        // Silencioso para prevenir enumeración de cuentas
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _submitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: widget.onBackToLogin,
        ),
        title: const Text('Recuperar contraseña'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: _submitted ? _buildConfirmationView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¿Olvidaste tu contraseña?',
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Ingresa el correo electrónico asociado a tu cuenta de BusTrack. Te enviaremos un código de seguridad para restablecer tu acceso.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 28),
          CustomTextField(
            label: 'Correo electrónico',
            hintText: 'ejemplo@correo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Ingresa tu correo electrónico';
              }
              if (!val.contains('@') || !val.contains('.')) {
                return 'Ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Enviar código de recuperación',
            icon: Icons.send_rounded,
            isLoading: _isLoading,
            onPressed: _handleSubmit,
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: widget.onBackToLogin,
              icon: const Icon(Icons.arrow_back_rounded,
                  size: 16, color: AppColors.primary),
              label: const Text(
                'Regresar al Inicio de Sesión',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    final email = _emailController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Revisa tu bandeja de entrada',
          style: AppTypography.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Si el correo $email se encuentra registrado en BusTrack, hemos enviado las instrucciones y el código de verificación correspondiente.',
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'Ingresar código de seguridad',
          icon: Icons.pin_outlined,
          onPressed: () => widget.onCodeSent(email),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: widget.onBackToLogin,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Volver al Inicio de Sesión'),
        ),
      ],
    );
  }
}
