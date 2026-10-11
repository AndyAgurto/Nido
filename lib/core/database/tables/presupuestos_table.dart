import 'package:drift/drift.dart';
import 'categorias_table.dart';

/// Presupuestos fijados por Categoría y Periodo Mensual (yyyy-MM).
class PresupuestosMensuales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get periodo => text().withLength(min: 7, max: 7)(); // yyyy-MM
  IntColumn get categoriaId => integer().references(Categorias, #id)();
  IntColumn get montoCent => integer()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {periodo, categoriaId}
      ];
}
