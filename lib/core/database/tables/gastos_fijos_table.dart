import 'package:drift/drift.dart';
import 'cuentas_table.dart';
import 'categorias_table.dart';
import 'movimientos_table.dart';

/// Plantillas recurrentes de Gastos Fijos (luz, agua, alquiler, etc.).
class GastosFijos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  IntColumn get montoEstimadoCent => integer()();
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  IntColumn get cuentaPagoId => integer().references(Cuentas, #id)();
  IntColumn get diaVencimiento => integer()(); // 1 a 31
  TextColumn get frecuencia => text().withDefault(const Constant('mensual'))(); // 'mensual', 'bimestral', 'trimestral', 'anual'
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Instancias de pagos esperados generadas para un periodo mensual (yyyy-MM).
class GastosFijosPagos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gastoFijoId => integer().references(GastosFijos, #id)();
  TextColumn get periodo => text().withLength(min: 7, max: 7)(); // yyyy-MM
  IntColumn get montoEsperadoCent => integer()();
  TextColumn get estado => text().withDefault(const Constant('pendiente'))(); // 'pendiente', 'pagado', 'omitido'
  IntColumn get movimientoId => integer().nullable().references(Movimientos, #id)();
  DateTimeColumn get fechaVencimiento => dateTime()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
