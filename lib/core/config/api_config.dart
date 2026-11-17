/// Configuración centralizada de la API REST de BusTrack en Azure.
class ApiConfig {
  /// URL Base oficial del Backend desplegado en Azure Container Apps.
  static const String baseUrl =
      'https://bustrack-api.wonderfulpebble-cdcb3396.northcentralus.azurecontainerapps.io';

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
  static const String usuarioMe = '/api/v1/usuarios/me';

  // --- Módulo 2: Empresas y Medios de Transporte ---
  static const String empresas = '/api/v1/empresas';
  static const String empresasAutocompletar = '/api/v1/empresas/autocompletar';
  static const String mediosTransporte = '/api/v1/medios-transporte';

  // --- Módulo 3: Rutas, Paradas y Mapas ---
  static const String paradas = '/api/v1/paradas';
  static const String paradasAutocompletar = '/api/v1/paradas/autocompletar';
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

  // --- Módulo 10: General & Salud ---
  static const String health = '/api/v1/health';
  static const String estadoActualizacion =
      '/api/v1/catalogos/estado-actualizacion';
}
