# Consulta de transporte, mapa y alternativas

> Repositorio: BusTrack Mobile · Ruta: `specs/funcionalidades/consulta-transporte/` · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Identificador y nombre

- **ID:** `funcionalidades/consulta-transporte`
- **Nombre:** Consulta de transporte, mapa y alternativas
- **Repositorio:** BusTrack Mobile

## 2. Objetivo

Especificar la consulta de empresas, rutas, paradas, destinos, horarios, tarifas, mapa y comparación de alternativas.

## 3. Contexto

La app actual solo tiene login y home placeholder.

## 4. Alcance

**Incluye:**

- Empresas y medios.
- Rutas/paradas/destinos.
- Horarios y tarifas.
- Mapa de consulta.
- Comparación de alternativas.

**No incluye:**

- Rastreo GPS en vivo.
- Navegación turn-by-turn.
- Reserva/pago.

## 5. Requisitos funcionales

1. Mostrar datos reales de la API.
2. El mapa solo muestra rutas/paradas/destinos registrados.
3. Comparar alternativas por criterios documentados.
4. No inventar datos.

## 6. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad spec -> tarea -> prueba.

## 7. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 8. Criterios de aceptación

- [ ] Cada pantalla consume un endpoint documentado.
- [ ] Estados vacío/error/carga definidos.
- [ ] Mapa sin GPS continuo.
- [ ] Pruebas de widgets.

## 9. Restricciones

- No ejecutar migraciones ni despliegues en esta fase.
- No cambiar el stack objetivo sin autorización.
- No incluir secretos ni PII.

## 10. Dependencias

- specs/endpoints/login/
- docs/contratos-integracion.md
- specs/migraciones/flutter/

## 11. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
