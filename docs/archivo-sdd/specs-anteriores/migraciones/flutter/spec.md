# Migración Kotlin/Compose → Flutter + Dart

> Repositorio: BusTrack Mobile · Ruta: `specs/migraciones/flutter/` · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Identificador y nombre

- **ID:** `migraciones/flutter`
- **Nombre:** Migración Kotlin/Compose → Flutter + Dart
- **Repositorio:** BusTrack Mobile

## 2. Objetivo

Documentar la migración de la app Android Kotlin/Compose a Flutter + Dart sin ejecutarla.

## 3. Contexto

El código actual Kotlin tiene login, sesión y logout. Se conserva como referencia; la app Flutter no existe.

## 4. Alcance

**Incluye:**

- Flujos, modelos, contratos, validaciones y pruebas reutilizables.
- Arquitectura objetivo Flutter.
- Equivalencia funcional.
- Riesgos y reversión.

**No incluye:**

- Implementar Flutter ahora.
- Eliminar Kotlin.
- Cambiar contratos de la API.

## 5. Requisitos funcionales

1. Reutilizar contratos y reglas como referencia.
2. Mantener paridad de login/sesión/logout.
3. Documentar diferencias de plataforma.
4. No asumir conversión automática.

## 6. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad spec -> tarea -> prueba.

## 7. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 8. Criterios de aceptación

- [ ] Login, sesión y logout con paridad funcional.
- [ ] Contratos y validaciones equivalentes.
- [ ] Pruebas de paridad documentadas.
- [ ] Código Kotlin conservado.

## 9. Restricciones

- No ejecutar migraciones ni despliegues en esta fase.
- No cambiar el stack objetivo sin autorización.
- No incluir secretos ni PII.

## 10. Dependencias

- `docs/contratos-integracion.md`
- specs/endpoints/login/
- specs/endpoints/logout/

## 11. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
