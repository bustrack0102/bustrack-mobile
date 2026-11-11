# 05-gestion-de-sesiones — Gestión de sesiones

> Repositorio: BusTrack Mobile · Estado: Parcial · Fecha: 2026-11-10.

## 1. Objetivo

Persistir y restaurar la sesión de forma segura con expiración server-driven y logout local-first.

## 2. Contexto

Implementado en Kotlin con EncryptedSharedPreferences; pendiente en Flutter.

## 3. Alcance

**Incluye:**

- Almacenamiento seguro.
- Restauración al arranque.
- Expiración.
- Logout local-first.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. No guardar tokens en texto plano.
2. Restaurar solo si no expiró.
3. Limpiar sesión al expirar o cerrar sesión.
4. No bloquear el logout por fallo de red.

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
