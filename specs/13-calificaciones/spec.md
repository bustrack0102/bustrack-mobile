# 13-calificaciones — Calificaciones de servicio

> Repositorio: BusTrack Mobile · Estado: Parcial · Fecha: 2026-11-12.

## 1. Objetivo

Permitir calificar empresas/servicios y consultar agregados.

## 2. Contexto

Implementado en Flutter el formulario local de calificación, reporte de tarifa y reporte a la concesionaria, con validación de rango y aviso explícito de que las recompensas no están implementadas. La autenticación real, la consulta de agregados y el envío a la API quedan pendientes. Evidencia en `docs/map-integration.md`.

## 3. Alcance

**Incluye:**

- Formulario de calificación.
- Consulta de agregados.
- Autenticación.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. Solo usuarios autenticados.
2. Rango validado.
3. Sin PII en comentarios públicos.

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
