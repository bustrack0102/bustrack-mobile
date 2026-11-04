# Plan técnico — 21-endpoint-paradas — Consumo del endpoint de paradas

> Spec: `spec.md` · Endpoint: `GET /api/v1/rutas/{id}/paradas` · Estado: Propuesto.

## 1. Estrategia

Definir contrato, esquema de entrada/salida, validaciones y pruebas antes de implementar.

## 2. Diseño

- Stack objetivo: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- Componentes: controlador/router, servicio, repositorio o cliente HTTP.
- Tecnología: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.

## 3. Archivos

```text
lib/features/paradas/ (futuro), specs/08-consulta-de-paradas/
```

## 4. Seguridad

- Almacenamiento seguro de tokens, TLS, sin secretos en código, logs sanitizados, consentimiento de sensores y ofuscación de release.
- Validar entradas y no registrar secretos/PII.

## 5. Errores

- Respuesta uniforme sin stack traces ni detalles internos.
- Registrar correlación sin datos sensibles.

## 6. Pruebas

Pruebas de contrato, validación, autenticación y errores cuando el endpoint exista; casos definidos mientras sea propuesto.

## 7. Riesgos

- Contrato desalineado con el consumidor.
- Errores no cubiertos.
- Exposición de datos sensibles.
