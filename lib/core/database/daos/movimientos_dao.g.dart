// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimientos_dao.dart';

// ignore_for_file: type=lint
mixin _$MovimientosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CuentasTable get cuentas => attachedDatabase.cuentas;
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $MovimientosTable get movimientos => attachedDatabase.movimientos;
  MovimientosDaoManager get managers => MovimientosDaoManager(this);
}

class MovimientosDaoManager {
  final _$MovimientosDaoMixin _db;
  MovimientosDaoManager(this._db);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db.attachedDatabase, _db.cuentas);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db.attachedDatabase, _db.movimientos);
}
