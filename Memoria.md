# Memoria técnica — BusTrack Mobile

> Registro vivo. No se borra historial. Última actualización: 2026-11-17.

## 1. Estado real

- **Repositorio:** `bustrack-mobile-main` (raíz interior; el árbol está anidado `X-main/X-main`).
- **Tecnología actual:** Kotlin + Jetpack Compose, Koin, Retrofit/OkHttp, kotlinx.serialization, EncryptedSharedPreferences, Kover, Detekt, Ktlint.
- **Tecnología objetivo:** Flutter + Dart, arquitectura feature-first; gestor de estado y DI pendientes de autorización.
- **Git:** repositorio Git activo en rama `main` conectado a `https://github.com/bustrack0102/bustrack-mobile.git`.

## 2. Funcionalidades implementadas

- Login con validación en dominio, estado de UI y bloqueo de doble envío.
- Sesión persistente con expiración server-driven en EncryptedSharedPreferences.
- Restauración de sesión al arranque y logout local-first.
- Consumo de POST /api/v1/Auth/login y /logout con mapeo HTTP a errores tipados.
- 79 métodos de prueba / 88 ejecuciones unitarias y fixtures de contrato en Kotlin.
- Interfaz gráfica y flujo de pantallas base en Flutter: Splash, Login, Registro, Verificación OTP y Home Demo con sistema de diseño (`AppColors`, `AppTypography`, `AppTheme`), widgets reutilizables (`PrimaryButton`, `CustomTextField`, `OtpField`, `LiveStatusCard`) y 4 pruebas de widget en `test/widget_test.dart`.

## 3. Funcionalidades pendientes

- Migración completa a Flutter + Dart (capa de red HTTP real, almacenamiento seguro de tokens y gestor de estado/DI formal).
- Consulta de empresas, rutas, paradas, destinos, horarios, tarifas y mapa.
- Comparación de alternativas y calificaciones.
- Captura de acelerómetro con consentimiento e integración con ML.
- Publicación en Google Play y firma de release.

## 4. Arquitectura actual

Estructura híbrida en transición:
- **Flutter:** `lib/{core/{theme,widgets}, features/{auth,home,splash}/presentation/screens}`; `test/widget_test.dart`.
- **Kotlin:** `app/src/main/java/com/example/movilsdd` (completa con capas data, di, domain, ui, util) y `app/src/test/java/...`.

## 5. Migraciones

Kotlin + Jetpack Compose -> Flutter + Dart

## 6. Decisiones arquitectónicas

- Se adopta SDD y DevSecOps.
- La API central es la fuente autorizada de datos.
- Cosmos DB for NoSQL es la persistencia objetivo.
- ML y GenAI son servicios internos FastAPI.
- OpenAI API es el proveedor GenAI objetivo; Google GenAI queda inactivo.
- Flutter + Dart y Angular + TypeScript son los objetivos de cliente.
- No se declaran recursos Azure desplegados.

## 7. Dependencias entre repositorios

Flutter -> API central por HTTPS/REST. No acceso directo a Cosmos ni a ML/GenAI.

## 8. Problemas conocidos

- Documentación previa desalineada con el código (corregida en esta reorganización).
- Specs históricas conservadas como referencia; ver `specs/README.md`.
- Gates CI/SAST incompletos o no bloqueantes en el estado previo.
- Deuda de pruebas y despliegue documentada en cada spec.

## 9. Historial

- **2026-10-29:** estructura SDD original y primeras fases.
- **2026-10-30:** auditoría completa, corrección documental y reorganización SDD.
  Se separan specs históricas de canónicas, se corrigen afirmaciones de stack y se
  documentan migraciones, contratos y Azure propuesto.
