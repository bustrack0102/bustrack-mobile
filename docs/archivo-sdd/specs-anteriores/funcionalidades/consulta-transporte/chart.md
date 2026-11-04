# Diagramas — Consulta de transporte, mapa y alternativas

> Spec: `spec.md` · Plan: `plan.md`. Diagramas Mermaid; no representan recursos desplegados.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Buscar destino] --> B[Listar rutas]
  B --> C[Detalle: paradas/horarios/tarifas]
  C --> D[Ver en mapa]
  B --> E[Comparar alternativas]
```

## 2. Relación entre componentes

```mermaid
flowchart LR
  U[UI] --> Repo[Repositorio]
  Repo --> API[API]
  API --> DB[(Cosmos)]
```

## 3. Flujo de datos / secuencia

```mermaid
sequenceDiagram
  participant U as Usuario
  participant F as Flutter
  participant A as API
  U->>F: busca destino
  F->>A: GET /rutas
  A-->>F: rutas
  F->>A: GET /rutas/{id}
  A-->>F: detalle
  F-->>U: mapa + horarios + tarifas
```

## 4. Notas

Los endpoints de dominio son propuestos; solo login/logout existen.
