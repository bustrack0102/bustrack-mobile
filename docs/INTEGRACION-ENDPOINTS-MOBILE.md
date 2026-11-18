# Auditoría e Inventario de Integración: BusTrack API vs Flutter Mobile

> **Fecha:** 2026-11-17  
> **Fuente de verdad:** Controladores y DTOs en `bustrack-api` (`API_SDD/Controllers/V1/*`, `API_SDD/DTOs/*`), `REPORTE-ENDPOINTS-API.md`, y código Dart en `bustrack-mobile` (`lib/*`).  
> **Base URL:** `https://bustrack-api.wonderfulpebble-cdcb3396.northcentralus.azurecontainerapps.io`

---

## 1. Resumen Ejecutivo del Estado de Conexión

- **Total de acciones del backend evaluadas:** 101 endpoints funcionales en `/api/v1` + 2 health probes (`/health`, `/health/ready`).
- **Conectados y activos en Flutter:** 14 endpoints (Login, Registro, Refresh, Logout, Recuperar Password, Restablecer Password, Perfil `GET /usuarios/me`, Medios de transporte, Rutas catálogo/búsqueda, Geometría, Paradas de ruta, Autocompletado de paradas, Cálculo de tarifas, Catálogo de destinos).
- **Declarados en constantes pero sin invocación real en UI/Servicio:** 11 endpoints (`empresas/autocompletar`, `mapa/elementos`, `horarios`, `horarios/siguiente`, `tarifas`, `destinos/autocompletar`, `destinos/categorias`, `catalogos/estado-actualizacion`, `sensores/lotes`, `health`, etc.).
- **Servicios simulados / locales que deben sustituirse por backend real:**
  1. `lib/features/profile/domain/account_service.dart` (`requestDeletion` retornaba mock → debe invocar `DELETE /api/v1/usuarios/me`).
  2. `lib/features/profile/presentation/screens/edit_profile_screen.dart` (solo actualizaba localmente → debe invocar `PUT /api/v1/usuarios/me`).
  3. `lib/features/feedback/domain/contribution_service.dart` (guardaba en listas en memoria con `syncedWithApi: false` → debe consumir `CalificacionesController` y reportes en `ModeracionController`).
  4. `lib/features/history/domain/journey_history_service.dart` (guardaba en memoria en `_journeys` → debe sincronizar con `ViajesController` `/api/v1/viajes`).
  5. `lib/features/profile/presentation/screens/permissions_manager_screen.dart` (guardaba en memoria local → debe sincronizar con `ConsentimientosController` `/api/v1/consentimientos`).
  6. `lib/features/sensors/domain/services/accelerometer_service.dart` (tenía método `submitBatchIfAuthorized` incompleto → debe sincronizar con `POST /api/v1/sensores/lotes` con payload de `LoteSensorCreateRequest`).
- **Endpoints inexistentes o ficticios que no deben conectarse:** `/asociaciones`, `/auth/2fa/*`, `/admin/bootstrap`, `/transporte/*`, `/auth/account`, `/auth/verificar-correo` (el backend no cuenta con verificación de correo por token; la cuenta queda activa desde el registro).

---

## 2. Inventario Completo por Módulos

### Módulo 1: Autenticación y Perfil (`AuthController`, `UsuariosController`)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/auth/registro` | POST | **Conectado** | `RegisterScreen` | Anon | `RegistroRequestDto` | `AuthResponseDto` | Mantener. |
| `/api/v1/auth/login` | POST | **Conectado** | `LoginScreen` | Anon | `LoginInputDto` | `AuthResponseDto` | Mantener. |
| `/api/v1/auth/refresh` | POST | **Conectado** | `AuthInterceptor` | Anon | `RefreshTokenRequestDto` | `TokenRefreshResponseDto` | Mantener renovación atómica con `Completer`. |
| `/api/v1/auth/logout` | POST | **Conectado** | `ProfileScreen` | JWT | `LogoutRequestDto` | 204 No Content | Mantener logout local-first. |
| `/api/v1/auth/recuperar-password` | POST | **Conectado** | `ForgotPasswordScreen` | Anon | `RecuperarPasswordRequestDto` (`correo`) | `MessageResponseDto` (`mensaje`) | Conectar a formulario real. |
| `/api/v1/auth/restablecer-password` | POST | **Conectado** | `ResetPasswordScreen` | Anon | `RestablecerPasswordRequestDto` (`token`, `nuevaPassword`, `confirmacionPassword`) | `MessageResponseDto` (`mensaje`) | Conectar con token del enlace. |
| `/api/v1/usuarios/me` | GET | **Conectado** | `ProfileScreen` | JWT | Ninguno | `UsuarioMeResponseDto` | Mapear estadísticas reales (viajes, calificaciones, consentimiento). |
| `/api/v1/usuarios/me` | PUT | **Conectado** | `EditProfileScreen` | JWT | `UsuarioMeUpdateRequestDto` (`nombreCompleto`, `correo`, `passwordActual`, `nuevaPassword`) | `UsuarioMeUpdateResponseDto` | Formulario conectado a la API de Azure. |
| `/api/v1/usuarios/me` | DELETE | **Conectado** | `ProfileScreen` / `AccountService` | JWT | `UsuarioMeDeleteRequestDto` (`passwordConfirmacion`) | 204 No Content | Conectado con diálogo de contraseña y purga local. |

