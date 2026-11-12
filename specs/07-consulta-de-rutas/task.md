# Tareas — 07-consulta-de-rutas — Consulta de rutas

> Spec: `spec.md` · Plan: `plan.md` · Estado: Parcial.
> Marcar solo con evidencia. No marcar por documentar.

## Dependencias

1. T01 antes de T02
2. T02 antes de T03

## Actividades

### [-] T01. Definir flujo de búsqueda

- Destino.
- Empresa.
- Resultados.

**Archivos:** `lib/features/routes/presentation/screens/explore_routes_screen.dart`, `lib/features/routes/data/demo_route_repository.dart`, specs-endpoints/20-endpoint-rutas/

**Evidencia:** búsqueda por texto, filtro por modo y listado de resultados implementados con datos demo. Filtro por empresa y consumo HTTP real pendientes.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T02. Definir detalle

- Paradas.
- Horarios.
- Tarifas.

**Archivos:** `lib/features/routes/presentation/screens/route_detail_screen.dart`, `lib/features/routes/domain/models/transport_route.dart`, specs-endpoints/20-endpoint-rutas/

**Evidencia:** detalle con paradas ordenadas, tarifa, empresa y mapa. Horarios reales pendientes.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T03. Definir pruebas

- Búsqueda.
- Vacío.
- Error.

**Archivos:** `test/features/routes/demo_route_repository_test.dart`, `test/features/routes/route_card_test.dart`, specs-endpoints/20-endpoint-rutas/

**Evidencia:** pruebas de búsqueda, filtro, detalle por id, tarjeta de ruta y fallo de red simulado. Falta prueba de widget para estados vacío/error de la pantalla completa.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

## Cierre

- [ ] Todas las tareas con evidencia.
- [x] `Memoria.md` actualizado.
- [x] Pruebas y gates ejecutados (`flutter analyze` y `flutter test`: 26 pruebas).
- [x] Sin afirmaciones de implementación no verificadas.
