# 01-configuracion-inicial-del-proyecto — Configuración inicial del proyecto

> Repositorio: BusTrack Mobile · Estado: Implementado · Fecha: 2026-11-10.

## 1. Objetivo

Dejar un proyecto móvil configurable, con dependencias, entornos y comandos reproducibles.

## 2. Contexto

Existe la app Kotlin/Compose con Gradle, Koin, Retrofit y Kover, y la configuración base de Flutter en `pubspec.yaml`, `analysis_options.yaml` y árbol `lib/`.

## 3. Alcance

**Incluye:**

- Proyecto y Gradle actuales.
- Dependencias.
- Entornos dev/prod.
- Comandos de build y test.

**No incluye:**

- Cambiar el stack objetivo.
- Desplegar recursos o ejecutar migraciones en esta fase.

## 4. Requisitos funcionales

1. El proyecto actual compila y ejecuta pruebas.
2. La configuración no incluye secretos.
3. Los entornos están separados.
4. Se documenta la brecha hacia Flutter.

## 5. Requisitos no funcionales

1. Documentación verificable y sin secretos.
2. Cambios incrementales y reversibles.
3. Trazabilidad tarea -> prueba -> evidencia.

## 6. Reglas de negocio

- Flutter/Dart es la tecnología objetivo; Kotlin/Compose queda como referencia funcional.
- La app consume únicamente la API central; no accede a Cosmos DB.
- La captura de acelerómetro requiere consentimiento explícito y revocable.

## 7. Criterios de aceptación

- [x] La tarea tiene criterios verificables y evidencia asociada.
- [x] No se declara implementado lo que no existe en código o pruebas.
- [x] Los contratos consumidos o expuestos quedan documentados.
- [x] `Memoria.md` refleja el estado resultante.

## 8. Dependencias

- `constitution.md`
- `docs/contratos-integracion.md`

## 9. Trazabilidad

- Plan: `plan.md` · Tareas: `task.md` · Diagramas: `chart.md`.
- Estado real: `../../Memoria.md`.
- Contratos: `../../docs/contratos-integracion.md`.
