# Specs por tarea — BusTrack Mobile

> Cada carpeta numerada representa una tarea o funcionalidad concreta y contiene
> `spec.md`, `plan.md`, `task.md` y `chart.md`. Las categorías técnicas generales
> ya no viven aquí: CI/CD está en `../cicd/` y Azure en `../azure/`.
> El historial se conserva en `../docs/archivo-sdd/specs-anteriores/`.

## Tareas

| ID | Tarea | Estado |
|---|---|---|
| `01-configuracion-inicial-del-proyecto` | Configuración inicial del proyecto | Implementado |
| `02-arquitectura-base-flutter` | Arquitectura base Flutter | Parcial |
| `03-migracion-de-kotlin-a-flutter` | Migración de Kotlin/Compose a Flutter | Parcial |
| `04-autenticacion` | Autenticación en la aplicación | Parcial |
| `05-gestion-de-sesiones` | Gestión de sesiones | Parcial |
| `06-consulta-de-empresas` | Consulta de empresas | Pendiente |
| `07-consulta-de-rutas` | Consulta de rutas | Pendiente |
| `08-consulta-de-paradas` | Consulta de paradas | Pendiente |
| `09-consulta-de-destinos` | Consulta de destinos | Pendiente |
| `10-consulta-de-horarios-y-tarifas` | Consulta de horarios y tarifas | Pendiente |
| `11-mapa-de-consulta` | Mapa de consulta | Pendiente |
| `12-comparacion-de-alternativas` | Comparación de alternativas | Pendiente |
| `13-calificaciones` | Calificaciones de servicio | Pendiente |
| `14-captura-de-acelerometro-con-consentimiento` | Captura de acelerómetro con consentimiento | Pendiente |
| `15-integracion-con-servicio-ml` | Integración con el servicio ML | Pendiente |
| `16-publicacion-en-google-play` | Publicación en Google Play | Pendiente |

## Reglas

- No crear carpetas vacías ni specs genéricas para completar la estructura.
- No dividir una tarea en varias specs ni agrupar funcionalidades independientes.
- Una tarea pasa a `Implementado` solo con código y pruebas verificables.
- Los endpoints se documentan aparte, en `../specs-endpoints/`.
