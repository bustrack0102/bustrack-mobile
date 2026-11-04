# Calificaciones y acelerómetro con consentimiento

> Repositorio: BusTrack Mobile · Ruta: `specs/funcionalidades/calificaciones-acelerometro/` · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Identificador y nombre

- **ID:** `funcionalidades/calificaciones-acelerometro`
- **Nombre:** Calificaciones y acelerómetro con consentimiento
- **Repositorio:** BusTrack Mobile

## 2. Objetivo

Especificar calificaciones de servicio y captura de acelerómetro con consentimiento explícito.

## 3. Contexto

No hay captura de sensores implementada.

## 4. Alcance

**Incluye:**

- Calificación de empresas/servicios.
- Consentimiento explícito y revocable.
- Captura y envío de lotes anonimizados.
- Integración con ML.

**No incluye:**

- Rastreo GPS.
- Identificación de usuarios en los lotes.
- Recolección sin consentimiento.

## 5. Requisitos funcionales

1. El usuario acepta antes de capturar.
2. Puede revocar y borrar datos locales.
3. Los lotes se anonimizan antes de enviarse.
4. La API valida y reenvía a ML.

## 6. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad spec -> tarea -> prueba.

## 7. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 8. Criterios de aceptación

- [ ] Pantalla de consentimiento y revocación.
- [ ] Lotes anonimizados.
- [ ] Envío con manejo de errores.
- [ ] Pruebas de privacidad.

## 9. Restricciones

- No declarar implementación existente.
- No recolectar sin consentimiento.

## 10. Dependencias

- specs/endpoints/login/
- docs/contratos-integracion.md
- servicio ML

## 11. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
