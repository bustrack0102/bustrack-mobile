# Constitución — BusTrack Mobile

> Fuente de verdad del repositorio. Versión 2.0.0 (2026-10-30). Todo cambio de arquitectura
> exige spec y registro en `Memoria.md`.

## 1. Propósito

BusTrack Mobile forma parte del ecosistema BusTrack. Aplicación móvil tiene como responsabilidad:
Flutter -> API central por HTTPS/REST. No acceso directo a Cosmos ni a ML/GenAI.

## 2. Responsabilidades

- Mantener una responsabilidad delimitada dentro de BusTrack.
- Consumir o exponer contratos HTTP documentados.
- No duplicar datos ni lógica que pertenecen a otro servicio.
- Aplicar SDD: toda funcionalidad nace de un spec aprobado.

## 3. Arquitectura y tecnologías

- **Actual:** Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
- **Objetivo:** Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- Cambiar la tecnología objetivo requiere autorización explícita y un spec de migración.

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.
- El mapa es de consulta/orientación; no hay rastreo GPS continuo.
- La sesión se guarda en almacenamiento seguro.

## 4. Principios de diseño

- Separación de responsabilidades y dependencias dirigidas al dominio.
- Contratos explícitos, validados y versionados.
- Configuración por entorno y cero secretos en el repositorio.
- Real-first: no se declara implementado lo que no existe en código o pruebas.
- `Memoria.md` refleja el estado real, no el deseado.

## 5. Seguridad

Almacenamiento seguro de tokens, TLS, sin secretos en código, logs sanitizados, consentimiento de sensores y ofuscación de release.

- Prohibido registrar tokens, contraseñas, claves o PII.
- Los secretos viven en variables de entorno o Azure Key Vault.
- Toda entrada externa se valida y toda salida se codifica.

## 6. Calidad y pruebas

- Pruebas unitarias Dart, pruebas de widgets, pruebas de contrato HTTP y pruebas de integración de flujos.
- Sin pruebas y evidencia de ejecución no hay terminado.
- Los gates de CI para lint, pruebas y SAST son bloqueantes.
- Los tests triviales no cuentan como cobertura.

## 7. Convenciones

- Código e identificadores en inglés; documentación y mensajes de usuario en español.
- Formato y lint según el stack objetivo.
- PR pequeños y trazables a un spec.
- Prohibido `TODO` sin issue asociado.

## 8. Restricciones

- No rastreo GPS continuo de usuarios ni unidades.
- No acceso directo de clientes a Cosmos DB.
- No invención de rutas, horarios, tarifas, empresas o destinos por parte de IA.
- No recolección de sensores sin consentimiento explícito.
- No se declaran recursos Azure desplegados.

## 9. Integración con BusTrack

- Contratos transversales: `docs/contratos-integracion.md`.
- La API central es la fuente autorizada de datos de transporte.
- ML y GenAI son servicios internos.

## 10. Gobernanza

- Obligatorios: este documento, `AGENTS.md`, `Memoria.md`, `CHECKLIST_PR.md` y `specs/`.
- Las decisiones no resueltas se registran como pendientes; no se inventan respuestas.
