import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';

/// Pantalla completa de «Privacidad y Protección de Datos» de BusTrack.
///
/// Accesible desde el proceso de registro y desde la configuración de la cuenta.
/// Detalla categorías de datos, finalidades, tecnologías de terceros y derechos ARCO.
class PrivacyPolicyScreen extends StatefulWidget {
  /// Si se abre desde el flujo de registro, permite aceptar y retornar.
  final bool isModalMode;
  final VoidCallback? onAccept;

  const PrivacyPolicyScreen({
    super.key,
    this.isModalMode = false,
    this.onAccept,
  });

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _accepted = false;

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: AppTypography.titleMedium.copyWith(fontSize: 15),
          ),
          subtitle: Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(fontSize: 12),
          ),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: children,
        ),
      ),
    );
  }

  Widget _buildBulletItem(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 10),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium
                    .copyWith(fontSize: 13, color: AppColors.neutralDark),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: detail,
                    style: const TextStyle(color: AppColors.neutralDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Privacidad y Protección'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.surfaceWhite.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.surfaceWhite,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Aviso de Privacidad Integral',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    color: AppColors.surfaceWhite,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tu privacidad es primordial. Aquí explicamos con total transparencia qué datos tratamos, por qué y cómo puedes controlarlos.',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    color: AppColors.surfaceWhite
                                        .withValues(alpha: 0.9),
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Badge de versión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    AppColors.secondary.withValues(alpha: 0.2)),
                          ),
                          child: const Text(
                            'Versión 2.1 — Vigente desde Noviembre 2026',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        const Text(
                          'Cumplimiento ARCO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sección 1: Información recopilada
                    const Text(
                      '1. Información que recopilamos',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    _buildSectionCard(
                      icon: Icons.account_circle_outlined,
                      iconColor: AppColors.primary,
                      title: 'A. Información de Cuenta',
                      subtitle: 'Datos necesarios para tu perfil y acceso',
                      initiallyExpanded: true,
                      children: [
                        _buildBulletItem('Nombre completo',
                            'Para identificar tu perfil de usuario y personalizar tu experiencia.'),
                        _buildBulletItem('Correo electrónico',
                            'Para verificación de identidad, recuperación segura de contraseña y alertas críticas del servicio.'),
                        _buildBulletItem('Identificador único',
                            'Identificador asignado en el servidor para vincular tus rutas favoritas y contribuciones.'),
                        _buildBulletItem('Tokens de autenticación',
                            'Almacenados en el llavero criptográfico seguro del dispositivo (Keystore/Keyring con AES-GCM).'),
                        _buildBulletItem('Estado de verificación',
                            'Registro en el servidor del estado confirmado del correo electrónico.'),
                      ],
                    ),

                    _buildSectionCard(
                      icon: Icons.insights_rounded,
                      iconColor: const Color(0xFF2563EB),
                      title: 'B. Información de Uso de la App',
                      subtitle: 'Consultas de rutas y preferencias',
                      children: [
                        _buildBulletItem('Interacciones con rutas',
                            'Historial de búsqueda local de orígenes y destinos consultados para brindarte accesos rápidos.'),
                        _buildBulletItem('Calificaciones y reportes',
                            'Opiniones sobre puntualidad y calidad del servicio registradas de forma agregada o anónima.'),
                        _buildBulletItem('Diagnóstico técnico',
                            'Registro anónimo de errores HTTP y caídas para garantizar la estabilidad de la plataforma.'),
                      ],
                    ),

                    _buildSectionCard(
                      icon: Icons.sensors_rounded,
                      iconColor: const Color(0xFFD97706),
                      title: 'C. Sensores del Teléfono (Acelerómetro)',
                      subtitle: 'Opcional, con consentimiento explícito',
                      children: [
                        _buildBulletItem('Uso exclusivo',
                            'Las lecturas triaxiales (X, Y, Z) solo se capturan si otorgas consentimiento voluntario para asistir en la clasificación de detenciones del transporte.'),
                        _buildBulletItem('Restricción estricta de rastreo',
                            'Los datos del acelerómetro NUNCA se utilizan para inferir coordenadas GPS, ubicación geográfica ni velocidad exacta de desplazamiento.'),
                        _buildBulletItem('Revocable en cualquier momento',
                            'Puedes apagar esta función con un solo toque desde tu Perfil o Configuración.'),
                        _buildBulletItem('Modo Demo exento',
                            'La demostración de la app nunca solicita ni accede al acelerómetro.'),
                      ],
                    ),

                    _buildSectionCard(
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFF059669),
                      title: 'D. Información de Ubicación',
                      subtitle: 'Orientación en primer plano únicamente',
                      children: [
                        _buildBulletItem('Ubicación en primer plano',
                            'Solo se consulta si autorizas el permiso del sistema para centrar el mapa en tu posición al buscar paradas cercanas.'),
                        _buildBulletItem('Sin seguimiento en segundo plano',
                            'BusTrack no recopila tu ubicación en segundo plano ni efectúa rastreo continuo de tus traslados ni de los autobuses.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sección 2: Finalidad
                    const Text(
                      '2. Finalidad del Tratamiento',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    _buildSectionCard(
                      icon: Icons.flag_outlined,
                      iconColor: AppColors.secondary,
                      title: '¿Para qué usamos tus datos?',
                      subtitle: 'Fines legítimos y transparentes',
                      children: [
                        _buildBulletItem('Gestión de cuentas',
                            'Permitir el acceso seguro y la sincronización de favoritos.'),
                        _buildBulletItem('Consulta y navegación',
                            'Mostrar horarios, tarifas reales y secuencias de paradas verificadas.'),
                        _buildBulletItem('Mejora del servicio metropolitano',
                            'Identificar patrones de paradas y evaluar la calidad del transporte mediante reportes colaborativos.'),
                        _buildBulletItem('Seguridad técnica',
                            'Prevenir abusos, ataques de fuerza bruta y accesos no autorizados.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sección 3: Tecnologías y Servicios Externos
                    const Text(
                      '3. Tecnologías y Servicios Utilizados',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    _buildSectionCard(
                      icon: Icons.cloud_outlined,
                      iconColor: const Color(0xFF0284C7),
                      title: 'Infraestructura Tecnológica',
                      subtitle: 'Componentes oficiales del ecosistema BusTrack',
                      children: [
                        _buildBulletItem('Flutter y Dart',
                            'Aplicación cliente compilada de forma nativa para Android.'),
                        _buildBulletItem('Backend REST en Azure Container Apps',
                            'API centralizada encargada de autenticación, catálogos y validaciones seguras bajo TLS 1.3.'),
                        _buildBulletItem('Azure Cosmos DB for NoSQL',
                            'Almacenamiento persistente y cifrado en reposo para usuarios, rutas y empresas.'),
                        _buildBulletItem('Servicio Python con Scikit-learn',
                            'Microservicio de Machine Learning para clasificar patrones de movimiento sin datos personales.'),
                        _buildBulletItem('OpenAI API (GenAI)',
                            'Generación de recomendaciones inteligentes de viaje procesadas con entradas anonimizadas.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sección 4: Derechos ARCO y Control
                    const Text(
                      '4. Derechos del Usuario y Controles',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    _buildSectionCard(
                      icon: Icons.gavel_rounded,
                      iconColor: AppColors.primary,
                      title:
                          'Tus Derechos (Acceso, Rectificación, Cancelación)',
                      subtitle: 'Tú tienes el control absoluto de tus datos',
                      initiallyExpanded: true,
                      children: [
                        _buildBulletItem('Consultar datos personales',
                            'Puedes revisar tu información registrada directamente en la sección Perfil.'),
                        _buildBulletItem('Modificar tu información',
                            'Actualiza tu nombre y preferencias en cualquier instante.'),
                        _buildBulletItem('Eliminar tu cuenta',
                            'Dispones de la opción de borrado permanente e irreversible in-app desde la pantalla de Perfil (Cumplimiento de Google Play).'),
                        _buildBulletItem('Desactivar sensores y permisos',
                            'Gestiona de forma granular qué sensores y permisos conceder desde el Administrador de Permisos.'),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Barra inferior si es modo modal de aceptación en registro
            if (widget.isModalMode)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                  border: const Border(
                    top: BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _accepted,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) {
                            setState(() => _accepted = val ?? false);
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _accepted = !_accepted);
                            },
                            child: const Text(
                              'He leído y acepto los términos de Privacidad y Tratamiento de Datos de BusTrack.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutralDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'Aceptar y Continuar',
                      icon: Icons.check_circle_outline_rounded,
                      onPressed: _accepted
                          ? () {
                              widget.onAccept?.call();
                              Navigator.of(context).pop(true);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
