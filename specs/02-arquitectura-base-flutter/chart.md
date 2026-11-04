# Diagramas — 02-arquitectura-base-flutter — Arquitectura base Flutter

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  UI[Presentación] --> DOM[Dominio]
  UI --> DATA[Datos]
  DATA --> API[API]
  UI --> NAV[Navegación]
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
