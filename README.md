# BusTrack Mobile — Sistema de Consulta y Planificación de Transporte Público

> Aplicación móvil Flutter conectada al Backend oficial desplegado en Microsoft Azure Container Apps.
> **Universidad Tecnológica de Tula-Tepeji — Desarrollo e Integración Móvil.**

---

## 🚀 Estado de la Integración con Azure Backend

- **Backend en Producción (Azure):** `https://bustrack-api.wonderfulpebble-cdcb3396.northcentralus.azurecontainerapps.io`
- **Estado del Servidor:** **ONLINE (`GET /api/v1/health` -> HTTP 200 OK `"Healthy"`)**
- **Autenticación:** JWT con Access Token de vida corta y Refresh Token seguro.
- **Persistencia Segura:** `flutter_secure_storage` (`EncryptedSharedPreferences` / `Keychain`).

---

## ✅ Funcionalidades Realizadas (Etapa 1 y Etapa 2)

### 1. Infraestructura de Red y Almacenamiento Seguro (Etapa 1)
- **`ApiConfig`:** Centralización de la URL base de Azure y catálogo completo de rutas REST `/api/v1/`.
- **`ApiClient` (Dio):** Cliente HTTP con tiempos de espera configurados, interceptor de registro y manejo de errores estructurados (`ApiException`, `BadRequestException`, `UnauthorizedException`, `ConflictException`, `ServerException`).
- **`SecureStorageService`:** Almacenamiento encriptado de `accessToken`, `refreshToken` y perfil del usuario en el dispositivo.
- **`AuthInterceptor`:** Interceptor automático que inyecta `Authorization: Bearer {token}` en las peticiones y ejecuta renovación silenciosa de token (`POST /api/v1/auth/refresh`) si el servidor devuelve `401 Unauthorized`.

### 2. Módulo de Autenticación y Perfil de Usuario (Etapa 1)
- **Inicio de Sesión (`POST /api/v1/auth/login`):** Validación de credenciales contra la API real de Azure y guardado seguro de tokens JWT.
- **Registro de Usuarios (`POST /api/v1/auth/registro`):** Alta de cuenta con nombre completo, correo, contraseña, confirmación y aviso de privacidad.
- **Consulta de Perfil (`GET /api/v1/usuarios/me`):** Carga dinámica de datos del usuario autenticado en la pantalla de Perfil.
- **Cierre de Sesión (`POST /api/v1/auth/logout`):** Revocación de sesión en Azure y limpieza del almacenamiento seguro.
- **Persistencia de Sesión al Arrancar:** La app verifica si existe una sesión activa y redirige directamente a la pantalla principal sin solicitar credenciales nuevamente.

### 3. Consulta de Catálogos de Información (Etapa 2)
- **Directorio de Empresas (`GET /api/v1/empresas`):** Consulta del catálogo oficial de empresas y líneas de transporte con filtros por búsqueda y municipio.
- **Medios de Transporte (`GET /api/v1/medios-transporte`):** Modalidades de transporte registradas (Autobús, Combi/Urvan, Taxi colectivo, etc.).
- **Catálogo y Buscador de Rutas (`GET /api/v1/rutas` y `GET /api/v1/rutas/buscar`):** Búsqueda de alternativas entre origen y destino.
- **Autocompletado de Paradas (`GET /api/v1/paradas/autocompletar`):** Sugerencias dinámicas mientras el usuario escribe su origen o destino.
- **Secuencia de Paradas (`GET /api/v1/rutas/{id}/paradas`):** Línea de tiempo ordenada de paradas por ruta.
- **Geometría Cartográfica GeoJSON (`GET /api/v1/rutas/{id}/geometria`):** Trazo de rutas en el mapa interactivo `flutter_map` (OpenStreetMap).
- **Calculadora de Tarifas (`GET /api/v1/tarifas/calcular`):** Cálculo del costo estimado en pesos mexicanos (MXN) entre paradas de abordaje y descenso.
- **Destinos Turísticos (`GET /api/v1/destinos`):** Atractivos y puntos de interés de la región.

