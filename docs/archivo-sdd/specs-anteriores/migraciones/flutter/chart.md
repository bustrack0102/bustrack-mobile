# Diagramas — Migración Kotlin/Compose → Flutter + Dart

> Spec: `spec.md` · Plan: `plan.md`. Diagramas Mermaid; no representan recursos desplegados.

## 1. Flujo funcional

```mermaid
flowchart TD
  K[Kotlin actual] --> I[Inventario]
  I --> A[Arquitectura Flutter]
  A --> M[Migración por flujos]
  M --> P[Pruebas de paridad]
  P -->|ok| F[Flutter]
  K -.->|referencia| M
```

## 2. Relación entre componentes

```mermaid
flowchart LR
  F[Flutter] --> API[API]
  K[Kotlin legacy] -.->|referencia| F
```

## 3. Flujo de datos / secuencia

```mermaid
sequenceDiagram
  participant U as Usuario
  participant F as Flutter
  participant A as API
  U->>F: login
  F->>A: POST /auth/login
  A-->>F: token + expiración
  F->>F: guardar seguro
  F-->>U: home
```

## 4. Notas

Flutter es objetivo, no estado actual.
