# Diagramas — 01-configuracion-inicial-del-proyecto — Configuración inicial del proyecto

> Spec: `spec.md` · Plan: `plan.md`.

## 1. Flujo funcional

```mermaid
flowchart TD
  A[Kotlin actual] --> B[Documentar]
  B --> C[Definir Flutter objetivo]
  C --> D[Comandos]
  D --> E[Verificar]
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
