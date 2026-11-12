# Integración de mapas y pantallas principales (Flutter)

> Fecha: 2026-11-12
> Estado: implementado con datos de demostración; API central aún no expone rutas/paradas.

## 1. Decisión de proveedor

Se usa `flutter_map` con tiles de OpenStreetMap (OSM) porque:

- No requiere API Key ni cuenta de facturación.
- Permite mapa interactivo real (zoom, paneo, marcadores y polilíneas).
- La app no accede a Cosmos DB ni a servicios de mapas propietarios.

Configuración central en `lib/core/map/map_config.dart`:

- URL de tiles: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`.
- `userAgentPackageName = com.bustrack.mobile`.
- Atribución OSM obligatoria (el widget la muestra por defecto).
- Centro y zoom iniciales de Monterrey.
- `demoNotice`: texto reutilizable que aclara que los datos mostrados son de demostración.

## 2. Dependencias

| Paquete | Versión | Uso |
| --- | --- | --- |
| `flutter_map` | 8.3.2 | Mapa interactivo, marcadores, polilíneas y atribución. |
| `latlong2` | 0.10.1 | Coordenadas compatibles con `flutter_map`. |
| `geolocator` | 14.1.2 | Ubicación del usuario en primer plano, solo con consentimiento. |

## 3. Arquitectura reutilizable

```text
lib/core/map/
  models/geo_point.dart          # Coordenada propia, sin acoplar dominio a latlong2
  models/app_map_marker.dart     # Marcador semántico (tipo, título, selección)
  models/app_route_polyline.dart # Polilínea de una ruta
  map_config.dart                # Proveedor, tiles, atribución, centro y aviso demo
  map_utils.dart                 # Distancias, formato y punto medio
  map_controller_service.dart    # Cámara: centrar, zoom y ajustar a ruta
  location_service.dart          # Geolocalización y permisos de primer plano
  map_view.dart                  # AppMapView (widget reutilizable)
```

`AppMapView` recibe marcadores, polilíneas, ubicación opcional y callbacks; las
pantallas no manipulan `MapController` directamente salvo a través de
`MapControllerService`.

## 4. Pantallas

| # | Pantalla | Archivo |
| --- | --- | --- |
| 6 | Explorar rutas | `lib/features/routes/presentation/screens/explore_routes_screen.dart` |
| 7 | Detalle de ruta | `lib/features/routes/presentation/screens/route_detail_screen.dart` |
| 8 | Viaje en curso | `lib/features/trip/presentation/screens/trip_in_progress_screen.dart` |
| 9 | Historial | `lib/features/history/presentation/screens/trip_history_screen.dart` |
| 10 | Perfil | `lib/features/profile/presentation/screens/profile_screen.dart` |
| 11 | Calificar y contribuir | `lib/features/feedback/presentation/screens/rate_contribute_screen.dart` |

La navegación principal vive en
`lib/features/home/presentation/screens/main_shell_screen.dart` con una
`NavigationBar` de tres destinos: Explorar, Historial y Perfil. `lib/main.dart`
usa `MainShellScreen` después de iniciar sesión o entrar en modo demo.

Flujo: Explorar → Detalle → Viaje en curso; Detalle → Calificar y contribuir;
Historial / Perfil como destinos del shell inferior.

## 5. Consentimiento y privacidad

- La ubicación es opcional y solo en primer plano.
- Permisos declarados en `android/app/src/main/AndroidManifest.xml`:
  `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION` e `INTERNET`.
- No se solicita ubicación en segundo plano ni se rastrea al usuario de forma continua.
- Si el usuario niega el permiso, el mapa sigue funcionando con el centro por defecto.
- No se envían coordenadas a la API central.

## 6. Datos de demostración (honestidad)

- `DemoRouteRepository` entrega rutas con `isDemo: true`.
- La UI muestra `DemoDataBadge` y `MapConfig.demoNotice`.
- No se simulan posiciones de autobuses ni ETA en tiempo real. Cuando no hay
  datos reales, la interfaz lo indica explícitamente.
- Contratos previstos, aún no disponibles:
  `GET /api/v1/rutas` y `GET /api/v1/rutas/{id}/paradas`.
- Las contribuciones se guardan solo en memoria local
  (`syncedWithApi: false`); no hay recompensas implementadas.
- La eliminación de cuenta reporta honestamente que el endpoint no está disponible.

## 7. Pruebas

```text
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Cobertura agregada:

- `test/core/map/map_utils_test.dart`
- `test/features/routes/demo_route_repository_test.dart`
- `test/features/routes/route_card_test.dart`
- `test/features/history/journey_history_service_test.dart`
- `test/features/history/trip_history_screen_test.dart`
- `test/features/feedback/contribution_service_test.dart`
- `test/features/feedback/rate_contribute_screen_test.dart`

## 8. Pendientes

- Sustituir `DemoRouteRepository` por un repositorio HTTP cuando exista el contrato
  oficial de rutas y paradas.
- Persistir historial y contribuciones de forma segura cuando se apruebe el
  almacenamiento correspondiente.
- Validar el mapa en un dispositivo/emulador real; el entorno local no tiene
  Android SDK ni JDK para compilar.
