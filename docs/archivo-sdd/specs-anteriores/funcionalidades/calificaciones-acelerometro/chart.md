# Diagramas — Calificaciones y acelerómetro con consentimiento

> Spec: `spec.md` · Plan: `plan.md`. Diagramas Mermaid; no representan recursos desplegados.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Usuario] --> B{¿Consentimiento?}
  B -->|no| C[No capturar]
  B -->|sí| D[Capturar lotes]
  D --> E[Anonimizar]
  E --> F[API]
  F --> G[ML]
```

## 2. Relación entre componentes

```mermaid
flowchart LR
  F[Flutter] --> API[API]
  API --> ML[ML]
  F --> S[Almacén seguro]
```

## 3. Flujo de datos / secuencia

```mermaid
sequenceDiagram
  participant U as Usuario
  participant F as Flutter
  participant A as API
  participant M as ML
  U->>F: acepta consentimiento
  F->>F: captura + anonimiza
  F->>A: lote
  A->>M: clasificar
  M-->>A: paradas
  A-->>F: resultado
```

## 4. Notas

No hay captura implementada; el consentimiento es requisito previo.
