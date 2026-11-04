# Plan técnico — Migración Kotlin/Compose → Flutter + Dart

> Spec: `spec.md` · Repositorio: BusTrack Mobile · Estado: Pendiente.

## 1. Estrategia técnica

Documentar el estado actual y el objetivo; implementar por incrementos con pruebas y sin romper contratos.

## 2. Arquitectura propuesta

- Stack objetivo: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- Componentes: Componentes del repositorio afectados por la spec.
- Tecnologías: Flutter + Dart.

## 3. Componentes afectados

- Componentes del repositorio afectados por la spec

## 4. Estructura de archivos

```text
lib/{core,features/auth,domain,data,presentation}, test/, integration_test/
```

## 5. Dependencias

- `docs/contratos-integracion.md`
- specs/endpoints/login/
- specs/endpoints/logout/

## 6. Consideraciones de seguridad

- Almacenamiento seguro de tokens, TLS, sin secretos en código, logs sanitizados, consentimiento de sensores y ofuscación de release.

- Validar entradas y no registrar secretos/PII.

## 7. Riesgos

- Confundir el estado actual con el objetivo.
- Documentación genérica o desalineada.
- Dependencias entre repos no documentadas.

## 8. Estrategia de pruebas

Revisión de coherencia documental y, cuando exista código, pruebas unitarias, de contrato y seguridad.

## 9. Trazabilidad

Cada tarea de `task.md` referencia un requisito de `spec.md`. Los diagramas están en `chart.md`.