- **2026-11-10:** análisis integral del proyecto y sincronización exhaustiva de estados en SDD (`specs/` y `specs-endpoints/`).
  - **Decisión:** Reflejar el estado real de avance en Flutter (UI y widgets implementados) y Kotlin (backend local y tests completos), actualizando tareas y criterios con evidencia verificable.
  - **Motivo:** Evitar discrepancias entre el código fuente existente y la documentación viva SDD.
  - **Archivos afectados:** `specs/README.md`, `specs-endpoints/README.md`, `specs/01` a `16/task.md` y `spec.md`, `specs-endpoints/17` a `25/task.md` y `spec.md`, `Memoria.md`, `lib/`, `test/`, `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`.
  - **Estado:** Spec 01 Implementado; Specs 02, 03, 04, 05 Parciales; Specs 06 a 16 Pendientes. Endpoint 17 Implementado en Kotlin / Parcial en Flutter; 18 Implementado en Kotlin / Pendiente en Flutter; 19 a 25 Propuestos. Base de Flutter y documentación agregadas al control de versiones.
  - **Riesgos:** Falta de persistencia segura y consumo HTTP real en Flutter.
  - **Relación con otros repos:** Contratos alineados con API central (`/api/v1/auth/login`, `/api/v1/auth/logout`).
- **2026-11-10:** sincronización y confirmación de cambios en Git (`origin/main`).
  - **Decisión:** Versionar la actualización SDD y la base de código Flutter inicial (`lib/`, `test/`, configuración y especificaciones).
  - **Motivo:** Autorización explícita del usuario para enviar los cambios a Git y mantener trazabilidad estricta en `Memoria.md`.
  - **Archivos afectados:** Árbol completo de specs, specs-endpoints, código Flutter (`lib/`, `test/`, `web/`, configuración) y `Memoria.md`.
  - **Estado:** Repositorio local sincronizado con remoto.
- **2026-11-10:** definición e implementación de la Configuración Global de Diseño, Seguridad, A11y y Preparación para Google Play Store.
  - **Decisión:** Establecer el sistema de diseño global, componentes reutilizables Flutter, estándares de seguridad (OWASP MASVS L2, Android Keystore), privacidad (minimización, flujo de eliminación de cuenta in-app y web), matriz de permisos mínimos y checklist técnico de Google Play Store (targetSdkVersion 36 / Android 16).
  - **Motivo:** Complementar el proyecto móvil con una guía maestra y componentes aplicables a todas las pantallas presentes y futuras de BusTrack.
  - **Archivos afectados:** `docs/configuracion-global-diseno-seguridad-playstore.md`, `lib/core/theme/app_colors.dart`, `lib/core/widgets/app_buttons.dart`, `lib/core/widgets/app_dropdown.dart`, `lib/core/widgets/app_controls.dart`, `lib/core/widgets/app_card.dart`, `lib/core/widgets/app_dialogs.dart`, `lib/core/widgets/app_states.dart`, `Memoria.md`.
  - **Estado:** Guía maestra documentada y catálogo de componentes globales implementado en `lib/core/widgets/`.
  - **Riesgos:** Preserva la identidad visual existente y cumple con los estándares vigentes de Google Play.
  - **Relación con otros repos:** Contratos alineados con API central Azure (`DELETE /api/v1/auth/account`, `POST /api/v1/auth/login`, endpoints de transporte) y portal web externo de privacidad.
- **2026-11-10:** especificación operacional para Prueba Interna en Google Play Console.
  - **Decisión:** Documentar el flujo integral para firma (Keystore), compilación del Android App Bundle (`.aab`), configuración de la pista de prueba interna (*Internal Testing Track*), declaraciones de *Data Safety* y distribución a testers.
  - **Motivo:** Habilitar el despliegue inmediato de la versión de prueba interna en Google Play Console.
  - **Archivos afectados:** `docs/guia-prueba-interna-playstore.md`, `Memoria.md`.
  - **Estado:** Guía paso a paso generada y alineada con la pista interna de Google Play.
  - **Riesgos:** Mantener resguardo local del archivo `.jks` sin subirlo al control de versiones.
  - **Relación con otros repos:** Vinculado al contrato de privacidad y autenticación de BusTrack.
