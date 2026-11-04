# 02-arquitectura-base-flutter — Arquitectura base Flutter

> Repositorio: BusTrack Mobile · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Objetivo

Definir la arquitectura feature-first de Flutter: capas, estado, DI, navegación y red.

## 2. Contexto

No existe código Flutter; Kotlin/Compose sirve como referencia funcional.

## 3. Alcance

**Incluye:**

- Estructura lib/{core,features,domain,data,presentation}.
- Gestión de estado y DI.
- Navegación.
- Cliente HTTP y manejo de errores.

**No incluye:**

- Implementar funcionalidades de negocio.
- Elegir librerías sin autorización.

## 4. Requisitos funcionales

1. Separar presentación, dominio y datos.
2. Definir cliente HTTP con timeouts.
3. Definir navegación y guards de sesión.
4. Documentar decisiones abiertas.

## 5. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad tarea -> prueba -> evidencia.

## 6. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 7. Criterios de aceptación

- [ ] La tarea tiene criterios verificables y evidencia asociada.
- [ ] No se declara implementado lo que no existe en código o pruebas.
- [ ] Los contratos consumidos o expuestos quedan documentados.
- [ ] `Memoria.md` refleja el estado resultante.

## 8. Dependencias

- `constitution.md`
- `docs/contratos-integracion.md`

## 9. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
