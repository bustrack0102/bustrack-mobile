---
version: 1.0.0
ratified: 2026-10-29
last_amended: 2026-10-29
status: active
source_of_truth: .specify/memory/constitution.md
mirror: ./constitution.md
methodology: SDD
project: BusTrack - Mobile
team:
  - Fátima Ximena García González
  - Diego Parra Cruz
  - José De Jesús López Islas
  - Melanie Joliee Bonilla Domínguez
institution: Universidad Tecnológica de Tula-Tepeji
---

# Constitución — BusTrack Mobile

> Rector SDD. Ante conflicto con otro artefacto, **manda esta constitución**.
> Filosofía madre: cada funcionalidad móvil sale liberable con sus pruebas y gates aplicados.

## 1. Propósito y alcance

- Aplicación móvil de BusTrack para la consulta y visualización de rutas, paradas, horarios, tarifas y calificaciones.
- Metodología SDD (Spec-Driven Development). Toda funcionalidad nace de una especificación en `/specs` (`FT-00…FT-0X`).
- Consumo de API REST centralizada y versionada (`bustrack-api`).
- Captura autorizada de datos de acelerómetro (sin GPS invasivo ni seguimiento en tiempo real de vehículos o usuarios).

## 2. Principios no negociables

1. **Seguridad y Privacidad primero**:
   - Almacenamiento seguro de tokens JWT.
   - Sesión viva persistente salvo si el usuario realiza logout explícito.
   - Opción clara de "Eliminar cuenta" en la aplicación móvil.
   - Consentimiento informado para la captura de sensores (acelerómetro).
2. **Consumo dinámico de datos**:
   - No almacenar rutas ni datos oficiales de forma estática (hardcodeados) en la app. Toda la información proviene de la API.
   - Soporte para caché local y sincronización si se requiere operación offline (ej. SQLite / local store).
3. **Validación de contenido**:
   - Evaluación previa mediante APIs en la nube de texto e imágenes antes de permitir su publicación en reseñas u opiniones.
4. **Notificaciones Push**:
   - Configuración de notificaciones para los eventos y procesos principales de la app.
5. **Fail-fast y manejo de errores**:
   - Manejo predecible de errores de red y conexión sin cierres inesperados de la aplicación.
6. **Registro continuo**:
   - Toda decisión técnica, límite y evolución se documenta en `Memoria.md`.

## 3. Gobernanza SDD y Calidad

- Cada cambio o Pull Request debe superar el `CHECKLIST_PR.md`.
- Verificación de políticas de seguridad ASVS L2 adaptadas a móvil en `docs/asvs-l2-checklist.md`.
- CI configurado en `.github/workflows/` para análisis y pruebas antes de la integración.
