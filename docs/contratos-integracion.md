# Contratos de integración — BusTrack Mobile

> Vista de los contratos que este repositorio expone o consume. Solo login/logout están
> implementados en los clientes y la API; el resto es **propuesta** hasta que exista código.

## 1. Principios

- La API central es la única fuente autorizada de datos de transporte.
- Ningún cliente accede a Cosmos DB ni a ML/GenAI directamente.
- ML y GenAI son servicios internos autenticados; no exponen login público.
- Toda integración usa HTTPS, timeouts y errores tipados.
- Lo propuesto se marca como tal; no se declaran endpoints inexistentes.

## 2. Consume (API central)

| Método | Ruta | Estado | Notas |
|---|---|---|---|
| POST | `/api/v1/auth/login` | Implementado (Kotlin) | Paridad obligatoria en Flutter. |
| POST | `/api/v1/auth/logout` | Implementado (Kotlin) | Local-first + revocación. |
| GET | `/api/v1/transporte/*` | Propuesta | Rutas, paradas, destinos, horarios, tarifas y mapa. |
| POST | `/api/v1/calificaciones` | Propuesta | Calificación de empresas/servicios. |
| POST | `/api/v1/sensores/lotes` | Propuesta | Lotes anonimizados de acelerómetro. |

## 3. No permite

- Acceso directo a Cosmos DB.
- Llamadas directas a ML o GenAI.
- Captura de sensores sin consentimiento explícito.

## 5. Errores uniformes

| Código | Significado |
|---|---|
| 400 | Petición mal formada. |
| 401 | Credencial ausente o inválida. |
| 403 | Sin permiso. |
| 404 | Recurso inexistente. |
| 409 | Conflicto de concurrencia/unicidad. |
| 422 | Validación de dominio/esquema. |
| 429 | Rate limit. |
| 500 | Error interno sin detalles sensibles. |