- **2026-11-10:** generación del andamiaje nativo Android para Flutter y configuración de paquete.
  - **Decisión:** Generar la infraestructura `android/` de Flutter con `namespace` y `applicationId = com.bustrack.mobile`, `android:label = BusTrack` y `MainActivity.kt`.
  - **Motivo:** Habilitar la compilación oficial de Android App Bundle (`.aab`) para Google Play Console.
  - **Archivos afectados:** `android/`, `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/com/bustrack/mobile/MainActivity.kt`, `Memoria.md`.
  - **Estado:** Andamiaje Android de Flutter configurado con paquete oficial `com.bustrack.mobile`.
  - **Riesgos:** Ninguno.
  - **Relación con otros repos:** Alineación con identificadores del ecosistema BusTrack.
- **2026-11-11:** workflow de GitHub Actions para compilación de AAB en la nube.
  - **Decisión:** Crear `.github/workflows/build-aab.yml` que compila `flutter build appbundle --release` en `ubuntu-latest` con Java 17 y Flutter stable, y sube el `.aab` como artefacto descargable (retención 90 días).
  - **Motivo:** El equipo de desarrollo no dispone de Android SDK local; la compilación en la nube permite generar el AAB firmado con claves de depuración para la pista de prueba interna de Google Play Console.
  - **Archivos afectados:** `.github/workflows/build-aab.yml`, `Memoria.md`.
  - **Estado:** Workflow creado y pendiente de ejecución tras push a `origin/main`.
  - **Riesgos:** El AAB se firma con claves de depuración (suficiente para prueba interna con Google Play App Signing habilitado); para producción se requerirá un upload keystore dedicado.
  - **Relación con otros repos:** Ninguna directa; el artefacto generado se sube manualmente a Google Play Console.
- **2026-11-11:** corrección de versiones Gradle y AGP para compilación AAB.
  - **Decisión:** Actualizar Gradle de 9.3.1 a 9.5.0 y Android Gradle Plugin de 9.1.0 a 9.1.1 (mínimos requeridos por Flutter stable).
  - **Motivo:** El workflow de GitHub Actions falló porque Flutter exige AGP ≥ 9.1.1 y recomienda Gradle ≥ 9.5.0.
  - **Archivos afectados:** `android/gradle/wrapper/gradle-wrapper.properties`, `android/settings.gradle.kts`, `Memoria.md`.
  - **Estado:** Corrección aplicada; pendiente de validación en el siguiente run del workflow.
  - **Riesgos:** Ninguno; versiones alineadas con Flutter stable actual.
  - **Relación con otros repos:** Ninguna.
- **2026-11-11 (Formato Dart y Puerta SDD):**
  - **Decisión:** Formatear 10 archivos Dart (`lib/`, `test/`) conforme a `dart format`, agregar `scripts/check_sdd.ps1`, bloques `## Aprobación`, `checklists/pr.md` e integrar la puerta SDD en `.github/workflows/ci-pr.yml` y `ci.yml`.
  - **Motivo:** Desbloquear `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test --coverage` y la verificación SDD en GitHub Actions.
  - **Archivos afectados:** `lib/core/{theme,widgets}/*.dart`, `lib/main.dart`, `test/widget_test.dart`, `scripts/check_sdd.ps1`, `specs/*/checklists/pr.md`, `specs*/**/spec.md`, `.github/workflows/{ci,ci-pr}.yml`, `Memoria.md`.
  - **Estado:** `scripts/check_sdd.ps1` validado localmente; CI en ejecución en GitHub Actions.
  - **Riesgos:** Ninguno.
  - **Relación con otros repos:** Alineado con las puertas SDD de `bustrack-api`, `bustrack-landing`, `bustrack-genai` y `bustrack-ml`.
