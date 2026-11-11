# 14-captura-de-acelerometro-con-consentimiento — Captura de acelerómetro con consentimiento

> Repositorio: BusTrack Mobile · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Objetivo

Capturar lotes de acelerómetro solo con consentimiento explícito y revocable.

## 2. Contexto

No implementado. Es requisito previo a la integración con ML.

## 3. Alcance

**Incluye:**

- Pantalla de consentimiento.
- Captura y lotes.
- Anonimización local.
- Revocación y borrado.

**No incluye:**

- Captura sin consentimiento.
- Identificación de usuarios en lotes.

## 4. Requisitos funcionales

1. Solicitar consentimiento antes de capturar.
2. Permitir revocar y borrar.
3. Anonimizar antes de enviar.
4. No capturar en segundo plano sin aviso.

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
