# 25-endpoint-lotes-de-acelerometro — Consumo del endpoint de lotes de acelerómetro

> Repositorio: BusTrack Mobile · Endpoint: `POST /api/v1/sensores/lotes` · Estado: Propuesto · Fecha: 2026-10-30.

## 1. Objetivo

Enviar lotes anonimizados de acelerómetro y recibir clasificación.

## 2. Contrato

| Campo | Valor |
|---|---|
| Método | `POST` |
| Ruta | `/api/v1/sensores/lotes` |
| Autenticación | JWT de usuario. |
| Consumidor | App móvil |
| Estado | Propuesto |

**Parámetros / entrada:**

- Body: lote anonimizado, frecuencia, ventanas.

**Respuesta:**

- 202: aceptado.
- 401/422/429: errores.

## 3. Códigos HTTP

- 200/201: éxito.
- 400/422: validación.
- 401/403: autenticación/autorización.
- 404: recurso inexistente.
- 409: conflicto.
- 429: rate limit.
- 500: error interno sin detalles.

## 4. Validaciones

1. Consentimiento.
2. Anonimización.
3. Tamaño y frecuencia válidos.

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
