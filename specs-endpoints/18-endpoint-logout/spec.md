# 18-endpoint-logout — Consumo del endpoint de logout

> Repositorio: BusTrack Mobile · Endpoint: `POST /api/v1/auth/logout` · Estado: Implementado en Kotlin · Fecha: 2026-10-30.

## 1. Objetivo

Revocar el token en la API y limpiar la sesión local.

## 2. Contrato

| Campo | Valor |
|---|---|
| Método | `POST` |
| Ruta | `/api/v1/auth/logout` |
| Autenticación | JWT vigente. |
| Consumidor | App móvil |
| Estado | Implementado en Kotlin |

**Parámetros / entrada:**

- Header Authorization: Bearer JWT.

**Respuesta:**

- 204: revocado.
- 401: token inválido.

## 3. Códigos HTTP

- 200/201: éxito.
- 400/422: validación.
- 401/403: autenticación/autorización.
- 404: recurso inexistente.
- 409: conflicto.
- 429: rate limit.
- 500: error interno sin detalles.

## 4. Validaciones

1. Logout local-first aunque falle la red.

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
