// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cuentas_dao.dart';

// ignore_for_file: type=lint
mixin _$CuentasDaoMixin on DatabaseAccessor<AppDatabase> {
  $CuentasTable get cuentas => attachedDatabase.cuentas;
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $MovimientosTable get movimientos => attachedDatabase.movimientos;
  CuentasDaoManager get managers => CuentasDaoManager(this);
}

class CuentasDaoManager {
  final _$CuentasDaoMixin _db;
  CuentasDaoManager(this._db);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db.attachedDatabase, _db.cuentas);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db.attachedDatabase, _db.movimientos);
}
