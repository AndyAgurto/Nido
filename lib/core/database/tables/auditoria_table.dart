import 'package:drift/drift.dart';

/// Bitácora inmutable de Auditoría para trazabilidad de todos los cambios de negocio.
/// REGLA: Esta tabla solo admite INSERT. Nunca se edita ni borra desde la app.
class Auditoria extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fechaHora => dateTime().withDefault(currentDateAndTime)();
  TextColumn get entidad => text().withLength(min: 1, max: 50)();
  IntColumn get entidadId => integer()();
  TextColumn get accion => text()(); // 'crear', 'editar', 'anular', 'restaurar', 'importar', 'exportar'
  TextColumn get valorAnteriorJson => text().nullable()();
  TextColumn get valorNuevoJson => text().nullable()();
  TextColumn get resumen => text()();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
}