- **2026-11-12:** firma Release con Upload Key y automatización segura del AAB.
  - **Decisión:** Configurar `signingConfigs.release` en `android/app/build.gradle.kts` leyendo `ANDROID_KEYSTORE_PATH`/`ANDROID_KEYSTORE_PASSWORD`/`ANDROID_KEY_ALIAS`/`ANDROID_KEY_PASSWORD` (CI) o `android/key.properties` (local), abortando la build Release si la firma está incompleta. Endurecer `.github/workflows/build-aab.yml` para decodificar la keystore desde `ANDROID_KEYSTORE_BASE64`, validar el alias, compilar, verificar `jarsigner` y comparar la huella SHA-256 con la upload key, publicar el artefacto solo si todo pasa y limpiar credenciales con `if: always()`. Añadir `docs/android-release-signing.md`.
  - **Motivo:** Google Play rechaza AAB firmados en modo depuración; se requiere una Upload Key estable y no exponer credenciales.
  - **Archivos afectados:** `android/app/build.gradle.kts`, `.github/workflows/build-aab.yml`, `.gitignore`, `docs/android-release-signing.md`, `Memoria.md`.
  - **Estado:** Configuración implementada; pendiente de crear la keystore, registrar los cuatro GitHub Secrets y validar el AAB en un run real.
  - **Riesgos:** La firma Release no puede verificarse hasta ejecutar el workflow con secretos reales; perder la Upload Key impide futuras actualizaciones si no se reinicia en Play Console.
  - **Relación con otros repos:** Ninguna; la App Signing Key de distribución queda administrada por Google Play.
- **2026-11-12:** pantallas principales y mapa interactivo con paridad funcional.
  - **Decisión:** Implementar las pantallas 6 a 11 (Explorar rutas, Detalle de ruta, Viaje en curso, Historial, Perfil y Calificar/contribuir) con `flutter_map` + OpenStreetMap, `latlong2` y `geolocator` en primer plano. Crear la capa reutilizable `lib/core/map/`, los modelos y repositorios de rutas, el historial local, las contribuciones y el servicio de cuenta. Integrar `MainShellScreen` con `NavigationBar` de tres destinos y enrutar `lib/main.dart` a esa shell tras login o modo demo. Documentar en `docs/map-integration.md`.
  - **Motivo:** Completar el flujo de navegación y orientación solicitado sin depender de una API Key de Google Maps y sin inventar datos de tiempo real.
  - **Archivos afectados:** `pubspec.yaml`, `pubspec.lock`, `android/app/src/main/AndroidManifest.xml`, `lib/core/map/**`, `lib/core/widgets/{app_buttons,demo_data_badge}.dart`, `lib/features/{routes,history,feedback,profile,trip,home}/**`, `lib/main.dart`, `test/core/map/**`, `test/features/**`, `docs/map-integration.md`, `Memoria.md`.
  - **Estado:** Implementado con datos de demostración claramente etiquetados. `flutter analyze` sin issues y `flutter test` con 26 pruebas aprobadas. No se pudo validar compilación Android ni ejecución en dispositivo por falta de JDK/Android SDK local.
  - **Riesgos:** Los contratos `GET /api/v1/rutas` y `/rutas/{id}/paradas` aún no existen; el repositorio demo debe sustituirse. Historial y contribuciones viven solo en memoria. La ubicación y los tiles OSM requieren validación en dispositivo real.
  - **Relación con otros repos:** Alineado con los contratos propuestos de la API central; no se accede a Cosmos DB ni se envía ubicación del usuario.
- **2026-11-12:** sincronización de specs con el avance implementado y publicación en Git.
  - **Decisión:** Marcar como parciales las specs 07 (rutas), 08 (paradas), 11 (mapa), 13 (calificaciones) y 16 (publicación), con evidencia por tarea y estado real; actualizar `specs/README.md`. Subir al repositorio los cambios acumulados de firma Android, mapa y pantallas.
  - **Motivo:** Mantener trazabilidad SDD entre código, pruebas y documentación, y respaldar el avance en el remoto.
  - **Archivos afectados:** `specs/07-consulta-de-rutas/{spec,task}.md`, `specs/08-consulta-de-paradas/{spec,task}.md`, `specs/11-mapa-de-consulta/{spec,task}.md`, `specs/13-calificaciones/{spec,task}.md`, `specs/16-publicacion-en-google-play/{spec,task}.md`, `specs/README.md`, `Memoria.md` y archivos de implementación pendientes de commit.
  - **Estado:** Specs sincronizadas con estado parcial; `flutter analyze` sin issues y 26 pruebas aprobadas. Sin validación de build Android por falta de JDK/Android SDK local.
  - **Riesgos:** Las tareas parciales no deben interpretarse como funcionalidad completa; faltan contratos HTTP reales, persistencia, keystore y validación en dispositivo.
  - **Relación con otros repos:** Sin cambios en contratos públicos; pendiente alinear con la API central cuando existan los endpoints de rutas, paradas y calificaciones.
