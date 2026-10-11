// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proyectos_dao.dart';

// ignore_for_file: type=lint
mixin _$ProyectosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProyectosTable get proyectos => attachedDatabase.proyectos;
  $PartidasProyectoTable get partidasProyecto =>
      attachedDatabase.partidasProyecto;
  $CotizacionesTable get cotizaciones => attachedDatabase.cotizaciones;
  $CuentasTable get cuentas => attachedDatabase.cuentas;
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $MovimientosTable get movimientos => attachedDatabase.movimientos;
  ProyectosDaoManager get managers => ProyectosDaoManager(this);
}

class ProyectosDaoManager {
  final _$ProyectosDaoMixin _db;
  ProyectosDaoManager(this._db);
  $$ProyectosTableTableManager get proyectos =>
      $$ProyectosTableTableManager(_db.attachedDatabase, _db.proyectos);
  $$PartidasProyectoTableTableManager get partidasProyecto =>
      $$PartidasProyectoTableTableManager(
        _db.attachedDatabase,
        _db.partidasProyecto,
      );
  $$CotizacionesTableTableManager get cotizaciones =>
      $$CotizacionesTableTableManager(_db.attachedDatabase, _db.cotizaciones);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db.attachedDatabase, _db.cuentas);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db.attachedDatabase, _db.movimientos);
}