---

## 🛠️ Stack Tecnológico

- **Framework:** Flutter 3.x / Dart.
- **Cliente HTTP:** Dio 5.7.0.
- **Seguridad y Persistencia:** Flutter Secure Storage 9.2.2.
- **Mapas:** `flutter_map` 8.3.2 + `latlong2` 0.10.1 (OpenStreetMap).
- **Backend:** ASP.NET Core 9 Web API desplegado en Azure Container Apps.

---

## 📁 Estructura del Código Realizado

```text
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart             # URL Base y catálogo de endpoints
│   ├── network/
│   │   ├── api_client.dart             # Cliente Dio centralizado
│   │   ├── api_exceptions.dart         # Excepciones de error HTTP
│   │   └── auth_interceptor.dart       # Inyección y renovación automática de JWT
│   ├── storage/
│   │   └── secure_storage_service.dart # Persistencia encriptada de tokens
│   ├── map/                            # Integración de Mapas con OpenStreetMap
│   └── theme/                          # Estilos, colores y tipografía
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/user_model.dart  # DTOs de Usuario y Autenticación
│   │   │   ├── auth_remote_data_source.dart
│   │   │   └── auth_repository_impl.dart
│   │   ├── domain/auth_repository.dart
│   │   └── presentation/screens/       # LoginScreen y RegisterScreen
│   ├── profile/
│   │   └── presentation/screens/       # ProfileScreen conectado a GET /usuarios/me
│   ├── routes/
│   │   ├── data/
│   │   │   ├── models/api_models.dart  # DTOs de Empresas, Rutas, Paradas, Geometría, Tarifas
│   │   │   ├── azure_catalog_remote_data_source.dart
│   │   │   └── azure_route_repository.dart
│   │   └── presentation/screens/       # ExploreRoutesScreen y RouteDetailScreen
│   └── home/
└── main.dart                           # Coordinador de navegación y verificación de sesión
```

---

## 📋 Endpoints de Azure Conectados

| Módulo | Endpoint | Método | Descripción |
|---|---|---|---|
| **Salud** | `/api/v1/health` | `GET` | Sonda de disponibilidad del servidor en Azure |
| **Auth** | `/api/v1/auth/login` | `POST` | Inicio de sesión y emisión de JWT |
| **Auth** | `/api/v1/auth/registro` | `POST` | Registro de nuevo usuario |
| **Auth** | `/api/v1/auth/refresh` | `POST` | Renovación silenciosa de Access Token |
| **Auth** | `/api/v1/auth/logout` | `POST` | Cierre de sesión y revocación de Refresh Token |
| **Usuarios** | `/api/v1/usuarios/me` | `GET` | Consulta del perfil del usuario autenticado |
| **Empresas** | `/api/v1/empresas` | `GET` | Listado y filtro de líneas de transporte |
| **Medios** | `/api/v1/medios-transporte` | `GET` | Catálogo de tipos de unidades |
| **Paradas** | `/api/v1/paradas/autocompletar` | `GET` | Sugerencias rápidas de origen y destino |
| **Rutas** | `/api/v1/rutas` | `GET` | Catálogo general de rutas |
| **Rutas** | `/api/v1/rutas/buscar` | `GET` | Alternativas de ruta entre origen y destino |
| **Rutas** | `/api/v1/rutas/{id}/paradas` | `GET` | Secuencia ordenada de paradas |
| **Rutas** | `/api/v1/rutas/{id}/geometria` | `GET` | Trazo GeoJSON de la ruta para el mapa |
| **Tarifas** | `/api/v1/tarifas/calcular` | `GET` | Cálculo de tarifa en MXN entre tramos |
| **Destinos** | `/api/v1/destinos` | `GET` | Listado de atractivos turísticos |

---

## 👥 Equipo del Proyecto

- **Fátima Ximena García González** — Product Owner
- **Diego Parra Cruz** — Scrum Master
- **José de Jesús López Islas** — Pruebas y Calidad
- **Melanie Joliee Bonilla Domínguez** — Documentación
