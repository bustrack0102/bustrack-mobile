# 16-publicacion-en-google-play — Publicación en Google Play

> Repositorio: BusTrack Mobile · Estado: Pendiente · Fecha: 2026-10-30.

## 1. Objetivo

Preparar firma, política de privacidad, ficha y publicación de la app Flutter.

## 2. Contexto

No hay app Flutter ni publicación. La app actual Kotlin no está publicada.

## 3. Alcance

**Incluye:**

- Firma de release.
- Política de privacidad.
- Ficha de tienda.
- Checklist de publicación.

**No incluye:**

- Publicar sin app terminada.
- Afirmar que la app ya está publicada.

## 4. Requisitos funcionales

1. Firma gestionada de forma segura.
2. Política de privacidad revisada.
3. Ficha veraz.
4. Checklist de Google Play.

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
