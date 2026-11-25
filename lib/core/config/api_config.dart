/// Entornos soportados por la API de BusTrack.
enum ApiEnvironment {
  produccion,
  desarrollo,
  dockerLocal,
  azureContainerApps,
}

/// Configuración centralizada de la API REST de BusTrack.
class ApiConfig {
  /// Entorno activo seleccionado. Por defecto apunta al entorno oficial en Azure.
  static ApiEnvironment currentEnvironment = ApiEnvironment.azureContainerApps;

  /// URL Base configurable según el entorno de ejecución.
  static String get baseUrl {
    switch (currentEnvironment) {
      case ApiEnvironment.produccion:
        return const String.fromEnvironment(
          'BUSTRACK_API_URL',
          defaultValue: 'https://api.bustrack.lat',
        );
      case ApiEnvironment.desarrollo:
        return const String.fromEnvironment(
          'BUSTRACK_API_URL',
          defaultValue: 'https://localhost:5001',
        );
      case ApiEnvironment.dockerLocal:
        return const String.fromEnvironment(
          'BUSTRACK_API_URL',
          defaultValue: 'http://localhost:8080',
        );
      case ApiEnvironment.azureContainerApps:
        return const String.fromEnvironment(
          'BUSTRACK_API_URL',
          defaultValue:
              'https://bustrack-api.wonderfulpebble-cdcb3396.northcentralus.azurecontainerapps.io',
        );
    }
  }

  /// Versión de la API enviada en encabezados
  static const String apiVersion = '1.0';

  /// Tiempo de espera para conexión HTTP (en segundos)
  static const int connectTimeoutSeconds = 15;

  /// Tiempo de espera para recepción de datos (en segundos)
  static const int receiveTimeoutSeconds = 15;

  // --- Módulo 1: Autenticación y Usuarios ---
  static const String login = '/api/v1/auth/login';
  static const String registro = '/api/v1/auth/registro';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String recuperarPassword = '/api/v1/auth/recuperar-password';
  static const String restablecerPassword = '/api/v1/auth/restablecer-password';
  static const String verificarCorreo = '/api/v1/auth/verificar-correo';
  static const String reenviarVerificacion =
      '/api/v1/auth/reenviar-verificacion';
  static const String usuarioMe = '/api/v1/usuarios/me';

  // --- Módulo 2: Empresas y Medios de Transporte ---
  static const String empresas = '/api/v1/empresas';
  static const String empresasAutocompletar = '/api/v1/empresas/autocompletar';
  static const String empresasComparar = '/api/v1/empresas/comparar';
  static const String mediosTransporte = '/api/v1/medios-transporte';

  // --- Módulo 3: Rutas, Paradas y Mapas ---
  static const String paradas = '/api/v1/paradas';
  static const String paradasAutocompletar = '/api/v1/paradas/autocompletar';
  static const String paradasCercanas = '/api/v1/paradas/cercanas';
  static const String rutas = '/api/v1/rutas';
  static const String rutasBuscar = '/api/v1/rutas/buscar';
  static const String rutasAutocompletar = '/api/v1/rutas/autocompletar';
  static const String mapaElementos = '/api/v1/mapa/elementos';

  // --- Módulo 4: Horarios y Tarifas ---
  static const String horarios = '/api/v1/horarios';
  static const String horariosSiguiente = '/api/v1/horarios/siguiente';
  static const String tarifas = '/api/v1/tarifas';
  static const String tarifasCalcular = '/api/v1/tarifas/calcular';

  // --- Módulo 5: Destinos Turísticos ---
  static const String destinos = '/api/v1/destinos';
  static const String destinosAutocompletar = '/api/v1/destinos/autocompletar';
  static const String destinosCategorias = '/api/v1/destinos/categorias';

  // --- Módulo 6: Calificaciones, Historial y Consentimientos ---
  static const String calificaciones = '/api/v1/calificaciones';
  static const String calificacionesResumen = '/api/v1/calificaciones/resumen';
  static const String calificacionesMias = '/api/v1/calificaciones/mias';
  static const String viajes = '/api/v1/viajes';
  static const String consentimientosMe = '/api/v1/consentimientos/me';
  static const String consentimientos = '/api/v1/consentimientos';

  // --- Módulo 7: Sensores, Machine Learning & GenAI ---
  static const String sensoresLotes = '/api/v1/sensores/lotes';
  static const String telemetriaInferencia = '/api/v1/telemetria/inferencia';
  static const String mlClasificarPatron = '/api/v1/ml/clasificar-patron';
  static const String recomendaciones = '/api/v1/recomendaciones';
  static const String recomendacionesHistorial =
      '/api/v1/recomendaciones/historial';

  // --- Módulo 8: Dispositivos, Media & Moderación ---
  static const String dispositivos = '/api/v1/dispositivos';
  static const String dispositivosMios = '/api/v1/dispositivos/mios';
  static const String mediaUpload = '/api/v1/media/upload';
  static const String moderacion = '/api/v1/moderacion';
  static const String moderacionArchivo = '/api/v1/moderacion/archivo';

  // --- Módulo 9: Administración ---
  static const String candidatosParada = '/api/v1/candidatos-parada';
  static const String adminCandidatosValidar =
      '/api/v1/admin/candidatos-parada';

  // --- Módulo 10: General & Salud ---
  static const String health = '/api/v1/health';
  static const String healthLive = '/health';
  static const String healthReady = '/health/ready';
  static const String estadoActualizacion =
      '/api/v1/catalogos/estado-actualizacion';
}
