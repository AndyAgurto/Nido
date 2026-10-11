import 'package:drift/drift.dart';
import 'cuentas_table.dart';
import 'movimientos_table.dart';

/// Plantillas recurrentes de Ingresos Fijos (sueldos, rentas fijas, etc.).
class IngresosFijos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  IntColumn get montoEstimadoCent => integer()();
  IntColumn get cuentaId => integer().references(Cuentas, #id)();
  IntColumn get diaCobro => integer()(); // 1 a 31
  TextColumn get frecuencia => text().withDefault(const Constant('mensual'))(); // 'mensual', 'bimestral', 'trimestral', 'anual'
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Instancias mensuales de cobros esperados (yyyy-MM).
class IngresosFijosCobros extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ingresoFijoId => integer().references(IngresosFijos, #id)();
  TextColumn get periodo => text().withLength(min: 7, max: 7)(); // yyyy-MM
  IntColumn get montoEsperadoCent => integer()();
  TextColumn get estado => text().withDefault(const Constant('pendiente'))(); // 'pendiente', 'cobrado', 'omitido'
  IntColumn get movimientoId => integer().nullable().references(Movimientos, #id)();
  DateTimeColumn get fechaCobroEsperada => dateTime()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
