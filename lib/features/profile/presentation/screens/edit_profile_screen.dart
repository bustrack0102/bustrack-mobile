import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/data/auth_repository_impl.dart';
import '../../../auth/data/models/user_model.dart';

/// Pantalla para editar información del perfil de usuario.
class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  final VoidCallback onSaved;

  const EditProfileScreen({
    super.key,
    this.user,
    required this.onSaved,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user?.nombreCompleto ?? '');
    _emailController = TextEditingController(text: widget.user?.correo ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      try {
        await AuthRepositoryImpl().updatePerfilMe(
          nombreCompleto: _nameController.text.trim(),
          correo: _emailController.text.trim(),
        );

        if (!mounted) return;
        setState(() => _isSaving = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Perfil actualizado correctamente en Azure.'),
          ),
        );
        widget.onSaved();
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Error al actualizar perfil: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded,
                              color: AppColors.secondary, size: 50),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 16, color: AppColors.surfaceWhite),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  label: 'Nombre completo',
                  hintText: 'Ingresa tu nombre',
                  controller: _nameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Ingresa tu nombre'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Correo electrónico',
                  hintText: 'tu@correo.com',
                  controller: _emailController,
                  // El correo es de solo lectura por integridad de cuenta
                ),
                const SizedBox(height: 8),
                const Text(
                  'Para cambiar de correo electrónico, comunícate con el soporte de BusTrack.',
                  style: AppTypography.labelSmall,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Guardar Cambios',
                  isLoading: _isSaving,
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
