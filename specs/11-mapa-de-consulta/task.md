# Tareas — 11-mapa-de-consulta — Mapa de consulta

> Spec: `spec.md` · Plan: `plan.md` · Estado: Parcial.
> Marcar solo con evidencia. No marcar por documentar.

## Dependencias

1. T01 antes de T02
2. T02 antes de T03

## Actividades

### [x] T01. Definir alcance del mapa

- Datos.
- Permisos.
- Límites.

**Archivos:** `lib/core/map/map_config.dart`, `android/app/src/main/AndroidManifest.xml`, `docs/map-integration.md`

**Evidencia:** alcance de solo consulta, permisos de ubicación en primer plano y límites documentados; sin rastreo en vivo ni segundo plano.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [x] T02. Definir integración

- Mapas.
- Marcadores.

**Archivos:** `lib/core/map/**`, `lib/features/routes/presentation/screens/explore_routes_screen.dart`, `lib/features/routes/presentation/screens/route_detail_screen.dart`

**Evidencia:** `flutter_map` + OpenStreetMap con marcadores, polilíneas, atribución, cámara y ubicación opcional del usuario.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T03. Definir pruebas

- Marcadores.
- Sin permiso.

**Archivos:** `test/core/map/map_utils_test.dart`, `test/features/routes/demo_route_repository_test.dart`

**Evidencia:** pruebas de distancias, coordenadas válidas y geometría de rutas demo. Falta prueba de widget para marcadores y para el flujo sin permiso de ubicación.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

## Cierre

- [ ] Todas las tareas con evidencia.
- [x] `Memoria.md` actualizado.
- [x] Pruebas y gates ejecutados (`flutter analyze` y `flutter test`: 26 pruebas).
- [x] Sin afirmaciones de implementación no verificadas.