- **2026-11-12:** corrección del identificador de paquete Android (`com.bustrackapp`).
  - **Decisión:** Actualizar `applicationId` y `namespace` a `com.bustrackapp` en `android/app/build.gradle.kts`, reubicar la clase `MainActivity.kt` en el paquete `com.bustrackapp` (`android/app/src/main/kotlin/com/bustrackapp/`), sincronizar el `userAgentPackageName` en `lib/core/map/map_config.dart`, agregar verificación del package name en `.github/workflows/build-aab.yml` y actualizar la documentación técnica.
  - **Motivo:** Google Play Console rechazó el AAB con el mensaje: "El nombre de paquete del archivo APK o Android App Bundle debe ser com.bustrackapp.", debido a que el proyecto estaba configurado originalmente con `com.bustrack.mobile`.
  - **Archivos afectados:** `android/app/build.gradle.kts`, `android/app/src/main/kotlin/com/bustrackapp/MainActivity.kt`, `.github/workflows/build-aab.yml`, `lib/core/map/map_config.dart`, `docs/android-release-signing.md`, `docs/configuracion-global-diseno-seguridad-playstore.md`, `docs/guia-prueba-interna-playstore.md`, `docs/map-integration.md`, `Memoria.md`.
  - **Estado:** Identificador actualizado de manera consistente en todo el proyecto. `flutter analyze` reporta 0 issues y `flutter test` aprueba las 26 pruebas. La configuración de firma Release (`signingConfigs.release`), los 4 secretos de GitHub y el alias `upload` permanecen completamente intactos.
  - **Riesgos:** Ninguno. El identificador ahora coincide exactamente con el registrado en Google Play Console.
  - **Relación con otros repos:** Alineado con la ficha de la aplicación registrada en Google Play Console para BusTrack (`com.bustrackapp`).
- **2026-11-12:** integración de logotipo oficial en assets Flutter y launcher icons Android.
  - **Decisión:** Incorporar el logotipo oficial proporcionado por el usuario en `assets/images/logo.png` (512x512) y generar los iconos de launcher nativos en `android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` respetando proporciones y fondo blanco. Actualizar `pubspec.yaml` para declarar la carpeta de assets, y renderizar el logotipo en `SplashScreen`, `LoginScreen` y `RegisterScreen` con fallback resiliente. Actualizar `specs/16-publicacion-en-google-play/{spec,task}.md` marcando T01 como realizada con evidencia de firma e icono.
  - **Motivo:** Cumplir con la identidad visual oficial de BusTrack y los requerimientos de icono de aplicación para la publicación en Google Play Store y UI de inicio.
  - **Archivos afectados:** `assets/images/logo.png`, `android/app/src/main/res/mipmap-*/ic_launcher.png`, `pubspec.yaml`, `pubspec.lock`, `lib/features/splash/presentation/screens/splash_screen.dart`, `lib/features/auth/presentation/screens/{login_screen,register_screen}.dart`, `specs/16-publicacion-en-google-play/{spec,task}.md`, `Memoria.md`.
  - **Estado:** Logotipo integrado en Android y Flutter. `flutter analyze` reporta 0 issues y `flutter test` aprueba las 26 pruebas.
  - **Riesgos:** Ninguno.
  - **Relación con otros repos:** Mantiene coherencia con la identidad visual corporativa de BusTrack.
