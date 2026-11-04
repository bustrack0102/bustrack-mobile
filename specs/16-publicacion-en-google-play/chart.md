# Diagramas — 16-publicacion-en-google-play — Publicación en Google Play

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[App lista] --> B[Firma]
  B --> C[Ficha + privacidad]
  C --> D[Revisión]
  D --> E[Publicación]
```

## 2. Componentes

```mermaid
flowchart LR
  C[Cliente] --> A[Servicio]
  A --> D[(Datos)]
```

## 3. Secuencia

```mermaid
sequenceDiagram
  participant D as Dev
  participant C as CI
  D->>C: push
  C-->>D: lint + pruebas
```

## 4. Notas

No hay publicación en Google Play.
