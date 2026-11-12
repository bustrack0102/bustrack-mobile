# Firma Release de Android y generación automatizada del AAB

> Documento operativo. No contiene contraseñas, keystores ni credenciales.
> Aplica a BusTrack Mobile (`com.bustrack.mobile`) sobre Flutter + Android Gradle.

## 1. Estado actual del proyecto

| Elemento | Valor |
| --- | --- |
| Flutter | stable (probado con 3.47.8) |
| Dart | 3.13.7 |
| Java | 17 (Temurin) |
| Gradle | 9.5.0 |
| Android Gradle Plugin | 9.1.1 |
| Kotlin | 2.4.0 |
| DSL Gradle | Kotlin (`build.gradle.kts`) |
| `applicationId` / `namespace` | `com.bustrack.mobile` |
| Ruta del proyecto Flutter | raíz del repositorio (`pubspec.yaml`) |
| Proyecto Android | `android/` |
| Salida del AAB | `build/app/outputs/bundle/release/app-release.aab` |

La firma Release se toma de una **Upload Key** externa al repositorio. El modo Debug
conserva la firma de depuración por defecto de Android.

## 2. Upload Key vs. Play App Signing

- **Upload Key**: clave privada con la que tú firmas el AAB antes de subirlo a Google Play.
  Debe conservarse siempre; Google la usa para autenticar que el paquete proviene de ti.
- **App Signing Key (Play App Signing)**: clave que administra Google Play y con la que se
  firma la app que reciben los dispositivos. No necesitas poseerla ni subirla.

No confundir ambas. Este repositorio solo configura la **Upload Key**. La firma de
distribución la administra Google Play.

## 3. Crear la Upload Keystore (solo una vez, local)

Requisitos: JDK 17 (`keytool` disponible) y una contraseña robusta guardada en un gestor
de secretos.

```bash
keytool -genkeypair \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storetype JKS \
  -keystore upload-keystore.jks \
  -dname "CN=BusTrack Upload, O=BusTrack, C=MX"
```

- Guarda el archivo `.jks` **fuera del repositorio** (por ejemplo, en un almacenamiento
  cifrado y con copia de respaldo).
- Usa la misma contraseña para `storepass` y `keypass` o define dos distintas; ambas se
  registran como secretos independientes.
- No vuelvas a generar la clave para actualizaciones futuras: debe ser la misma.

## 4. Codificar la keystore en Base64

Linux/macOS:

```bash
base64 -w 0 upload-keystore.jks > upload-keystore.jks.base64
```

Si tu `base64` no soporta `-w 0`:

```bash
base64 upload-keystore.jks | tr -d '\n' > upload-keystore.jks.base64
```

PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) |
  Set-Content -NoNewline "upload-keystore.jks.base64"
```

El archivo `.base64` también es un secreto: no lo subas al repositorio ni lo pegues en
issues, chats o logs.

## 5. Registrar los GitHub Secrets

En GitHub: `Settings → Secrets and variables → Actions → New repository secret`.

| Secret | Contenido |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Contenido completo del archivo `.jks` codificado en Base64 (una sola línea, sin saltos) |
| `ANDROID_KEYSTORE_PASSWORD` | Contraseña del keystore (`storepass`) |
| `ANDROID_KEY_PASSWORD` | Contraseña de la clave (`keypass`) |
| `ANDROID_KEY_ALIAS` | Alias de la clave (por ejemplo `upload`) |

El workflow `Build AAB` decodifica la keystore a `android/upload-keystore.jks`, crea
`android/key.properties` con permisos restringidos, compila y **elimina ambos archivos**
al finalizar, incluso si la compilación falla.

## 6. Ejecutar el workflow

1. Ve a `Actions → Build AAB`.
2. Pulsa `Run workflow` sobre la rama `main`.
3. También se ejecuta automáticamente en cada push a `main`.

Pasos que ejecuta:

1. `flutter doctor -v`
2. `flutter pub get`
3. `flutter analyze`
4. `flutter test`
5. Recuperación y validación de la keystore y el alias.
6. `flutter build appbundle --release`
7. Verificación de existencia del AAB.
8. `jarsigner -verify` y comparación de la huella SHA-256 del certificado del AAB con la
   de la Upload Key.
9. Publicación del artefacto.
10. Limpieza de credenciales temporales (`if: always()`).

Si falta un secret o la firma no coincide, el job falla y **no** publica el artefacto.

## 7. Descargar el AAB

1. Abre la ejecución del workflow en `Actions`.
2. En la sección `Artifacts`, descarga `app-release-aab-<número-de-ejecución>`.
3. Descomprime el artefacto: contiene `app-release.aab`.

Ruta interna generada: `build/app/outputs/bundle/release/app-release.aab`.

## 8. Comprobar la firma manualmente

```bash
jarsigner -verify -verbose -certs app-release.aab
```

Resultado esperado: `jar verified.` (puede advertir que el certificado es autofirmado,
lo cual es normal para una Upload Key).

Comparar la huella del certificado del AAB con la de la keystore:

```bash
keytool -printcert -jarfile app-release.aab
keytool -list -v -keystore upload-keystore.jks -alias upload
```

Los valores `SHA256` deben coincidir. No publiques las huellas ni capturas con datos
sensibles.

## 9. Compilación local (opcional)

Crea `android/key.properties` (ignorado por Git):

```properties
storeFile=/ruta/absoluta/a/upload-keystore.jks
storePassword=TU_PASSWORD
keyAlias=upload
keyPassword=TU_KEY_PASSWORD
```

Luego:

```bash
flutter build appbundle --release
```

También se aceptan las variables de entorno `ANDROID_KEYSTORE_PATH`,
`ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` y `ANDROID_KEY_PASSWORD`, que tienen
prioridad sobre `key.properties`.

Si se solicita una build Release sin firma válida, Gradle aborta con un mensaje explícito.

## 10. Respaldo y protección

- Guarda la `.jks` en al menos dos ubicaciones cifradas y controla el acceso.
- Registra las contraseñas y el alias en un gestor de secretos.
- No envíes la keystore por correo, chat ni la incluyas en imágenes.
- No uses la firma Debug para producción.
- Rota la clave solo si se ve comprometida; hacerlo tiene implicaciones en Play Console.

## 11. Si se pierde la Upload Key

1. Si **Play App Signing está habilitado**, solicita a Google Play Console el reinicio de
   la Upload Key (`App integrity → Upload key reset`) y sigue el procedimiento oficial.
2. Si **no** está habilitado y ya publicaste con esa clave, perderla impide actualizar la
   app; contacta al soporte de Google Play.
3. Genera una nueva keystore, actualiza los cuatro secrets y vuelve a ejecutar el workflow.

Nunca intentes subir un AAB firmado con otra clave sin completar el reinicio en Play Console.

## 12. Compatibilidad con Google Play

- `applicationId`: `com.bustrack.mobile` (estable, no cambiar).
- `versionCode` y `versionName` provienen de `pubspec.yaml` (`version: 1.0.0+1`).
  Incrementa `versionCode` en cada envío sin reiniciar la numeración.
- `minSdk`/`targetSdk` provienen de los valores de Flutter. `targetSdk` debe cumplir el
  nivel de API mínimo vigente exigido por Google Play; verifícalo antes de cada publicación.
- Entrega en formato Android App Bundle (`.aab`), no APK.

## 13. Intervención manual pendiente

- Crear la Upload Keystore (si aún no existe) y respaldarla.
- Registrar los cuatro GitHub Secrets.
- Ejecutar el workflow y confirmar que el artefacto descargado pasa `jarsigner -verify`
  antes de subirlo a Play Console.