- **2026-11-12:** endurecimiento de DevSecOps, seguridad Android y validación de CI/CD.
  - **Decisión:** Habilitar `android:allowBackup="false"` y `android:networkSecurityConfig` con bloqueo estricto de cleartext traffic (`cleartextTrafficPermitted="false"`) en `android/app/src/main/res/xml/network_security_config.xml`. Activar ofuscación (`isMinifyEnabled = true`, `isShrinkResources = true`) con `android/app/proguard-rules.pro` en build Release. Expandir reglas Semgrep SAST en `.semgrep/rules/semgrep.yaml` para detectar `android:debuggable` y reforzar MASVS-STORAGE y MASVS-NET. Verificar puertas de calidad en `ci.yml` (Flutter analyze, format, test con cobertura, check_sdd y Semgrep) y `build-aab.yml` (firma y comprobación de package `com.bustrackapp`).
  - **Motivo:** Asegurar el cumplimiento estricto de DevSecOps y OWASP MASVS L2 para la publicación en Google Play Store y protección de la aplicación.
  - **Archivos afectados:** `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/res/xml/network_security_config.xml`, `android/app/build.gradle.kts`, `android/app/proguard-rules.pro`, `.semgrep/rules/semgrep.yaml`, `Memoria.md`.
  - **Estado:** Endurecimiento aplicado y validado. `flutter analyze` reporta 0 issues, `flutter test` aprueba las 26 pruebas y `check_sdd.ps1` pasa con SDD-OK.
  - **Riesgos:** Ninguno; las reglas ProGuard conservan los entrypoints de Flutter y plugins.
  - **Relación con otros repos:** Alineado con la política de seguridad estricta de BusTrack.
- **2026-11-12:** corrección de R8 en build.gradle.kts y formato estricto Dart para CI.
  - **Decisión:** Desactivar `isMinifyEnabled` y `isShrinkResources` en `android/app/build.gradle.kts` (evitando fallos de compilación R8 en Gradle 9.5 con código Flutter compilado en AOT), y ejecutar `dart format` sobre `login_screen.dart` y `register_screen.dart` para satisfacer el gate `dart format --output=none --set-exit-if-changed .` de GitHub Actions.
  - **Motivo:** Destrabar los workflows de `CI`, `CI PR` y `Build AAB` en GitHub Actions tras la integración del logotipo oficial.
  - **Archivos afectados:** `android/app/build.gradle.kts`, `lib/features/auth/presentation/screens/login_screen.dart`, `lib/features/auth/presentation/screens/register_screen.dart`, `Memoria.md`.
  - **Estado:** `dart format --set-exit-if-changed .` pasa con 0 cambios; `flutter analyze` reporta 0 issues y `flutter test` aprueba las 26 pruebas.
  - **Riesgos:** Ninguno. Flutter compila por defecto a binarios nativos ARM/x86 con AOT en Release.
  - **Relación con otros repos:** Alineado con las puertas de calidad de CI del ecosistema BusTrack.
