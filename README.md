# BusTrack Mobile — BusTrack

> Sistema de consulta y planificación de transporte público — Universidad Tecnológica de Tula-Tepeji.
> SDD + DevSecOps. Este README describe el **estado real** y la **arquitectura objetivo**.

## Estado actual

- **Tecnología real:** Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
- **Tecnología objetivo:** Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- **Implementado:** ver lista en `Memoria.md`.
- **No implementado:** ver pendientes en `Memoria.md`.
- **Recursos Azure:** no desplegados; propuesta en `azure/`.

## Qué hace este repositorio

Flutter -> API central por HTTPS/REST. No acceso directo a Cosmos ni a ML/GenAI.

## Estructura

```text
lib/{core,features,domain,data,presentation}; test/, integration_test/ (estructura objetivo Flutter). Estructura real actual: app/src/main/java/com/example/movilsdd (Kotlin).
```

## Gobernanza SDD

| Documento | Propósito |
|---|---|
| `constitution.md` | Principios inalterables del repositorio. |
| `AGENTS.md` | Instrucciones para agentes de IA. |
| `Memoria.md` | Estado real, decisiones y deuda técnica. |
| `CHECKLIST_PR.md` | Controles obligatorios de PR. |
| `specs/` | Specs canónicas (`spec.md`, `plan.md`, `task.md`, `chart.md`). |
| `docs/contratos-integracion.md` | Contratos con los demás repositorios. |
| `.opencode/` | Agentes y skills específicos. |
| `.semgrep/` | Reglas SAST reales. |
| `.github/workflows/` | CI por stack. |

## Specs por tarea

- `specs/01-configuracion-inicial-del-proyecto/` — Configuración inicial del proyecto (Parcial).
- `specs/02-arquitectura-base-flutter/` — Arquitectura base Flutter (Pendiente).
- `specs/03-migracion-de-kotlin-a-flutter/` — Migración de Kotlin/Compose a Flutter (Pendiente).
- `specs/04-autenticacion/` — Autenticación en la aplicación (Parcial).
- `specs/05-gestion-de-sesiones/` — Gestión de sesiones (Parcial).
- `specs/06-consulta-de-empresas/` — Consulta de empresas (Pendiente).
- `specs/07-consulta-de-rutas/` — Consulta de rutas (Pendiente).
- `specs/08-consulta-de-paradas/` — Consulta de paradas (Pendiente).
- `specs/09-consulta-de-destinos/` — Consulta de destinos (Pendiente).
- `specs/10-consulta-de-horarios-y-tarifas/` — Consulta de horarios y tarifas (Pendiente).
- `specs/11-mapa-de-consulta/` — Mapa de consulta (Pendiente).
- `specs/12-comparacion-de-alternativas/` — Comparación de alternativas (Pendiente).
- `specs/13-calificaciones/` — Calificaciones de servicio (Pendiente).
- `specs/14-captura-de-acelerometro-con-consentimiento/` — Captura de acelerómetro con consentimiento (Pendiente).
- `specs/15-integracion-con-servicio-ml/` — Integración con el servicio ML (Pendiente).
- `specs/16-publicacion-en-google-play/` — Publicación en Google Play (Pendiente).

## Specs de endpoints

- `specs-endpoints/17-endpoint-login/` — `POST /api/v1/auth/login` (Implementado en Kotlin).
- `specs-endpoints/18-endpoint-logout/` — `POST /api/v1/auth/logout` (Implementado en Kotlin).
- `specs-endpoints/19-endpoint-empresas/` — `GET /api/v1/empresas` (Propuesto).
- `specs-endpoints/20-endpoint-rutas/` — `GET /api/v1/rutas` (Propuesto).
- `specs-endpoints/21-endpoint-paradas/` — `GET /api/v1/rutas/{id}/paradas` (Propuesto).
- `specs-endpoints/22-endpoint-destinos/` — `GET /api/v1/destinos` (Propuesto).
- `specs-endpoints/23-endpoint-horarios-y-tarifas/` — `GET /api/v1/rutas/{id}/horarios y /tarifas` (Propuesto).
- `specs-endpoints/24-endpoint-calificaciones/` — `GET/POST /api/v1/calificaciones` (Propuesto).
- `specs-endpoints/25-endpoint-lotes-de-acelerometro/` — `POST /api/v1/sensores/lotes` (Propuesto).

## CI/CD y Azure

- `cicd/` — arquitectura del pipeline y gates.
- `azure/` — arquitectura final de despliegue (propuesta).

El historial de la organización anterior está en `docs/archivo-sdd/specs-anteriores/`.

## Comandos

```text
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze && flutter test
```

## Limitaciones y advertencias

- No se declara funcionalidad terminada sin código y pruebas.
- El árbol está anidado `X-main/X-main`; la raíz real es la carpeta interior.
- No hay repositorio Git local, por lo que tags/releases no son verificables.
- No hay despliegue Azure ni recursos provisionados.

## Equipo

Fátima Ximena García González, Diego Parra Cruz, José de Jesús López Islas, Melanie Joliee Bonilla Domínguez.
