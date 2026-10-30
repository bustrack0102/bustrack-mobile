# Memoria técnica — BusTrack Mobile

> Registro de estado, decisiones arquitectónicas con justificación, lecciones aprendidas y deuda técnica de la aplicación móvil de BusTrack.

---

## 📌 Fase FT-00 — Inicialización y Estructura SDD (2026-10-29)

- **Estado:** Estructura base Spec-Driven Development (SDD) creada a partir de las especificaciones de `MovilSDD`.
- **Decisión 1 (Metodología):** Implementación de SDD y DevSecOps. Toda funcionalidad móvil inicia con su especificación en `specs/` antes de comenzar la codificación de componentes.
- **Decisión 2 (Arquitectura de Consumo):** La aplicación móvil opera como cliente desacoplado consumiendo la API central `bustrack-api` a través de endpoints seguros y autenticación JWT.
- **Decisión 3 (Privacidad de Sensores):** El uso del sensor acelerómetro para el entrenamiento de detección de paradas requerirá consentimiento expreso y no se realizará rastreo GPS en tiempo real.
- **Deuda Técnica Documentada:** Parametrización del pipeline CI/CD hacia tienda y configuración de Firebase Cloud Messaging para notificaciones push en fases posteriores.
