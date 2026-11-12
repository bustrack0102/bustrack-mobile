# Tareas — 13-calificaciones — Calificaciones de servicio

> Spec: `spec.md` · Plan: `plan.md` · Estado: Parcial.
> Marcar solo con evidencia. No marcar por documentar.

## Dependencias

1. T01 antes de T02
2. T02 antes de T03

## Actividades

### [x] T01. Definir formulario

- Rango.
- Comentario.

**Archivos:** `lib/features/feedback/presentation/screens/rate_contribute_screen.dart`, `lib/features/feedback/domain/contribution_service.dart`, specs-endpoints/24-endpoint-calificaciones/

**Evidencia:** formulario con calificación general, categorías, comentario, reporte de tarifa y reporte a la concesionaria; los datos se guardan solo en memoria local.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [ ] T02. Definir consulta

- Agregados.

**Archivos:** `lib/features/feedback/domain/models/contribution.dart`, specs-endpoints/24-endpoint-calificaciones/

**Evidencia:** modelo local definido; consulta de agregados y consumo HTTP pendientes.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T03. Definir pruebas

- Auth.
- Rango.
- Duplicado.

**Archivos:** `test/features/feedback/contribution_service_test.dart`, `test/features/feedback/rate_contribute_screen_test.dart`, specs-endpoints/24-endpoint-calificaciones/

**Evidencia:** validación de rango, almacenamiento local y ausencia de recompensas probados. Autenticación real, duplicados y sincronización pendientes.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

## Cierre

- [ ] Todas las tareas con evidencia.
- [x] `Memoria.md` actualizado.
- [x] Pruebas y gates ejecutados (`flutter analyze` y `flutter test`: 26 pruebas).
- [x] Sin afirmaciones de implementación no verificadas.
