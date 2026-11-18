import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../profile/presentation/screens/privacy_policy_screen.dart';
import '../../data/auth_repository_impl.dart';

/// Pantalla de Registro de Usuario en BusTrack conectada a Azure API.
class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;
  final ValueChanged<String> onRegisterSuccess;
  final VoidCallback onDemoTap;

  const RegisterScreen({
    super.key,
    required this.onLoginTap,
    required this.onRegisterSuccess,
    required this.onDemoTap,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _openPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) => PrivacyPolicyScreen(
          isModalMode: true,
          onAccept: () {
            setState(() => _acceptTerms = true);
          },
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
                'Debes leer y aceptar el aviso de privacidad para registrarte'),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _authRepository.registro(
          nombreCompleto: _nameController.text.trim(),
          correo: _emailController.text.trim(),
          password: _passwordController.text,
          confirmacionPassword: _confirmPasswordController.text,
          aceptaAvisoPrivacidad: _acceptTerms,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);
        widget.onRegisterSuccess(_emailController.text.trim());
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
            Text('Error de registro', style: TextStyle(fontSize: 16)),
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
                // Cabecera: Logotipo pequeño de BusTrack
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
                    TextButton(
                      onPressed: widget.onLoginTap,
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Título y Texto Descriptivo
                const Text(
                  'Crear Cuenta',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Regístrate para planificar tus rutas, consultar horarios y recibir alertas de movilidad.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 22),

                // Campo: Nombre Completo
                CustomTextField(
                  label: 'Nombre completo',
                  hintText: 'Ej. Carlos Mendoza',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      color: AppColors.secondary, size: 20),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa tu nombre completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Campo: Correo Electrónico
                CustomTextField(
                  label: 'Correo electrónico',
                  hintText: 'nombre@correo.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      color: AppColors.secondary, size: 20),
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
                const SizedBox(height: 14),

                // Campo: Contraseña
                CustomTextField(
                  label: 'Contraseña',
                  hintText: 'Mínimo 8 caracteres',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.secondary, size: 20),
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
                    if (val == null || val.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Campo: Confirmar Contraseña
                CustomTextField(
                  label: 'Confirmar contraseña',
                  hintText: 'Repite tu contraseña',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.secondary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tarjeta de Aviso de Privacidad con enlace a pantalla completa
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val ?? false),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Aviso de privacidad y protección de datos',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Acepto los términos de tratamiento responsable de datos exclusivamente para transporte público.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.neutralDark,
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 44.0),
                        child: InkWell(
                          onTap: _openPrivacyPolicy,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Leer acuerdos y políticas completas',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.open_in_new_rounded,
                                  size: 13, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón Principal «Registrarse»
                PrimaryButton(
                  text: 'Registrarse',
                  isLoading: _isLoading,
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _submitForm,
                ),
                const SizedBox(height: 16),

                // Enlace «¿Ya tienes una cuenta? Iniciar Sesión»
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya tienes una cuenta? ',
                        style: AppTypography.bodySmall,
                      ),
                      GestureDetector(
                        onTap: widget.onLoginTap,
                        child: const Text(
                          'Iniciar Sesión',
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

                const SizedBox(height: 18),

                // Separador
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.inputBorder)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('o',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 11)),
                    ),
                    Expanded(child: Divider(color: AppColors.inputBorder)),
                  ],
                ),

                const SizedBox(height: 18),

                // Botón requerido por Sección 7: Explorar Demo
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: widget.onDemoTap,
                    icon: const Icon(Icons.explore_outlined,
                        color: AppColors.secondary, size: 20),
                    label: const Text(
                      'Explorar Demo (Simulación Interactiva)',
                      style: TextStyle(
                        color: AppColors.neutralDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.inputBorder, width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
