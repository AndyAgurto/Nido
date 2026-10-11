import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/proyectos_dao.dart';
export '../../../core/database/daos/proyectos_dao.dart' show ProyectoAvance, PartidaAvance;

/// Filtro de estado para la lista de proyectos (null = todos).
final proyectosFiltroEstadoProvider = StateProvider<String?>((ref) => null);

/// Stream reactivo de la lista de proyectos con filtro por estado.
final proyectosStreamProvider = StreamProvider<List<Proyecto>>((ref) {
  final dao = ref.watch(proyectosDaoProvider);
  final estado = ref.watch(proyectosFiltroEstadoProvider);
  return dao.watchProyectos(estado: estado);
});

/// ID del proyecto seleccionado en la vista Master-Detail.
final proyectoSeleccionadoIdProvider = StateProvider<int?>((ref) => null);

/// Stream reactivo del proyecto seleccionado actualmente.
final proyectoSeleccionadoStreamProvider = StreamProvider<Proyecto?>((ref) {
  final dao = ref.watch(proyectosDaoProvider);
  final id = ref.watch(proyectoSeleccionadoIdProvider);
  if (id == null) return Stream.value(null);
  return dao.watchProyectoById(id);
});

/// Stream reactivo del avance y consolidado financiero de un proyecto (Presupuesto vs Cotizado vs Gastado).
final proyectoAvanceStreamProvider =
    StreamProvider.family<ProyectoAvance, int>((ref, proyectoId) {
  final dao = ref.watch(proyectosDaoProvider);
  // Escuchamos el stream de movimientos del proyecto para reactividad inmediata al registrar o anular
  ref.watch(movimientosDelProyectoStreamProvider(proyectoId));
  // Escuchamos también cambios en partidas
  ref.watch(partidasDelProyectoStreamProvider(proyectoId));

  return Stream.fromFuture(dao.calcularAvanceProyecto(proyectoId));
});

/// Stream reactivo de las partidas de un proyecto.
final partidasDelProyectoStreamProvider =
    StreamProvider.family<List<PartidasProyectoData>, int>((ref, proyectoId) {
  final dao = ref.watch(proyectosDaoProvider);
  return dao.watchPartidas(proyectoId);
});

/// ID de la partida actualmente seleccionada dentro del detalle del proyecto.
final partidaSeleccionadaIdProvider = StateProvider<int?>((ref) => null);

/// Stream reactivo del consolidado de avance de una partida específica.
final partidaAvanceStreamProvider =
    StreamProvider.family<PartidaAvance, int>((ref, partidaId) {
  final dao = ref.watch(proyectosDaoProvider);
  ref.watch(cotizacionesDePartidaStreamProvider(partidaId));
  ref.watch(movimientosDePartidaStreamProvider(partidaId));

  return Stream.fromFuture(dao.calcularAvancePartida(partidaId));
});

/// Stream reactivo de las cotizaciones registradas para una partida.
final cotizacionesDePartidaStreamProvider =
    StreamProvider.family<List<Cotizacione>, int>((ref, partidaId) {
  final dao = ref.watch(proyectosDaoProvider);
  return dao.watchCotizaciones(partidaId);
});

/// Stream reactivo de los movimientos de gasto vinculados a un proyecto completo.
final movimientosDelProyectoStreamProvider =
    StreamProvider.family<List<Movimiento>, int>((ref, proyectoId) {
  final dao = ref.watch(proyectosDaoProvider);
  return dao.watchMovimientosDelProyecto(proyectoId);
});

/// Stream reactivo de los movimientos de gasto vinculados a una partida específica.
final movimientosDePartidaStreamProvider =
    StreamProvider.family<List<Movimiento>, int>((ref, partidaId) {
  final dao = ref.watch(proyectosDaoProvider);
  return dao.watchMovimientosDePartida(partidaId);
});
