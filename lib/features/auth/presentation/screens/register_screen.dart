import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

/// Pantalla 02 – Registro de Usuario en BusTrack.
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
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _gpsAlertsConsent = true;
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Masculino',
    'Femenino',
    'Otro',
    'Prefiero no decir',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona tu sexo')),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simulación de envío a endpoint de registro
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        widget.onRegisterSuccess(_emailController.text.trim());
      });
    }
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
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.directions_bus_filled_rounded,
                            color: AppColors.surfaceWhite,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 18,
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
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Título y Texto Descriptivo
                const Text(
                  'Crear Cuenta',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Únete para rastrear autobuses y planificar tus rutas en tiempo real.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 20),

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

                // Fila: Edad y Selector de Sexo en dos columnas
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo de Edad
                    Expanded(
                      flex: 4,
                      child: CustomTextField(
                        label: 'Edad',
                        hintText: 'Ej. 24',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.cake_outlined,
                            color: AppColors.secondary, size: 18),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Obligatorio';
                          }
                          final n = int.tryParse(val);
                          if (n == null || n < 12 || n > 110) {
                            return 'Inválida';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Selector de Sexo
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sexo',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            hint: const Text('Selecciona',
                                style: AppTypography.bodySmall),
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.inputBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.inputBorder),
                              ),
                            ),
                            items: _genderOptions.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender,
                                    style: AppTypography.bodyMedium
                                        .copyWith(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _selectedGender = val),
                          ),
                        ],
                      ),
                    ),
                  ],
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

                // Campo: Contraseña con opción para mostrar u ocultar
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
                const SizedBox(height: 16),

                // Tarjeta: Alertas GPS de líneas favoritas (respetando la constitución de no rastreo continuo)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.tertiary),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _gpsAlertsConsent,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) =>
                            setState(() => _gpsAlertsConsent = val ?? false),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Alertas GPS de líneas favoritas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tu ubicación se utilizará únicamente para notificarte cuando el autobús esté cerca de tu parada. Sin rastreo continuo.',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.neutralDark
                                    .withValues(alpha: 0.85),
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

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
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Separador
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.inputBorder)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('o',
                          style: TextStyle(
                              color: AppColors.secondary, fontSize: 11)),
                    ),
                    Expanded(child: Divider(color: AppColors.inputBorder)),
                  ],
                ),

                const SizedBox(height: 14),

                // Acceso independiente a la demostración principal
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: widget.onDemoTap,
                    icon: const Icon(Icons.explore_outlined,
                        color: AppColors.secondary, size: 18),
                    label: const Text(
                      'Explorar Demostración (Sin Registro)',
                      style: TextStyle(
                        color: AppColors.neutralDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
