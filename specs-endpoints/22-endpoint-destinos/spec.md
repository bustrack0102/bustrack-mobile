# 22-endpoint-destinos — Consumo del endpoint de destinos

> Repositorio: BusTrack Mobile · Endpoint: `GET /api/v1/destinos` · Estado: Propuesto · Fecha: 2026-10-30.

## 1. Objetivo

Consumir el catálogo de destinos disponible.

## 2. Contrato

| Campo | Valor |
|---|---|
| Método | `GET` |
| Ruta | `/api/v1/destinos` |
| Autenticación | Consume JWT de la API; sesión local cifrada. No emite tokens. |
| Consumidor | App móvil |
| Estado | Propuesto |

**Parámetros / entrada:**

- Query: búsqueda.

**Respuesta:**

- 200: destinos.

## 3. Códigos HTTP

- 200/201: éxito.
- 400/422: validación.
- 401/403: autenticación/autorización.
- 404: recurso inexistente.
- 409: conflicto.
- 429: rate limit.
- 500: error interno sin detalles.

## 4. Validaciones

1. Búsqueda normalizada.

## 5. Seguridad

- Almacenamiento seguro de tokens, TLS, sin secretos en código, logs sanitizados, consentimiento de sensores y ofuscación de release.
- No registrar tokens, credenciales ni PII.

## 6. Criterios de aceptación

- [ ] La tarea tiene criterios verificables y evidencia asociada.
- [ ] No se declara implementado lo que no existe en código o pruebas.
- [ ] Los contratos consumidos o expuestos quedan documentados.
- [ ] `Memoria.md` refleja el estado resultante.

## 7. Dependencias

- `docs/contratos-integracion.md`
- `spec.md` de la tarea funcional asociada
