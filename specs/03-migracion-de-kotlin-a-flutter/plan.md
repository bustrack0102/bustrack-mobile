# Plan técnico — 03-migracion-de-kotlin-a-flutter — Migración de Kotlin/Compose a Flutter

> Spec: `spec.md` · Repositorio: BusTrack Mobile · Estado: Pendiente.

## 1. Estrategia

Implementar por incrementos, conservando contratos y midiendo con pruebas antes de avanzar.

## 2. Arquitectura y componentes

- Stack objetivo: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- Componentes: componentes del repositorio afectados por la tarea.
- Tecnología: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.

## 3. Archivos y estructura

```text
app/src/main/java/com/example/movilsdd/ (referencia), lib/, test/
```

## 4. Seguridad

- Almacenamiento seguro de tokens, TLS, sin secretos en código, logs sanitizados, consentimiento de sensores y ofuscación de release.
- Validar entradas y no registrar secretos/PII.

## 5. Riesgos

- Confundir el estado actual con el objetivo.
- Dependencias con otros repositorios no documentadas.
- Ampliar el alcance sin spec aprobada.

## 6. Estrategia de pruebas

Pruebas unitarias y de contrato cuando exista código; revisión documental mientras la tarea sea propuesta.

## 7. Trazabilidad

Cada tarea de `task.md` referencia un requisito de `spec.md`; los diagramas viven en `chart.md`.
