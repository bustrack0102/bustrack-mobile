# Diagramas — 04-autenticacion — Autenticación en la aplicación

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Formulario] --> B[Validar]
  B -->|inválido| C[Error local]
  B -->|válido| D[POST login]
  D -->|200| E[Sesión]
  D -->|401/429| F[Error]
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
