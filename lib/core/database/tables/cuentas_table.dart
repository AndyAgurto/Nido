import 'package:drift/drift.dart';

/// Tabla de Cuentas financieras (efectivo, bancos, ahorros, tarjetas, etc.).
class Cuentas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get tipo => text()(); // 'efectivo', 'banco', 'ahorro', 'tarjeta', 'otro'
  IntColumn get saldoInicialCent => integer().withDefault(const Constant(0))();
  BoolColumn get activa => boolean().withDefault(const Constant(true))();
  TextColumn get color => text().withDefault(const Constant('#0D5D38'))();
  TextColumn get icono => text().withDefault(const Constant('account_balance_wallet'))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
