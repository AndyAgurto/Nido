import 'package:drift/drift.dart';

/// Configuración clave-valor persistente de la aplicación Nido.
class Ajustes extends Table {
  TextColumn get clave => text().withLength(min: 1, max: 100)();
  TextColumn get valor => text()();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {clave};
}