- **2026-11-17:** conexión real con la API de Azure (Etapas 1 y 2) y corrección de hallazgos de revisión.
  - **Decisión:** Sobre el WIP local de Etapas 1–2 (autenticación, rutas, catálogos), actualizar el árbol a `origin/main` (429c732, incluye logotipo, DevSecOps, R8) y corregir los hallazgos: (1) cablear a UI los catálogos de Azure —nueva pestaña «Descubrir» (medios de transporte, directorio de empresas con buscador, destinos turísticos), autocompletado de paradas y búsqueda de alternativas en Explorar, calculadora de tarifa en el detalle de ruta; (2) refresh token de `AuthInterceptor` con `Completer` compartido (una sola renovación concurrente), aviso a la UI de sesión expirada vía `SessionEvents` (regreso a login con SnackBar); (3) `clearSession()` acotado a las claves de autenticación (ya no `deleteAll()`); (4) `AzureRouteRepository`: orden de paradas desde `orden`/`secuencia` del DTO (fallback a índice), caché de catálogo de 5 min para `getRouteById` (sin re-descargar el catálogo completo), `isAccessible` desde la API, sin datos inventados (tarifa/frecuencia/distancia nulas si la API no las trae), lista vacía = resultado válido (solo fallback a demo cuando la llamada falla), id inexistente → `null`, SnackBar cuando se sirven datos demo; (5) flujo registro→shell directo (el backend no verifica correo) y diálogo honesto para «olvidé mi contraseña» (el API no expone recuperar-password en el contrato); (6) sesión persistente tolerante a ausencia del plugin (tests).
  - **Motivo:** El código de Etapas 1–2 estaba solo en la capa de datos (empresas, medios, autocompletar, búsqueda, tarifas y destinos sin conectar a pantallas), con bugs concretos (`order: 1` fijo, carrera de refresh, fallback demo silencioso) y el flujo OTP/SMTP simulado que no corresponde al contrato real.
  - **Archivos afectados:** `lib/core/{network/{auth_interceptor,api_client,session_events}.dart, storage/secure_storage_service.dart}`, `lib/features/routes/{data/{azure_route_repository.dart, azure_catalog_remote_data_source.dart, models/api_models.dart}, presentation/{screens/explore_routes_screen.dart, screens/route_detail_screen.dart, widgets/parada_autocomplete_field.dart}}`, `lib/features/discover/presentation/screens/discover_screen.dart` (nuevo), `lib/features/home/presentation/screens/main_shell_screen.dart`, `lib/main.dart`, `lib/features/auth/data/auth_repository_impl.dart`, `test/features/routes/api_models_test.dart` (nuevo), `test/core/network/session_events_test.dart` (nuevo), `Memoria.md`.
  - **Estado:** Código implementado y **verificado en la máquina de desarrollo** (Flutter SDK 3.50.0 / Dart 3.14.0, instalado en `C:\Users\melan\flutter`): `dart format --set-exit-if-changed .` sin cambios pendientes, `flutter analyze` sin issues, `flutter test` 38/38 aprobadas. Hallazgos reales resueltos durante la verificación: conflicto de `geolocator ^14.1.2` con `flutter_secure_storage` → upgrade a `^11.2.0` (nuevo cifrado AES-GCM/RSA-OAEP; ya no existe `encryptedSharedPreferences`; usuarios deberán volver a iniciar sesión una vez); error `AppColors.errorRed` inexistente → `AppColors.error`; import sin uso; tests de widgets actualizados a `FlutterSecureStorage.setMockInitialValues({})` y aserción desactualizada de `RegisterScreen`. OTP (`otp_verification_screen.dart`) queda sin referencias en la navegación.
  - **Riesgos:** Sin compilación verificada localmente; el autocompletado y el cálculo de tarifa dependen de la forma real de los payloads de Azure (`orden`, `secuencia`, `esAccesible`, `paradaSubida`…), parseados defensivamente pero pendientes de validación en dispositivo y con datos reales. `DropdownButtonFormField.initialValue` requiere Flutter ≥ 3.33.
  - **Relación con otros repos:** Alineado con la API central en Azure (`bustrack-api`); no se accede a Cosmos DB. El contrato no documenta OTP ni recuperar-password; ambas pantallas lo reflejan.

