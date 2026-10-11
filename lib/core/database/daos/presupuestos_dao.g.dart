// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presupuestos_dao.dart';

// ignore_for_file: type=lint
mixin _$PresupuestosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $PresupuestosMensualesTable get presupuestosMensuales =>
      attachedDatabase.presupuestosMensuales;
  $CuentasTable get cuentas => attachedDatabase.cuentas;
  $MovimientosTable get movimientos => attachedDatabase.movimientos;
  PresupuestosDaoManager get managers => PresupuestosDaoManager(this);
}

class PresupuestosDaoManager {
  final _$PresupuestosDaoMixin _db;
  PresupuestosDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$PresupuestosMensualesTableTableManager get presupuestosMensuales =>
      $$PresupuestosMensualesTableTableManager(
        _db.attachedDatabase,
        _db.presupuestosMensuales,
      );
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db.attachedDatabase, _db.cuentas);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db.attachedDatabase, _db.movimientos);
}
