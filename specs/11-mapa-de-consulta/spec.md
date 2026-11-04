# 11-mapa-de-consulta — Mapa de consulta

> Repositorio: BusTrack Mobile · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Objetivo

Mostrar rutas, paradas y destinos registrados en un mapa de consulta.

## 2. Contexto

No implementado. No se contempla rastreo GPS continuo.

## 3. Alcance

**Incluye:**

- Mapa de solo consulta.
- Marcadores de paradas/destinos.
- Trazado de ruta registrada.

**No incluye:**

- Rastreo GPS en vivo.
- Navegación turn-by-turn.
- Ubicación continua en segundo plano.

## 4. Requisitos funcionales

1. Solo mostrar datos registrados.
2. Permisos de ubicación opcionales y mínimos.
3. Sin seguimiento en segundo plano.

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
