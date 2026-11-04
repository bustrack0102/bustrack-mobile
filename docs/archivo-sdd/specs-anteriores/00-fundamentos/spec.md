# 00 — Fundamentos y gobernanza SDD

> Repositorio: BusTrack Mobile · Ruta: `specs/00-fundamentos/` · Estado: Implementado · Fecha: 2026-10-30.

## 1. Identificador y nombre

- **ID:** `00-fundamentos`
- **Nombre:** 00 — Fundamentos y gobernanza SDD
- **Repositorio:** BusTrack Mobile

## 2. Objetivo

Fijar los principios, límites y flujo SDD de BusTrack Mobile.

## 3. Contexto

La documentación previa no reflejaba el estado real del repositorio. Esta spec establece la fuente de verdad.

## 4. Alcance

**Incluye:**

- Constitución, AGENTS, Memoria, CHECKLIST y README.
- Tecnología actual vs objetivo.
- Flujo spec→plan→task→chart→pruebas.
- Prohibición de declarar avances sin evidencia.

**No incluye:**

- Implementar funcionalidad de negocio.
- Cambiar la tecnología objetivo.
- Desplegar recursos.

## 5. Requisitos funcionales

1. Describir el stack actual: Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
2. Fijar el stack objetivo: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
3. Definir criterios de terminado y trazabilidad.
4. Registrar decisiones pendientes sin inventar respuestas.

## 6. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad spec -> tarea -> prueba.

## 7. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 8. Criterios de aceptación

- [ ] El documento existe y es coherente con el código.
- [ ] Las tareas tienen criterio de terminado verificable.
- [ ] No se declaran implementaciones inexistentes.

## 9. Restricciones

- No ejecutar migraciones ni despliegues en esta fase.
- No cambiar el stack objetivo sin autorización.
- No incluir secretos ni PII.

## 10. Dependencias

- `Memoria.md`
- `docs/contratos-integracion.md`

## 11. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
