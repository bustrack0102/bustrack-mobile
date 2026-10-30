# BusTrack · Mobile — Spec-Driven Mobile Application

> Aplicación Móvil para Consulta de Rutas y Transporte — **Universidad Tecnológica de Tula-Tepeji**
> Desarrollado con **Spec-Driven Development (SDD)** y asegurado bajo prácticas de **DevSecOps** desde el día uno.

---

## 👥 Equipo de Desarrollo (BusTrack)
* **Fátima Ximena García González**
* **Diego Parra Cruz**
* **José De Jesús López Islas**
* **Melanie Joliee Bonilla Domínguez**

---

## 📋 Resumen del Repositorio
Este repositorio contiene la **aplicación móvil** de BusTrack. Permite a los usuarios consultar rutas de transporte, ubicar paradas en el mapa, revisar horarios y tarifas vigentes, calificar el servicio y, con autorización explícita del usuario, registrar datos del sensor acelerómetro para enriquecer los modelos de análisis y detección de paradas.

* **Metodología:** Spec-Driven Development (SDD) con especificaciones en `/specs`.
* **Seguridad y DevSecOps:** Manejo seguro de tokens JWT, almacenamiento local seguro, validación de contenido inapropiado antes de subir a la nube, análisis estático y pruebas continuas.
* **Integración:** Consume la API central de BusTrack (`bustrack-api`).

---

## 🏛️ Componentes de Gobernanza y SDD

| Componente | Ruta | Propósito |
|---|---|---|
| **Constitución (Fuente de verdad)** | `.specify/memory/constitution.md` (espejo en `./constitution.md`) | Principios no negociables del proyecto móvil y lineamientos de arquitectura |
| **Manual operativo para Agentes** | `AGENTS.md` | Guía de trabajo, contratos de interfaz y lineamientos para agentes de IA |
| **Especificaciones (Specs)** | `specs/` | Historias de usuario y entregables desglosados (`FT-00`, `FT-01`, etc.) con sus archivos `spec.md`, `plan.md`, `tasks.md` |
| **Plantillas SDD** | `.specify/templates/` (y `specs/_template.md`) | Plantillas oficiales para nuevas especificaciones y planes de trabajo |
| **Agentes y Habilidades IA** | `.opencode/agents/` y `.opencode/skills/` | Configuración de agentes OpenCode / WARP |
| **Checklist de PR** | `CHECKLIST_PR.md` | Lista de comprobación obligatoria para calidad y seguridad antes de cada Pull Request |
| **Memoria técnica** | `Memoria.md` | Historial de decisiones de arquitectura, estados y lecciones aprendidas |
| **Documentación Viva** | `docs/` | Contratos internos, políticas de rate limiting y checklist de seguridad móvil |

---

## 🧪 Pruebas y Calidad DevSecOps
* Pruebas Unitarias de casos de uso y lógica de negocio.
* Pruebas de UI y componentes visuales.
* Validación estática de código (SAST, Linters y reglas de seguridad).
* CI automatizado en `.github/workflows/`.
