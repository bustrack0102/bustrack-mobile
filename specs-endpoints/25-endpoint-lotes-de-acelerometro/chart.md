# Diagramas — 25-endpoint-lotes-de-acelerometro — Consumo del endpoint de lotes de acelerómetro

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo del endpoint

```mermaid
flowchart TD
  A[Lote] --> B[POST API]
  B --> C[ML]
  C --> D[Resultado]
```

## 2. Componentes

```mermaid
flowchart LR
  C[Consumidor] --> A[Servicio]
  A --> D[(Datos)]
```

## 3. Secuencia

```mermaid
sequenceDiagram
  participant C as Consumidor
  participant S as Servicio
  C->>S: POST /api/v1/sensores/lotes
  S-->>C: respuesta
```

## 4. Notas

Diagramas de proceso; no representan recursos desplegados.
