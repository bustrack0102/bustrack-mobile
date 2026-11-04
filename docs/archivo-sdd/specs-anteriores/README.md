# Specs — BusTrack Mobile

> Catálogo canónico. Cada spec contiene `spec.md`, `plan.md`, `task.md` y `chart.md`.
> Las specs históricas se conservan como referencia y **no** rigen el desarrollo.

## Specs canónicas

| ID | Nombre | Estado |
|---|---|---|
| `00-fundamentos` | 00 — Fundamentos y gobernanza SDD | Implementado |
| `01-configuracion` | 01 — Configuración del entorno | Parcial |
| `02-arquitectura` | 02 — Arquitectura y límites del servicio | Parcial |
| `endpoints/login` | Endpoint / flujo de login | Implementado |
| `endpoints/logout` | Cierre de sesión / revocación | Implementado |
| `integraciones` | Integraciones con el ecosistema BusTrack | Parcial |
| `seguridad` | Seguridad y privacidad | Parcial |
| `pruebas` | Estrategia de pruebas | Parcial |
| `cicd` | CI/CD y gates de calidad | Parcial |
| `azure` | Arquitectura Azure propuesta | Propuesta |
| `migraciones/flutter` | Migración Kotlin/Compose → Flutter + Dart | Pendiente |
| `funcionalidades/consulta-transporte` | Consulta de transporte, mapa y alternativas | Pendiente |
| `funcionalidades/calificaciones-acelerometro` | Calificaciones y acelerómetro con consentimiento | Pendiente |

## Historial

- `FT-00` … `FT-04` y `README.md` (histórico Kotlin/Compose).

## Reglas

- No copiar specs de otro stack.
- Toda spec nueva debe declarar objetivo, alcance, requisitos, criterios de aceptación y dependencias.
- Una spec solo pasa a `Implementado` con código y pruebas verificables.
- `Memoria.md` es la fuente del estado real.
