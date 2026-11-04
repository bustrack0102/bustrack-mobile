# 17-endpoint-login — Consumo del endpoint de login

> Repositorio: BusTrack Mobile · Endpoint: `POST /api/v1/auth/login` · Estado: Implementado en Kotlin · Fecha: 2026-10-30.

## 1. Objetivo

Consumir el login de la API y mapear la respuesta a la sesión local.

## 2. Contrato

| Campo | Valor |
|---|---|
| Método | `POST` |
| Ruta | `/api/v1/auth/login` |
| Autenticación | No aplica; es el endpoint que emite la sesión. |
| Consumidor | App móvil |
| Estado | Implementado en Kotlin |

**Parámetros / entrada:**

- Body: usuario/correo y contraseña.

**Respuesta:**

- 200: JWT y expiración.
- 401/403/429: errores mapeados.

## 3. Códigos HTTP

- 200/201: éxito.
- 400/422: validación.
- 401/403: autenticación/autorización.
- 404: recurso inexistente.
- 409: conflicto.
- 429: rate limit.
- 500: error interno sin detalles.

## 4. Validaciones

1. Validación local antes de enviar.
2. Bloqueo de doble envío.

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
