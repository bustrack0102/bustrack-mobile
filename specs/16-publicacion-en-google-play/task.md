# Tareas — 16-publicacion-en-google-play — Publicación en Google Play

> Spec: `spec.md` · Plan: `plan.md` · Estado: Parcial.
> Marcar solo con evidencia. No marcar por documentar.

## Dependencias

1. T01 antes de T02
2. T02 antes de T03

## Actividades

### [x] T01. Preparar firma y build

- Keystore.
- Ofuscación.
- Versionado.

**Archivos:** `android/app/build.gradle.kts`, `.github/workflows/build-aab.yml`, `docs/android-release-signing.md`

**Evidencia:** firma Release con Upload Key (`upload-keystore.jks`), GitHub Secrets (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`, `ANDROID_KEY_ALIAS`), workflow `build-aab.yml`, verificación criptográfica `jarsigner` y de huella SHA-256, e icono oficial de aplicación configurado en todas las densidades mipmap.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T02. Preparar ficha y privacidad

- Textos.
- Capturas.
- Política.

**Archivos:** `docs/guia-prueba-interna-playstore.md`, `docs/configuracion-global-diseno-seguridad-playstore.md`

**Evidencia:** guía con URL de privacidad, Data Safety, eliminación de cuenta y requisitos de ficha. Textos finales, capturas y publicación de la política quedan pendientes.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [x] T03. Definir checklist de publicación

- Requisitos.
- Revisión.

**Archivos:** `docs/guia-prueba-interna-playstore.md`, `docs/configuracion-global-diseno-seguridad-playstore.md`, `docs/asvs-l2-checklist.md`

**Evidencia:** checklist de prueba interna, requisitos de Play Console y controles de seguridad documentados.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

## Cierre

- [ ] Todas las tareas con evidencia.
- [x] `Memoria.md` actualizado.
- [x] Pruebas y gates ejecutados (`flutter analyze` y `flutter test`: 26 pruebas).
- [x] Sin afirmaciones de implementación no verificadas.
