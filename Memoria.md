# Memoria técnica — BusTrack Mobile

> Registro vivo. No se borra historial. Última actualización: 2026-11-10.

## 1. Estado real

- **Repositorio:** `bustrack-mobile-main` (raíz interior; el árbol está anidado `X-main/X-main`).
- **Tecnología actual:** Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
- **Tecnología objetivo:** Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- **Git:** repositorio Git activo en rama `main` conectado a `https://github.com/bustrack0102/bustrack-mobile.git`.

## 2. Funcionalidades implementadas

- Login con validación en dominio, estado de UI y bloqueo de doble envío.
- Sesión persistente con expiración server-driven en EncryptedSharedPreferences.
- Restauración de sesión al arranque y logout local-first.
- Consumo de POST /api/v1/Auth/login y /logout con mapeo HTTP a errores tipados.
- 79 métodos de prueba / 88 ejecuciones unitarias y fixtures de contrato en Kotlin.
- Interfaz gráfica y flujo de pantallas base en Flutter: Splash, Login, Registro, Verificación OTP y Home Demo con sistema de diseño (`AppColors`, `AppTypography`, `AppTheme`), widgets reutilizables (`PrimaryButton`, `CustomTextField`, `OtpField`, `LiveStatusCard`) y 4 pruebas de widget en `test/widget_test.dart`.

## 3. Funcionalidades pendientes

- Migración completa a Flutter + Dart (capa de red HTTP real, almacenamiento seguro de tokens y gestor de estado/DI formal).
- Consulta de empresas, rutas, paradas, destinos, horarios, tarifas y mapa.
- Comparación de alternativas y calificaciones.
- Captura de acelerómetro con consentimiento e integración con ML.
- Publicación en Google Play y firma de release.

## 4. Arquitectura actual

Estructura híbrida en transición:
- **Flutter:** `lib/{core/{theme,widgets}, features/{auth,home,splash}/presentation/screens}`; `test/widget_test.dart`.
- **Kotlin:** `app/src/main/java/com/example/movilsdd` (completa con capas data, di, domain, ui, util) y `app/src/test/java/...`.

## 5. Migraciones

Kotlin + Jetpack Compose -> Flutter + Dart

## 6. Decisiones arquitectónicas

- Se adopta SDD y DevSecOps.
- La API central es la fuente autorizada de datos.
- Cosmos DB for NoSQL es la persistencia objetivo.
- ML y GenAI son servicios internos FastAPI.
- OpenAI API es el proveedor GenAI objetivo; Google GenAI queda inactivo.
- Flutter + Dart y Angular + TypeScript son los objetivos de cliente.
- No se declaran recursos Azure desplegados.

## 7. Dependencias entre repositorios

Flutter -> API central por HTTPS/REST. No acceso directo a Cosmos ni a ML/GenAI.

## 8. Problemas conocidos

- Documentación previa desalineada con el código (corregida en esta reorganización).
- Specs históricas conservadas como referencia; ver `specs/README.md`.
- Gates CI/SAST incompletos o no bloqueantes en el estado previo.
- Deuda de pruebas y despliegue documentada en cada spec.

## 9. Historial

- **2026-10-29:** estructura SDD original y primeras fases.
- **2026-10-30:** auditoría completa, corrección documental y reorganización SDD.
  Se separan specs históricas de canónicas, se corrigen afirmaciones de stack y se
  documentan migraciones, contratos y Azure propuesto.
- **2026-11-10:** análisis integral del proyecto y sincronización exhaustiva de estados en SDD (`specs/` y `specs-endpoints/`).
  - **Decisión:** Reflejar el estado real de avance en Flutter (UI y widgets implementados) y Kotlin (backend local y tests completos), actualizando tareas y criterios con evidencia verificable.
  - **Motivo:** Evitar discrepancias entre el código fuente existente y la documentación viva SDD.
  - **Archivos afectados:** `specs/README.md`, `specs-endpoints/README.md`, `specs/01` a `16/task.md` y `spec.md`, `specs-endpoints/17` a `25/task.md` y `spec.md`, `Memoria.md`, `lib/`, `test/`, `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`.
  - **Estado:** Spec 01 Implementado; Specs 02, 03, 04, 05 Parciales; Specs 06 a 16 Pendientes. Endpoint 17 Implementado en Kotlin / Parcial en Flutter; 18 Implementado en Kotlin / Pendiente en Flutter; 19 a 25 Propuestos. Base de Flutter y documentación agregadas al control de versiones.
  - **Riesgos:** Falta de persistencia segura y consumo HTTP real en Flutter.
  - **Relación con otros repos:** Contratos alineados con API central (`/api/v1/auth/login`, `/api/v1/auth/logout`).
- **2026-11-10:** sincronización y confirmación de cambios en Git (`origin/main`).
  - **Decisión:** Versionar la actualización SDD y la base de código Flutter inicial (`lib/`, `test/`, configuración y especificaciones).
  - **Motivo:** Autorización explícita del usuario para enviar los cambios a Git y mantener trazabilidad estricta en `Memoria.md`.
  - **Archivos afectados:** Árbol completo de specs, specs-endpoints, código Flutter (`lib/`, `test/`, `web/`, configuración) y `Memoria.md`.
  - **Estado:** Repositorio local sincronizado con remoto.