---

### Módulo 2: Catálogos de Transporte (`Empresas`, `MediosTransporte`, `Rutas`, `Paradas`, `Horarios`, `Tarifas`, `Destinos`, `Mapa`)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/empresas` | GET | **Conectado** | `DiscoverScreen` | Anon | Query (`q`, `municipio`, `activo`) | `PagedEmpresasResponse` | Mantener. |
| `/api/v1/empresas/autocompletar` | GET | **Declarado** | Buscador de empresas | Anon | Query (`q`, `limite`) | `List<EmpresaAutocompleteDto>` | Conectar al buscador de la sección Descubrir. |
| `/api/v1/empresas/comparar` | GET | **Pendiente** | `DiscoverScreen` (Comparador) | Anon | Query (`ids`) | `List<EmpresaDetailDto>` | Conectar comparador de concesionarias. |
| `/api/v1/empresas/{id}` | GET | **Pendiente** | Detalle de Empresa | Anon | Path `id:guid` | `EmpresaDetailDto` | Crear vista/diálogo de detalle de empresa. |
| `/api/v1/empresas/{id}/rutas` | GET | **Pendiente** | Rutas por Concesionaria | Anon | Path `id:guid` | `List<RutaCatalogoItemDto>` | Integrar filtro en pantalla Explorar. |
| `/api/v1/medios-transporte` | GET | **Conectado** | `DiscoverScreen` | Anon | Ninguno | `List<MedioTransporteDto>` | Mantener. |
| `/api/v1/rutas` | GET | **Conectado** | `ExploreRoutesScreen` | Anon | Query (`q`, `empresaId`, `activa`) | `PagedRutasCatalogoResponse` | Mantener. |
| `/api/v1/rutas/buscar` | GET | **Conectado** | `ExploreRoutesScreen` | Anon | Query (`paradaOrigenId`, `paradaDestinoId`) | `RutaBusquedaResponse` | Mantener. |
| `/api/v1/rutas/autocompletar` | GET | **Declarado** | Barra de búsqueda de rutas | Anon | Query (`q`, `limite`) | `List<RutaAutocompleteItemDto>` | Conectar al campo de búsqueda en Explorar. |
| `/api/v1/rutas/{id}` | GET | **Pendiente** | `RouteDetailScreen` | Anon | Path `id:guid` | `RutaDetalleResponse` | Consumir horarios, tarifas y destinos vinculados. |
| `/api/v1/rutas/{id}/paradas` | GET | **Conectado** | `RouteDetailScreen` / Mapa | Anon | Path `id:guid` | `RutaParadasResponse` | Mantener. |
| `/api/v1/rutas/{id}/geometria` | GET | **Conectado** | `ExploreRoutesScreen` (Mapa) | Anon | Path `id:guid` | `RutaGeometriaDetalleDto` | Mantener trazo polilínea. |
| `/api/v1/rutas/{id}/horarios` | GET | **Pendiente** | `RouteDetailScreen` | Anon | Path `id:guid` | `List<HorarioItemDto>` | Mostrar tabla de corridas reales. |
| `/api/v1/rutas/{id}/tarifas` | GET | **Pendiente** | `RouteDetailScreen` | Anon | Path `id:guid` | `List<TarifaItemDto>` | Mostrar desglose de tarifas oficiales. |
| `/api/v1/paradas` | GET | **Declarado** | Explorador de paradas | Anon | Query (`q`, `municipio`) | `PagedParadasResponse` | Conectar listado y marcadores globales. |
| `/api/v1/paradas/autocompletar` | GET | **Conectado** | `ParadaAutocompleteField` | Anon | Query (`q`, `limite`) | `List<ParadaAutocompleteItemDto>` | Mantener. |
| `/api/v1/paradas/cercanas` | GET | **Pendiente** | Mapa con ubicación autorizada | Anon | Query (`lat`, `lng`, `radioKm`) | `List<ParadaCercanaDto>` | Conectar cuando el usuario otorgue ubicación. |
| `/api/v1/paradas/{id}` | GET | **Pendiente** | `StopDetailSheet` | Anon | Path `id:string` | `ParadaDetalleDto` | Cargar detalle completo al tocar marcador en mapa. |
| `/api/v1/horarios/siguiente` | GET | **Declarado** | Tarjeta de ruta en viaje | Anon | Query (`rutaId`, `paradaId`) | `ProximaSalidaResponse` | Mostrar tiempo restante para próxima salida. |
| `/api/v1/tarifas/calcular` | GET | **Conectado** | `RouteDetailScreen` | Anon | Query (`rutaId`, `paradaSubidaId`, `paradaBajadaId`) | `CalculoTarifaResponse` | Mantener. |
| `/api/v1/destinos` | GET | **Conectado** | `DiscoverScreen` | Anon | Query (`categoria`) | `List<DestinoTuristicoDto>` | Mantener. |
| `/api/v1/destinos/categorias` | GET | **Declarado** | Filtro de destinos | Anon | Ninguno | `List<DestinoCategoriaCountDto>` | Reemplazar categorías estáticas por catálogo real. |
| `/api/v1/destinos/{id}/rutas` | GET | **Pendiente** | Detalle de destino | Anon | Path `id:string` | `List<RutaCatalogoItemDto>` | Ver rutas que llevan al destino seleccionado. |
| `/api/v1/mapa/elementos` | GET | **Declarado** | `ExploreRoutesScreen` | Anon | Query (`bbox`, `tipo`) | `MapaElementosDetalleResponse` | Cargar marcadores de paradas y destinos oficiales. |
| `/api/v1/catalogos/estado-actualizacion`| GET | **Declarado** | Cache Manager | Anon | Ninguno | `EstadoActualizacionCatalogosResponse` | Verificar si hubo cambios en catálogo antes de re-descargar. |

