import 'package:drift/drift.dart';
import 'cuentas_table.dart';
import 'categorias_table.dart';

/// Tabla de Movimientos financieros (ingresos, gastos, transferencias).
/// REGLA: Los registros nunca se borran físicamente; se anulan lógicamente.
class Movimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get tipo => text()(); // 'ingreso', 'gasto', 'transferencia'
  IntColumn get montoCent => integer()();
  IntColumn get cuentaOrigenId => integer().references(Cuentas, #id)();
  IntColumn get cuentaDestinoId => integer().nullable().references(Cuentas, #id)();
  IntColumn get categoriaId => integer().nullable().references(Categorias, #id)();
  TextColumn get descripcion => text().withLength(min: 1, max: 255)();
  TextColumn get notas => text().nullable()();
  IntColumn get gastoFijoPagoId => integer().nullable()();
  IntColumn get partidaId => integer().nullable()();
  BoolColumn get anulado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get anuladoEn => dateTime().nullable()();
  TextColumn get motivoAnulacion => text().nullable()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
