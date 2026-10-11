// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gastos_fijos_dao.dart';

// ignore_for_file: type=lint
mixin _$GastosFijosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $CuentasTable get cuentas => attachedDatabase.cuentas;
  $GastosFijosTable get gastosFijos => attachedDatabase.gastosFijos;
  $MovimientosTable get movimientos => attachedDatabase.movimientos;
  $GastosFijosPagosTable get gastosFijosPagos =>
      attachedDatabase.gastosFijosPagos;
  $IngresosFijosTable get ingresosFijos => attachedDatabase.ingresosFijos;
  $IngresosFijosCobrosTable get ingresosFijosCobros =>
      attachedDatabase.ingresosFijosCobros;
  GastosFijosDaoManager get managers => GastosFijosDaoManager(this);
}

class GastosFijosDaoManager {
  final _$GastosFijosDaoMixin _db;
  GastosFijosDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db.attachedDatabase, _db.cuentas);
  $$GastosFijosTableTableManager get gastosFijos =>
      $$GastosFijosTableTableManager(_db.attachedDatabase, _db.gastosFijos);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db.attachedDatabase, _db.movimientos);
  $$GastosFijosPagosTableTableManager get gastosFijosPagos =>
      $$GastosFijosPagosTableTableManager(
        _db.attachedDatabase,
        _db.gastosFijosPagos,
      );
  $$IngresosFijosTableTableManager get ingresosFijos =>
      $$IngresosFijosTableTableManager(_db.attachedDatabase, _db.ingresosFijos);
  $$IngresosFijosCobrosTableTableManager get ingresosFijosCobros =>
      $$IngresosFijosCobrosTableTableManager(
        _db.attachedDatabase,
        _db.ingresosFijosCobros,
      );
}