---

### Módulo 3: Calificaciones, Historial y Datos del Usuario (`Calificaciones`, `Viajes`, `Consentimientos`)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/calificaciones` | GET | **Pendiente** | Reseñas en Detalle de Ruta | Anon | Query (`rutaId`, `empresaId`, `page`) | `PagedCalificacionesResponse` | Mostrar opiniones reales de la ruta. |
| `/api/v1/calificaciones/resumen` | GET | **Pendiente** | Promedio de ruta/empresa | Anon | Query (`rutaId`, `empresaId`) | `CalificacionResumenDto` | Mostrar estrellas y distribución 1-5. |
| `/api/v1/calificaciones/mias` | GET | **Pendiente** | `TripHistoryScreen` / Perfil | JWT | Ninguno | `List<CalificacionItemDto>` | Listar calificaciones emitidas por el usuario. |
| `/api/v1/calificaciones` | POST | **Conectado** | `RateContributeScreen` | JWT | `CalificacionCreateRequest` (`RutaId`, `Puntuacion`, `Comentario`) | `CalificacionItemDto` (201) | Conectado vía `CalificacionesRemoteDataSource`. |
| `/api/v1/calificaciones/{id}` | PUT | **Implementado** | Editar reseña | JWT | `CalificacionUpdateRequest` | `CalificacionItemDto` | Método listo en data source. |
| `/api/v1/calificaciones/{id}` | DELETE | **Implementado** | Eliminar reseña | JWT | Path `id` | 204 No Content | Método listo en data source. |
| `/api/v1/viajes` | GET | **Implementado** | `TripHistoryScreen` | JWT | Ninguno | `List<ViajeItemDto>` | Conectado vía `ViajesRemoteDataSource`. |
| `/api/v1/viajes` | POST | **Conectado** | Iniciar/Guardar viaje | JWT | `ViajeCreateRequest` (`Titulo`, `RutaId`, `ParadaOrigenId`, `ParadaDestinoId`, `Favorito`) | `ViajeItemDto` (201) | Sincronización automática de viaje en Azure. |
| `/api/v1/viajes/{id}` | GET | **Implementado** | Detalle de Viaje Guardado | JWT | Path `id` | `ViajeDetalleDto` | Método listo en data source. |
| `/api/v1/viajes/{id}` | DELETE | **Implementado** | `TripHistoryScreen` | JWT | Path `id` | 204 No Content | Método listo en data source. |
| `/api/v1/consentimientos/me` | GET | **Conectado** | `PermissionsManagerScreen` | JWT | Ninguno | `ConsentimientoEstadoDto` | Consulta estado real en Azure. |
| `/api/v1/consentimientos` | POST | **Conectado** | `AccelerometerConsentDialog` | JWT | `OtorgarConsentimientoRequest` (`AceptaAviso`, `VersionAviso`) | `ConsentimientoEstadoDto` (201) | Registra consentimiento explícito en Azure. |
| `/api/v1/consentimientos/me` | DELETE | **Conectado** | `PermissionsManagerScreen` | JWT | Ninguno | 204 No Content | Revoca consentimiento en Azure y detiene sensor. |

