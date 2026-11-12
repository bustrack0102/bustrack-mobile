# Tareas — 08-consulta-de-paradas — Consulta de paradas

> Spec: `spec.md` · Plan: `plan.md` · Estado: Parcial.
> Marcar solo con evidencia. No marcar por documentar.

## Dependencias

1. T01 antes de T02
2. T02 antes de T03

## Actividades

### [-] T01. Definir pantalla

- Listado.
- Detalle.

**Archivos:** `lib/features/routes/presentation/screens/route_detail_screen.dart`, `lib/features/routes/domain/models/route_stop.dart`, specs-endpoints/21-endpoint-paradas/

**Evidencia:** listado de paradas ordenadas con referencia en mapa; el detalle dedicado de una parada sigue pendiente.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [ ] T02. Definir contrato

- Endpoint.
- Orden.

**Archivos:** `lib/features/routes/domain/repositories/route_repository.dart`, specs-endpoints/21-endpoint-paradas/

**Evidencia:** contrato propuesto documentado; sin consumo HTTP real.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

### [-] T03. Definir pruebas

- Listado.
- Vacío.

**Archivos:** `test/features/routes/demo_route_repository_test.dart`, specs-endpoints/21-endpoint-paradas/

**Evidencia:** se validan orden, coordenadas y paradas mínimas en el repositorio demo. Falta prueba de UI para el estado vacío del listado de paradas.

**Terminado cuando:** existe evidencia verificable en código, prueba o documento.

## Cierre

- [ ] Todas las tareas con evidencia.
- [x] `Memoria.md` actualizado.
- [x] Pruebas y gates ejecutados (`flutter analyze` y `flutter test`: 26 pruebas).
- [x] Sin afirmaciones de implementación no verificadas.
