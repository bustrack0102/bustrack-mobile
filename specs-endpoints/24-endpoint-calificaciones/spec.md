# 24-endpoint-calificaciones — Consumo del endpoint de calificaciones

> Repositorio: BusTrack Mobile · Endpoint: `GET/POST /api/v1/calificaciones` · Estado: Propuesto · Fecha: 2026-10-30.

## 1. Objetivo

Registrar calificaciones y consultar agregados.

## 2. Contrato

| Campo | Valor |
|---|---|
| Método | `GET/POST` |
| Ruta | `/api/v1/calificaciones` |
| Autenticación | JWT de usuario. |
| Consumidor | App móvil |
| Estado | Propuesto |

**Parámetros / entrada:**

- POST: servicio, puntuación, comentario.

**Respuesta:**

- 201: creada.
- 200: agregados.
- 401/422/409: errores.

## 3. Códigos HTTP

- 200/201: éxito.
- 400/422: validación.
- 401/403: autenticación/autorización.
- 404: recurso inexistente.
- 409: conflicto.
- 429: rate limit.
- 500: error interno sin detalles.

## 4. Validaciones

1. Rango.
2. Autenticación.
3. Una por período.

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

## Aprobación

- [x] Revisión de arquitectura móvil (Flutter/Kotlin) realizada — fecha: 2026-11-11
- [x] CHECKLIST_PR.md validado
- [x] Sin conflicto con constitution.md
