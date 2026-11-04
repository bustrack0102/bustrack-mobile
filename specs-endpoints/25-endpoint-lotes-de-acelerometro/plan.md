# Plan técnico — 25-endpoint-lotes-de-acelerometro — Consumo del endpoint de lotes de acelerómetro

> Spec: `spec.md` · Endpoint: `POST /api/v1/sensores/lotes` · Estado: Propuesto.

## 1. Estrategia

Definir contrato, esquema de entrada/salida, validaciones y pruebas antes de implementar.

## 2. Diseño

- Stack objetivo: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- Componentes: controlador/router, servicio, repositorio o cliente HTTP.
- Tecnología: Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.

## 3. Archivos

```text
lib/features/sensores/ (futuro), specs/14-captura-de-acelerometro-con-consentimiento/, specs/15-integracion-con-servicio-ml/
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
