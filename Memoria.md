# Memoria técnica — BusTrack Mobile

> Registro vivo. No se borra historial. Última actualización: 2026-10-30.

## 1. Estado real

- **Repositorio:** `bustrack-mobile-main` (raíz interior; el árbol está anidado `X-main/X-main`).
- **Tecnología actual:** Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
- **Tecnología objetivo:** Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- **Git:** no hay repositorio Git local; los tags/releases no son verificables.

## 2. Funcionalidades implementadas

- Login con validación en dominio, estado de UI y bloqueo de doble envío.
- Sesión persistente con expiración server-driven en EncryptedSharedPreferences.
- Restauración de sesión al arranque y logout local-first.
- Consumo de POST /api/v1/Auth/login y /logout con mapeo HTTP a errores tipados.
- 79 métodos de prueba / 88 ejecuciones unitarias y fixtures de contrato.

## 3. Funcionalidades pendientes

- Migración completa a Flutter + Dart.
- Consulta de empresas, rutas, paradas, destinos, horarios, tarifas y mapa.
- Comparación de alternativas y calificaciones.
- Captura de acelerómetro con consentimiento e integración con ML.
- Publicación en Google Play y firma de release.

## 4. Arquitectura actual

lib/{core,features,domain,data,presentation}; test/, integration_test/ (estructura objetivo Flutter). Estructura real actual: app/src/main/java/com/example/movilsdd (Kotlin).

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