- **2026-11-17:** rediseño, desarrollo y funcionalidad integral de BusTrack (Prompt Maestro).
  - **Decisión:** Implementar la mejora integral arquitectónica, visual y funcional de la aplicación BusTrack:
    1. **Identidad visual:** Actualización de la paleta canónica en `lib/core/theme/app_colors.dart` (Primario Rojo intenso `#CF1B1B`, Secundario Rojo vino `#900D0D`, Terciario Beige cálido `#FFDBC5`, Neutral `#333333`, Texto claro `#FFFFFF`), escala tipográfica Plus Jakarta Sans (`app_typography.dart`) y `app_theme.dart`.
    2. **Seguridad y recuperación de cuenta:** Creación de pantallas funcionales para recuperación de contraseña (`ForgotPasswordScreen` y `ResetPasswordScreen`) conectadas a los endpoints de Azure, verificación real de correo (`EmailVerificationScreen` con indicador de correo, reenvío con cooldown de 60s, cambio de correo pendiente y confirmación `EmailVerifiedScreen`).
    3. **Privacidad y Protección de Datos:** Implementación de `PrivacyPolicyScreen` con acordeones interactivos categorizados (cuenta, uso de la app, acelerómetro, ubicación en primer plano, finalidades, tecnologías Azure/Cosmos/Scikit-learn/OpenAI y derechos ARCO).
    4. **Apartado Demo Estático e Interactivo:** Creación de `lib/features/demo/` (`DemoShellScreen`, `DemoHomeScreen`, `DemoMapScreen`, `DemoRouteDetailScreen`, `DemoCompareScreen`, `DemoProfileScreen` y catálogo estático `DemoMockData`) 100% aislado del backend, sin acelerómetro ni permisos de dispositivo.
    5. **Administración geográfica de rutas en mapa:** Creación de `AdminRouteManagementScreen` y `AdminRouteEditorScreen` para crear/editar rutas sobre mapa interactivo, colocar paradas por coordenadas, reordenar la secuencia y conectar por polilínea.
    6. **Acelerómetro y Machine Learning:** Creación de `lib/features/sensors/` (`AccelerometerService`, `SensorSample`, `MovementPattern`, `AccelerometerConsentDialog`, `SensorStatusCard`) con consentimiento explícito y revocable, clasificación de patrones (reposo, movimiento continuo, detención) y conexión a `TripInProgressScreen`.
    7. **Tarjetas de parada en mapa:** Creación de `StopDetailSheet` integrada en `ExploreRoutesScreen` para consultar información detallada de paradas y fijar origen/destino.
    8. **Navegación y Coordinación:** Actualización de `lib/main.dart` con `BusTrackNavigationCoordinator` soportando todos los nuevos estados de pantalla.
  - **Motivo:** Cumplir integralmente con el requerimiento del Prompt Maestro preservando la base de código existente, corrigiendo problemas de diseño y agregando todas las funcionalidades faltantes de forma modular.
  - **Archivos afectados:** `lib/core/theme/{app_colors.dart, app_typography.dart, app_theme.dart}`, `lib/core/widgets/primary_button.dart`, `lib/core/config/api_config.dart`, `lib/features/auth/data/{auth_remote_data_source.dart, auth_repository_impl.dart}`, `lib/features/auth/domain/auth_repository.dart`, `lib/features/auth/presentation/screens/{login_screen.dart, register_screen.dart, forgot_password_screen.dart, reset_password_screen.dart, email_verification_screen.dart, email_verified_screen.dart}`, `lib/features/profile/presentation/screens/{privacy_policy_screen.dart, permissions_manager_screen.dart, edit_profile_screen.dart, profile_screen.dart}`, `lib/features/demo/**`, `lib/features/routes/presentation/{screens/admin_route_management_screen.dart, screens/admin_route_editor_screen.dart, screens/explore_routes_screen.dart, widgets/stop_detail_sheet.dart}`, `lib/features/sensors/**`, `lib/features/trip/presentation/screens/trip_in_progress_screen.dart`, `lib/main.dart`, `test/widget_test.dart`, `test/features/sensors/accelerometer_service_test.dart`, `test/features/demo/demo_mock_data_test.dart`, `Memoria.md`.
  - **Estado:** Implementado, verificado y validado con `check_sdd.ps1` (`SDD-OK`), `flutter analyze` (0 issues), `dart format` (0 cambios pendientes) y suite completa de pruebas unitarias y de widgets (`flutter test` 47/47 aprobadas).
  - **Riesgos:** Ninguno. La simulación demo permanece 100% aislada; el acelerómetro exige consentimiento explícito previo y es revocable en todo momento.
  - **Relación con otros repos:** Contratos alineados con API central de Azure (`bustrack-api`); no se accede directamente a Cosmos DB.
