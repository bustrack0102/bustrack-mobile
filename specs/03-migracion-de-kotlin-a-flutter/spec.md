# 03-migracion-de-kotlin-a-flutter — Migración de Kotlin/Compose a Flutter

> Repositorio: BusTrack Mobile · Estado: Parcial · Fecha: 2026-11-10.

## 1. Objetivo

Planificar y ejecutar por fases la migración funcional de Kotlin a Flutter conservando paridad.

## 2. Contexto

Kotlin tiene login, sesión y logout implementados. En Flutter se implementó la base UI de autenticación y navegación inicial; falta migrar la integración de red y almacenamiento seguro.

## 3. Alcance

**Incluye:**

- Inventario de flujos Kotlin.
- Paridad de login/sesión/logout.
- Pruebas de paridad.
- Reversión.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. Conservar contratos y reglas.
2. Mantener Kotlin como referencia.
3. Documentar diferencias de plataforma.
4. No eliminar código hasta validar.

## 5. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad tarea -> prueba -> evidencia.

## 6. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 7. Criterios de aceptación

- [ ] La tarea tiene criterios verificables y evidencia asociada.
- [ ] No se declara implementado lo que no existe en código o pruebas.
- [ ] Los contratos consumidos o expuestos quedan documentados.
- [ ] `Memoria.md` refleja el estado resultante.

## 8. Dependencias

- `constitution.md`
- `docs/contratos-integracion.md`

## 9. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.

## Aprobación

- [x] Revisión de arquitectura móvil (Flutter/Kotlin) realizada — fecha: 2026-11-11
- [x] CHECKLIST_PR.md validado
- [x] Sin conflicto con constitution.md
