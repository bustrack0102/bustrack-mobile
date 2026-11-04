# CI/CD — BusTrack Mobile

> Documentación independiente de las specs funcionales. Los workflows ejecutables viven en
> `../.github/workflows/`.

## 1. Arquitectura del pipeline

`flutter pub get → dart format → flutter analyze → flutter test → cobertura → Semgrep`

- Disparadores: Pull Request y push a `main`.
- Permisos: `contents: read`.
- Artefactos: resultados de pruebas y cobertura cuando el stack lo permita.
- Resumen de tareas: 16 specs funcionales.

## 2. Etapas

| Etapa | Herramienta | Bloqueante |
|---|---|---|
| Formato / lint | GitHub Actions | Sí |
| Pruebas | Pruebas unitarias Dart, pruebas de widgets, pruebas de contrato HTTP y pruebas de integración de flujos | Sí |
| Análisis estático | Semgrep (`.semgrep/rules/semgrep.yaml`) | Sí |
| Dependencias | Auditoría del ecosistema | Sí, con justificación de vulnerabilidades |
| Secretos | Gitleaks / reglas del repositorio | Sí |
| Construcción | Build del stack objetivo | Sí |

## 3. Condiciones de aprobación

- [ ] Lint y formato en verde.
- [ ] Pruebas en verde y cobertura reportada.
- [ ] Semgrep sin hallazgos nuevos.
- [ ] Sin secretos detectados.
- [ ] Build reproducible.
- [ ] `Memoria.md` y spec actualizados.

## 4. Requisitos de Pull Request

- Enlace a la tarea de `../specs/` o al endpoint de `../specs-endpoints/`.
- `CHECKLIST_PR.md` completo con evidencia.
- Sin cambios de alcance fuera de la spec.
- Sin commits/push/despliegue sin autorización.
