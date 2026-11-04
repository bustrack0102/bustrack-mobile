# 04-autenticacion — Autenticación en la aplicación

> Repositorio: BusTrack Mobile · Estado: Parcial · Fecha: 2026-10-30.

## 1. Objetivo

Implementar login con validación, estado de UI y bloqueo de doble envío, con paridad en Flutter.

## 2. Contexto

Implementado en Kotlin; pendiente en Flutter.

## 3. Alcance

**Incluye:**

- Formulario y validación.
- Llamada al login de la API.
- Errores tipados.
- Bloqueo de doble envío.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. Validar antes de llamar a la API.
2. Mapear 401/403/429 a mensajes claros.
3. No registrar credenciales.
4. Deshabilitar envío mientras procesa.

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
