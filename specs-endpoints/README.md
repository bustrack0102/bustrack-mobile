# Specs de endpoints — BusTrack Mobile

> Contratos HTTP que este repositorio expone o consume. Cada endpoint tiene
> `spec.md`, `plan.md`, `task.md` y `chart.md`. La numeración continúa después
> de la última tarea de `../specs/`.

## Endpoints

| ID | Método y ruta | Nombre | Estado |
|---|---|---|---|
| `17-endpoint-login` | `POST /api/v1/auth/login` | Consumo del endpoint de login | Implementado en Kotlin / Parcial en Flutter |
| `18-endpoint-logout` | `POST /api/v1/auth/logout` | Consumo del endpoint de logout | Implementado en Kotlin / Pendiente en Flutter |
| `19-endpoint-empresas` | `GET /api/v1/empresas` | Consumo del endpoint de empresas | Propuesto |
| `20-endpoint-rutas` | `GET /api/v1/rutas` | Consumo del endpoint de rutas | Propuesto |
| `21-endpoint-paradas` | `GET /api/v1/rutas/{id}/paradas` | Consumo del endpoint de paradas | Propuesto |
| `22-endpoint-destinos` | `GET /api/v1/destinos` | Consumo del endpoint de destinos | Propuesto |
| `23-endpoint-horarios-y-tarifas` | `GET /api/v1/rutas/{id}/horarios y /tarifas` | Consumo de horarios y tarifas | Propuesto |
| `24-endpoint-calificaciones` | `GET/POST /api/v1/calificaciones` | Consumo del endpoint de calificaciones | Propuesto |
| `25-endpoint-lotes-de-acelerometro` | `POST /api/v1/sensores/lotes` | Consumo del endpoint de lotes de acelerómetro | Propuesto |

## Reglas

- Diferenciar endpoints implementados de propuestos.
- No inventar endpoints ni métodos.
- Cada endpoint declara autenticación, validaciones, códigos HTTP y pruebas.