---

### Módulo 4: Sensores, Machine Learning e Inteligencia Artificial (`Sensores`, `InferenciaController`)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/sensores/lotes` | POST | **Conectado** | `AccelerometerService` / Viaje | JWT | `LoteSensorCreateRequest` (`ViajeId`, `RutaId`, `IntervaloMuestreoMs`, `Muestras`) | `LoteSensorResultadoDto` | Transmite muestras triaxiales con contrato de Azure. |
| `/api/v1/telemetria/inferencia` | POST | **Pendiente** | Inferencia ML bajo demanda | Anon (consent) | `MlInferenceUpstreamRequest` | `MlInferenceUpstreamResponse` | Enviar ventana para clasificación vía ML (con fallback local). |
| `/api/v1/recomendaciones` | POST | **Pendiente** | Asistente de Viaje Inteligente | Anon/JWT | `GenAiUpstreamRequest` | `GenAiUpstreamResponse` | Recomendar mejor ruta basada en destino y preferencias. |
| `/api/v1/recomendaciones/historial` | GET | **Pendiente** | Historial de Asistente IA | JWT | Ninguno | `List<HistorialRecomendacionItemDto>` | Mostrar recomendaciones previas del usuario. |
| `/api/v1/recomendaciones/{id}/retroalimentacion` | POST | **Pendiente** | Feedback de recomendación | JWT | `RetroalimentacionRecomendacionRequest` (`Util`, `Puntuacion`, `Comentario`) | `RetroalimentacionRecomendacionResponse` | Calificar utilidad de la recomendación de IA. |

---

### Módulo 5: Funcionalidades Complementarias (`Dispositivos`, `Media`, `Moderacion`)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/dispositivos` | POST | **Pendiente** | Registro push FCM | JWT | `DispositivoRegisterRequest` (`TokenFcm`, `Plataforma`) | `DispositivoItemDto` (201) | Registrar token tras login si Firebase está disponible. |
| `/api/v1/dispositivos/mios` | GET | **Pendiente** | Dispositivos vinculados | JWT | Ninguno | `List<DispositivoItemDto>` | Ver dispositivos activos en perfil. |
| `/api/v1/dispositivos/{id}` | DELETE | **Pendiente** | Cierre de sesión / Dispositivos | JWT | Path `id` | 204 No Content | Desvincular token FCM al desloguearse. |
| `/api/v1/media/upload` | POST | **Pendiente** | Foto de perfil / Reporte | JWT | `multipart/form-data` (`file`) | `{ url: string, key: string }` | Soporte para subir imágenes JPG/PNG con límite de tamaño. |
| `/api/v1/moderacion` | POST | **Pendiente** | `RateContributeScreen` (Reporte) | Anon | `ModeracionCreateRequest` | `ModeracionItemDto` | Enviar reportes de concesionaria / tarifas al backend. |

---

### Módulo 6: Operaciones Administrativas (`AdminPolicy` / Roles Admin)

