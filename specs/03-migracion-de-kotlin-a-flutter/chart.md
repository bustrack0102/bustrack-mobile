# Diagramas — 03-migracion-de-kotlin-a-flutter — Migración de Kotlin/Compose a Flutter

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  K[Kotlin] --> I[Inventario]
  I --> F[Flutter]
  F --> P[Paridad]
  P -->|ok| C[Cierre]
  K -.referencia.-> F
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

Diagramas de proceso; no representan recursos desplegados.
