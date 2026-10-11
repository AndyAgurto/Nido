import 'package:drift/drift.dart';

/// Tabla de Categorías de movimientos (ingresos, gastos fijos/variables, proyectos).
class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get tipo => text()(); // 'ingreso', 'gastoFijo', 'gastoVariable', 'proyecto'
  TextColumn get icono => text().withDefault(const Constant('category'))();
  TextColumn get color => text().withDefault(const Constant('#4B6454'))();
  BoolColumn get esSistema => boolean().withDefault(const Constant(false))();
  BoolColumn get activa => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
