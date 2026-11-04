# Diagramas — 14-captura-de-acelerometro-con-consentimiento — Captura de acelerómetro con consentimiento

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Inicio] --> B{Consentimiento}
  B -->|no| C[No capturar]
  B -->|sí| D[Capturar]
  D --> E[Anonimizar]
  E --> F[Enviar]
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
