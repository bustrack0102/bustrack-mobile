# Diagramas — 05-gestion-de-sesiones — Gestión de sesiones

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Arranque] --> B{¿Sesión válida?}
  B -->|sí| C[Home]
  B -->|no| D[Login]
  C --> E[Logout]
  E --> F[Limpiar sesión]
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
