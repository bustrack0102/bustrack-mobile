import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/otp_field.dart';
import '../../../../core/widgets/primary_button.dart';

/// Pantalla 03 – Verificación de Código OTP para correo electrónico.
class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onBack;
  final VoidCallback onEditEmail;
  final VoidCallback onVerificationSuccess;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.onBack,
    required this.onEditEmail,
    required this.onVerificationSuccess,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _enteredCode = '';
  int _secondsRemaining = 50;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 50);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
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

  void _resendCode() {
    if (_secondsRemaining == 0) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Se ha reenviado un nuevo código a tu correo')),
      );
    }
  }

  void _verifyCode() {
    if (_enteredCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa los 4 dígitos del código')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      widget.onVerificationSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerText = '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Barra superior: Botón Atrás + Indicador «PASO 3 DE 3»
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón para regresar
                      IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.neutralDark,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),

                      // Indicador «PASO 3 DE 3»
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PASO 3 DE 3',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40), // Balance visual
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Icono decorativo de correo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título «Verifica tu correo»
                  const Text(
                    'Verifica tu correo',
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: 6),

                  // Mensaje indicando que se ha enviado un código de cuatro dígitos
                  const Text(
                    'Hemos enviado un código de cuatro dígitos a tu bandeja de entrada:',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 8),

                  // Mostrar correo de destino parcialmente oculto con opción de editar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _maskEmail(widget.email),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: widget.onEditEmail,
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Cuatro casillas individuales para introducir el código OTP
                  OtpField(
                    onChanged: (code) => _enteredCode = code,
                    onCompleted: (code) {
                      _enteredCode = code;
                      _verifyCode();
                    },
                  ),
                  const SizedBox(height: 24),

                  // Temporizador para reenviar el código y enlace «Reenviar código»
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          '¿No recibiste el código?',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timerText,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•',
                                style: TextStyle(color: AppColors.secondary)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap:
                                  _secondsRemaining == 0 ? _resendCode : null,
                              child: Text(
                                'Reenviar código',
                                style: TextStyle(
                                  color: _secondsRemaining == 0
                                      ? AppColors.primary
                                      : AppColors.secondary
                                          .withValues(alpha: 0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  decoration: _secondsRemaining == 0
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Botón inferior «Verificar» y Mensaje de seguridad
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    text: 'Verificar',
                    isLoading: _isLoading,
                    icon: Icons.verified_user_outlined,
                    onPressed: _verifyCode,
                  ),
                  const SizedBox(height: 14),

                  // Mensaje inferior de seguridad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cifrado y validación segura de identidad',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
