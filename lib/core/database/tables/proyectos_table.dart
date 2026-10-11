import 'package:drift/drift.dart';

/// Proyectos del Hogar (remodelación, mobiliario, arreglos, etc.).
class Proyectos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 150)();
  TextColumn get descripcion => text().nullable()();
  TextColumn get tipo => text()(); // 'decoracion', 'construccion', 'arreglo', 'mobiliario', 'otro'
  TextColumn get estado => text().withDefault(const Constant('idea'))(); // 'idea', 'cotizando', 'aprobado', 'enEjecucion', 'terminado', 'cancelado'
  IntColumn get presupuestoObjetivoCent => integer()();
  DateTimeColumn get fechaInicioEstimada => dateTime().nullable()();
  DateTimeColumn get fechaFinEstimada => dateTime().nullable()();
  TextColumn get prioridad => text().withDefault(const Constant('media'))(); // 'baja', 'media', 'alta'
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Partidas presupuestarias o rubros dentro de un proyecto.
class PartidasProyecto extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get proyectoId => integer().references(Proyectos, #id)();
  TextColumn get nombre => text().withLength(min: 1, max: 150)();
  TextColumn get descripcion => text().nullable()();
  IntColumn get presupuestoCent => integer()();
  IntColumn get cotizacionElegidaId => integer().nullable()(); // FK lógica hacia Cotizaciones
  TextColumn get estado => text().withDefault(const Constant('pendiente'))(); // 'pendiente', 'cotizado', 'adjudicado', 'completado'
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}

/// Cotizaciones de proveedores para una partida.
class Cotizaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partidaId => integer().references(PartidasProyecto, #id)();
  TextColumn get proveedor => text().withLength(min: 1, max: 150)();
  TextColumn get contacto => text().nullable()();
  IntColumn get montoCent => integer()();
  DateTimeColumn get fecha => dateTime()();
  DateTimeColumn get vigenteHasta => dateTime().nullable()();
  TextColumn get notas => text().nullable()();
  TextColumn get fotoRutaRelativa => text().nullable()(); // Ruta relativa en directorio privado de la app
  BoolColumn get elegida => boolean().withDefault(const Constant(false))();
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
}