| Endpoint | Método | Estado Actual | Pantalla / Funcionalidad | Auth | Modelo Solicitud | Modelo Respuesta | Cambios Requeridos |
|---|---|---|---|---|---|---|---|
| `/api/v1/candidatos-parada` | GET | **Pendiente** | `AdminRouteManagementScreen` | Admin | Ninguno | `List<CandidatoParadaItemDto>` | Listar paradas detectadas por ML para validación. |
| `/api/v1/admin/candidatos-parada/{id}/validar` | PATCH | **Pendiente** | `AdminRouteManagementScreen` | Admin | `ValidarCandidatoParadaRequest` (`Aprobar`, `NombreParadaFinal`) | `ValidarCandidatoParadaResponse` | Aprobar o descartar parada candidata. |
| `/api/v1/rutas` | POST | **Pendiente** | `AdminRouteEditorScreen` | Admin | `RutaUpsertRequest` | `RutaCatalogoItemDto` (201) | Guardar nueva ruta creada en el editor cartográfico. |
| `/api/v1/rutas/{id}` | PUT | **Pendiente** | `AdminRouteEditorScreen` | Admin | `RutaUpsertRequest` | `RutaCatalogoItemDto` | Actualizar trazado, paradas y tarifa en Azure. |
| `/api/v1/rutas/{id}` | DELETE | **Pendiente** | `AdminRouteManagementScreen` | Admin | Path `id:guid` | 204 No Content | Dar de baja ruta existente. |
| `/api/v1/paradas` | POST | **Pendiente** | `AdminRouteEditorScreen` | Admin | `ParadaUpsertRequest` | `ParadaListItemDto` (201) | Crear parada georreferenciada desde el mapa. |
| `/api/v1/empresas` | POST | **Pendiente** | Directorio Admin | Admin | `EmpresaUpsertRequest` | `EmpresaDetailDto` (201) | Alta de empresa de transporte. |

---

## 3. Plan de Conexión Progresivo

1. **Fase 1 — Core y Saneamiento de Configuración:**
   - Alinear constantes de rutas en `lib/core/config/api_config.dart` con los nombres y rutas canónicas del backend.
   - Reforzar `api_client.dart` con manejo específico para códigos de error (`ErrorResponse` con `TraceId`, timeouts de 60s, rate-limits con `Retry-After`).
   - Implementar chequeos de salud `/health` y `/health/ready` y estado de actualización de catálogos `/api/v1/catalogos/estado-actualizacion`.

2. **Fase 2 — Perfil, Seguridad y Autenticación:**
   - Conectar actualización de perfil (`PUT /api/v1/usuarios/me`) en `EditProfileScreen`.
   - Conectar eliminación definitiva de cuenta (`DELETE /api/v1/usuarios/me`) en `AccountService` con confirmación de contraseña y purga local.
   - Conectar recuperación (`POST /api/v1/auth/recuperar-password`) y restablecimiento (`POST /api/v1/auth/restablecer-password`).
   - Documentar la omisión de `/auth/verificar-correo` (el backend no requiere verificación previa).

3. **Fase 3 — Datos del Usuario (Calificaciones, Historial de Viajes y Consentimientos):**
   - Crear `CalificacionesRemoteDataSource` y `CalificacionesRepository` para sustituir `ContributionService` local por llamadas reales a `/api/v1/calificaciones`.
   - Crear `ViajesRemoteDataSource` y `ViajesRepository` para sincronizar `JourneyHistoryService` con `/api/v1/viajes`.
   - Conectar `ConsentimientosRemoteDataSource` (`GET`, `POST`, `DELETE /api/v1/consentimientos/me`) con `PermissionsManagerScreen` y `AccelerometerConsentDialog`.

4. **Fase 4 — Catálogos y Mapa Cartográfico:**
   - Conectar `/api/v1/mapa/elementos` en `ExploreRoutesScreen` para renderizar paradas y destinos sobre el mapa interactivo.
   - Conectar `/api/v1/paradas/{id}` y `/api/v1/paradas/cercanas` en `StopDetailSheet`.
   - Conectar horarios (`/api/v1/rutas/{id}/horarios`, `/api/v1/horarios/siguiente`) y tarifas completas (`/api/v1/rutas/{id}/tarifas`).
   - Conectar autocompletado y categorías de destinos (`/api/v1/destinos/categorias`).

5. **Fase 5 — Acelerómetro, Telemetría ML e Inteligencia Artificial:**
   - Conectar `POST /api/v1/sensores/lotes` en `AccelerometerService` transmitiendo muestras con el formato `LoteSensorCreateRequest`.
   - Implementar cliente para `/api/v1/recomendaciones` (IA generativa asistencial) y feedback.

6. **Fase 6 — Moderación, Dispositivos y Administración:**
   - Conectar reportes de incidencias hacia `POST /api/v1/moderacion`.
   - Conectar CRUD de rutas en `AdminRouteEditorScreen` (`POST`, `PUT`, `DELETE /api/v1/rutas`) y validación de candidatos de paradas (`PATCH /api/v1/admin/candidatos-parada/{id}/validar`).

7. **Fase 7 — Pruebas y Validación:**
   - Pruebas unitarias de serialización/deserialización para cada DTO nuevo.
   - Ejecución de `flutter analyze` y `flutter test`.
   - Verificación de CI con `scripts/check_sdd.ps1`.
