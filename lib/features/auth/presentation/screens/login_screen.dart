import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/live_status_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/auth_repository_impl.dart';

/// Pantalla de Inicio de Sesión de BusTrack conectada a Azure API.
class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onDemoTap;

  const LoginScreen({
    super.key,
    required this.onRegisterTap,
    required this.onLoginSuccess,
    required this.onForgotPasswordTap,
    required this.onDemoTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await _authRepository.login(
          correo: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);
        widget.onLoginSuccess();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Error de autenticación', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aceptar',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera: Logotipo de BusTrack y botón directo a modo demo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColors.primary,
                                child: const Icon(
                                  Icons.directions_bus_filled_rounded,
                                  color: AppColors.surfaceWhite,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neutralDark,
                            ),
                            children: [
                              TextSpan(text: 'Bus'),
                              TextSpan(
                                text: 'Track',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: widget.onDemoTap,
                      icon: const Icon(Icons.explore_outlined,
                          size: 15, color: AppColors.secondary),
                      label: const Text(
                        'Modo Demo',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            AppColors.tertiary.withValues(alpha: 0.45),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Título «Bienvenido»
                const Text(
                  'Bienvenido',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: 6),

                // Mensaje descriptivo
                const Text(
                  'Inicia sesión para consultar tus rutas, planificar viajes y gestionar tus itinerarios favoritos.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 24),

                // Campo: Correo Electrónico
                CustomTextField(
                  label: 'Correo electrónico',
                  hintText: 'nombre@correo.com',
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
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo: Contraseña con opción para mostrar u ocultar
                CustomTextField(
                  label: 'Contraseña',
                  hintText: 'Tu contraseña',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),

                // Enlace «¿Olvidaste tu contraseña?»
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onForgotPasswordTap,
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Botón principal «Ingresar»
                PrimaryButton(
                  text: 'Ingresar',
                  isLoading: _isLoading,
                  icon: Icons.login_rounded,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 24),

                // Tarjeta informativa sobre transporte metropolitano en vivo
                const LiveStatusCard(),
                const SizedBox(height: 24),

                // Enlace «¿No tienes cuenta? Regístrate aquí»
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes cuenta? ',
                        style: AppTypography.bodySmall,
                      ),
                      GestureDetector(
                        onTap: widget.onRegisterTap,
                        child: const Text(
                          'Regístrate aquí',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
