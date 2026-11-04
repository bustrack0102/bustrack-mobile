# 09-consulta-de-destinos — Consulta de destinos

> Repositorio: BusTrack Mobile · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Objetivo

Permitir explorar destinos disponibles para planificar un viaje.

## 2. Contexto

No implementado; el dominio de destinos tampoco existe en la API.

## 3. Alcance

**Incluye:**

- Listado de destinos.
- Búsqueda.
- Selección para comparar alternativas.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. Destinos provienen de la API.
2. Búsqueda tolerante a mayúsculas/acentos.
3. Sin destinos inventados.

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
