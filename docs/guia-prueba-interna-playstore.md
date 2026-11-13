# BusTrack Mobile — Guía Paso a Paso para Publicar en Prueba Interna (Google Play Console)

> **Tipo de Versión:** Prueba Interna (Internal Testing Track)  
> **Paquete:** `com.bustrackapp`  
> **Formato de Entrega:** Android App Bundle (`.aab`)  
> **Audiencia:** Testers internos y equipo de desarrollo (hasta 100 probadores sin revisión prolongada de Google).

---

## 1. Generar la Clave de Firma (Keystore de Subida)

Google Play Store exige que todas las aplicaciones estén firmadas. Google Play App Signing gestiona la clave de distribución final, pero tú necesitas una clave de subida (*upload key*).

### Paso 1.1: Crear el Keystore con `keytool`
Abre una terminal (PowerShell o CMD) en tu máquina y ejecuta:

```powershell
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Te pedirá una contraseña (anótala de forma segura).
- Te pedirá datos de contacto (Nombre, Organización, Ciudad, País).
- Guarda el archivo generado `upload-keystore.jks` fuera del repositorio o en un directorio seguro local.

> [!CAUTION]
> **Nunca subas el archivo `.jks` ni las contraseñas al repositorio Git**. Está protegido por `.gitignore`.

---

## 2. Compilar el Android App Bundle (`.aab`)

Google Play ya no acepta archivos `.apk` para publicaciones iniciales; requiere el formato optimizado `.aab`.

En la raíz del proyecto ejecuta:

```bash
flutter build appbundle --release
```

Si deseas inyectar variables de entorno de producción:
```bash
flutter build appbundle --release --dart-define=ENV=production --dart-define=API_URL=https://api.bustrack.azurewebsites.net
```

El archivo resultante quedará ubicado en:
`build/app/outputs/bundle/release/app-release.aab`

---

## 3. Crear la Aplicación en Google Play Console

1. Inicia sesión en [Google Play Console](https://play.google.com/console).
2. En el panel principal, haz clic en el botón superior derecho: **«Crear app»**.
3. Completa los detalles iniciales:
   - **Nombre de la app:** `BusTrack`
   - **Idioma predeterminado:** Español (Latinoamérica) - `es-419` o Español (Estados Unidos).
   - **¿Es una app o un juego?:** Selecciona **App**.
   - **¿Es gratis o de pago?:** Selecciona **Gratis**.
4. En **Declaraciones**:
   - Acepta los términos de las políticas del programa para desarrolladores y las leyes de exportación de EE. UU.
5. Haz clic en **«Crear app»** en la parte inferior.

---

## 4. Configurar la Pista de Prueba Interna (*Internal Testing*)

La prueba interna es la forma más rápida y recomendada para probar en dispositivos reales:
- **No requiere la revisión exhaustiva de varios días de Google**.
- Está disponible para los testers casi de inmediato (unos minutos tras la subida).
- Permite hasta 100 probadores autorizados.

### Paso 4.1: Crear la Lista de Verificadores (Testers)
1. En el menú lateral izquierdo de tu app en Play Console, navega a:  
   **Probar** > **Pruebas internas** (*Internal testing*).
2. Selecciona la pestaña **Verificadores** (*Testers*).
3. Haz clic en **«Crear lista de distribución de correo»**.
4. Asigna un nombre a la lista (ejemplo: `Equipo BusTrack`).
5. Agrega los correos de Gmail / Google Workspace de las personas que probarán la app.
6. Guarda la lista y asegúrate de marcar la casilla para asociarla a la pista interna.
7. Guarda los cambios.

---

## 5. Subir el Release `.aab` a la Prueba Interna

1. Dentro de **Pruebas internas**, haz clic en la pestaña **Versiones** (*Releases*).
2. Haz clic en el botón **«Crear versión nueva»** (*Create new release*).
3. **Firma de la app (Google Play App Signing):**  
   - Si te pregunta por Play App Signing, selecciona la opción recomendada: **«Usar la clave generada por Google»**.
4. En la sección **Paquetes de aplicaciones**:
   - Arrastra o sube el archivo generado: `app-release.aab`.
   - Google Play procesará el bundle y detectará el nombre de versión (ej. `1.0.0 (1)`).
5. **Nombre de la versión:** `1.0.0 (1) - Prueba Interna Inicial`.
6. **Notas de la versión:** Escribe un breve resumen para los testers:
   ```text
   Versión de prueba interna de BusTrack Mobile:
   - Primeras pantallas de Splash, Registro, Verificación OTP y Login.
   - Navegación base y diseño oficial con Plus Jakarta Sans.
   - Modo de demostración para exploración de rutas.
   ```
7. Haz clic en **«Siguiente»** o **«Guardar y revisar versión»**.
8. Si hay advertencias leves (como símbolos de depuración nativos), puedes continuar.
9. Haz clic en **«Iniciar lanzamiento a prueba interna»** (*Start rollout to Internal testing*).

---

## 6. Secciones Obligatorias en «Contenido de la App»

Para que el enlace de prueba interna se active correctamente, Google Play Console requiere completar algunas declaraciones básicas en la sección **«Contenido de la app»** (menú lateral izquierdo inferior):

1. **Política de Privacidad:**
   - Proporciona una URL pública accesible por HTTPS: `https://bustrack.com/privacidad`.
2. **Acceso a la app:**
   - Selecciona: *«Todas o algunas funcionalidades están restringidas»*.
   - Proporciona credenciales de prueba para que los revisores puedan ingresar (ej. usuario: `pasajero@bustrack.com` / contraseña: `claveSegura2026`), o indica que existe un botón «Explorar Demostración» que no requiere credenciales.
3. **Anuncios:**
   - Selecciona: *«No, mi app no contiene anuncios»*.
4. **Público objetivo y contenido:**
   - Grupo de edad: Selecciona **18 años o más** (o mayores de 13 años). No selecciones niños.
5. **Seguridad de los datos (*Data Safety*):**
   - **Ubicación:** Recopilada de forma opcional (solo en primer plano para centrar el mapa y buscar paradas; no compartida con terceros, no rastreo continuo).
   - **Información personal:** Correo electrónico para identificación de cuenta.
   - **Sensores:** Datos de movimiento (acelerómetro) bajo consentimiento previo para el modelo de transporte ML.
   - **Eliminación de cuenta:** Declara que los usuarios pueden solicitar eliminar su cuenta y datos tanto dentro de la app como mediante la URL externa `https://bustrack.com/privacidad/eliminar-cuenta`.

---

## 7. Cómo Descargan y Prueban los Testers

1. En la pestaña **Verificadores** de Pruebas internas, al final encontrarás la sección:
   **«Cómo obtienen los verificadores la versión de prueba interna»**.
2. Copia el enlace que dice **«Copiar vínculo»** (*Copy link*).
3. Envía ese enlace a los correos que agregaste en la lista de testers.
4. El tester debe abrir ese enlace en su teléfono Android:
   - Iniciará sesión con su cuenta de Google.
   - Presionará **«Aceptar invitación»** o **«Convertirse en tester»**.
   - Aparecerá un enlace directo a **Google Play Store** para descargar e instalar **BusTrack**.
