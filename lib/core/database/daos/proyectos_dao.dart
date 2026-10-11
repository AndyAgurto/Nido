import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/proyectos_table.dart';
import '../tables/movimientos_table.dart';
import '../../money/money.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

part 'proyectos_dao.g.dart';

/// DTO con el consolidado financiero de un Proyecto del Hogar:
/// Presupuesto vs Cotizado vs Gastado Real.
class ProyectoAvance {
  const ProyectoAvance({
    required this.proyecto,
    required this.presupuestoObjetivo,
    required this.presupuestoPartidas,
    required this.totalCotizado,
    required this.gastadoReal,
    required this.totalPartidas,
    required this.partidasAdjudicadas,
    required this.partidasCompletadas,
  });

  final Proyecto proyecto;
  final Money presupuestoObjetivo;
  final Money presupuestoPartidas;
  final Money totalCotizado;
  final Money gastadoReal;
  final int totalPartidas;
  final int partidasAdjudicadas;
  final int partidasCompletadas;

  /// Presupuesto base de referencia (suma de partidas si existen, o presupuesto objetivo)
  Money get presupuestoReferencia =>
      presupuestoPartidas.cents > 0 ? presupuestoPartidas : presupuestoObjetivo;

  /// Porcentaje de avance de cotizaciones adjudicadas frente al presupuesto
  double get porcentajeCotizado {
    if (presupuestoReferencia.cents <= 0) return 0.0;
    return totalCotizado.cents / presupuestoReferencia.cents;
  }

  /// Porcentaje de dinero real desembolsado frente al presupuesto
  double get porcentajeGastadoVsPresupuesto {
    if (presupuestoReferencia.cents <= 0) return 0.0;
    return gastadoReal.cents / presupuestoReferencia.cents;
  }

  /// Porcentaje de dinero gastado frente a lo cotizado
  double get porcentajeGastadoVsCotizado {
    if (totalCotizado.cents <= 0) return 0.0;
    return gastadoReal.cents / totalCotizado.cents;
  }

  /// Dinero disponible restante frente al presupuesto de referencia
  Money get disponiblePresupuesto => presupuestoReferencia - gastadoReal;

  /// Dinero disponible restante frente a las cotizaciones adjudicadas
  Money get disponibleCotizado => totalCotizado - gastadoReal;
}

/// DTO con el consolidado de una Partida presupuestaria.
class PartidaAvance {
  const PartidaAvance({
    required this.partida,
    this.cotizacionElegida,
    required this.presupuesto,
    this.montoCotizado,
    required this.gastadoReal,
    required this.totalCotizaciones,
    this.cotizacionMasEconomica,
  });

  final PartidasProyectoData partida;
  final Cotizacione? cotizacionElegida;
  final Money presupuesto;
  final Money? montoCotizado;
  final Money gastadoReal;
  final int totalCotizaciones;
  final Cotizacione? cotizacionMasEconomica;

  Money get baseComparacion => montoCotizado ?? presupuesto;
  Money get restante => baseComparacion - gastadoReal;

  double get porcentajeEjecutado {
    if (baseComparacion.cents <= 0) return 0.0;
    return gastadoReal.cents / baseComparacion.cents;
  }
}

/// DAO para gestin de Proyectos del Hogar, Partidas, Cotizaciones y Avance.
@DriftAccessor(tables: [Proyectos, PartidasProyecto, Cotizaciones, Movimientos])
class ProyectosDao extends DatabaseAccessor<AppDatabase>
    with _$ProyectosDaoMixin {
  ProyectosDao(super.db);

  // ==========================================
  // PROYECTOS
  // ==========================================

  Stream<List<Proyecto>> watchProyectos({String? estado}) {
    final query = select(proyectos);
    if (estado != null) {
      query.where((t) => t.estado.equals(estado));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.actualizadoEn)]);
    return query.watch();
  }

  Future<List<Proyecto>> getProyectos({String? estado}) {
    final query = select(proyectos);
    if (estado != null) {
      query.where((t) => t.estado.equals(estado));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.actualizadoEn)]);
    return query.get();
  }

  Stream<Proyecto?> watchProyectoById(int id) {
    return (select(proyectos)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<Proyecto?> getProyectoById(int id) {
    return (select(proyectos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertProyecto(
    ProyectosCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(proyectos).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Proyecto',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'nombre': companion.nombre.value,
          'tipo': companion.tipo.value,
          'presupuestoObjetivoCent': companion.presupuestoObjetivoCent.value,
        },
        resumen: 'Creacin de proyecto "${companion.nombre.value}"',
      ),
    );
  }

  Future<bool> updateProyecto(
    ProyectosCompanion companion,
    AuditedWriter writer,
  ) async {
    final anterior = await getProyectoById(companion.id.value);
    final rows = await writer.write<int>(
      action: () => (update(proyectos)..where((t) => t.id.equals(companion.id.value)))
          .write(companion.copyWith(actualizadoEn: Value(DateTime.now()))),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Proyecto',
        entidadId: companion.id.value,
        accion: 'editar',
        valorAnterior: anterior != null
            ? {
                'nombre': anterior.nombre,
                'estado': anterior.estado,
                'presupuestoObjetivoCent': anterior.presupuestoObjetivoCent,
              }
            : null,
        valorNuevo: {
          'nombre': companion.nombre.present ? companion.nombre.value : anterior?.nombre,
          'estado': companion.estado.present ? companion.estado.value : anterior?.estado,
          'presupuestoObjetivoCent': companion.presupuestoObjetivoCent.present
              ? companion.presupuestoObjetivoCent.value
              : anterior?.presupuestoObjetivoCent,
        },
        resumen: 'Actualización de proyecto "${companion.nombre.present ? companion.nombre.value : (anterior?.nombre ?? '')}"',
      ),
    );
    return rows > 0;
  }

  Future<bool> cambiarEstadoProyecto(
    int proyectoId,
    String nuevoEstado,
    AuditedWriter writer,
  ) async {
    final anterior = await getProyectoById(proyectoId);
    if (anterior == null) return false;

    final rows = await writer.write<int>(
      action: () => (update(proyectos)..where((t) => t.id.equals(proyectoId))).write(
        ProyectosCompanion(
          estado: Value(nuevoEstado),
          actualizadoEn: Value(DateTime.now()),
        ),
      ),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Proyecto',
        entidadId: proyectoId,
        accion: 'editar_estado',
        valorAnterior: {'estado': anterior.estado},
        valorNuevo: {'estado': nuevoEstado},
        resumen: 'Cambio de estado del proyecto a "$nuevoEstado"',
      ),
    );
    return rows > 0;
  }

  // ==========================================
  // PARTIDAS
  // ==========================================

  Stream<List<PartidasProyectoData>> watchPartidas(int proyectoId) {
    return (select(partidasProyecto)
          ..where((t) => t.proyectoId.equals(proyectoId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<List<PartidasProyectoData>> getPartidas(int proyectoId) {
    return (select(partidasProyecto)
          ..where((t) => t.proyectoId.equals(proyectoId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  Future<PartidasProyectoData?> getPartidaById(int id) {
    return (select(partidasProyecto)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertPartida(
    PartidasProyectoCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(partidasProyecto).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'PartidaProyecto',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'proyectoId': companion.proyectoId.value,
          'nombre': companion.nombre.value,
          'presupuestoCent': companion.presupuestoCent.value,
        },
        resumen: 'Creacin de partida "${companion.nombre.value}"',
      ),
    );
  }

  Future<bool> updatePartida(
    PartidasProyectoCompanion companion,
    AuditedWriter writer,
  ) async {
    final anterior = await getPartidaById(companion.id.value);
    final rows = await writer.write<int>(
      action: () => (update(partidasProyecto)
            ..where((t) => t.id.equals(companion.id.value)))
          .write(companion.copyWith(actualizadoEn: Value(DateTime.now()))),
      auditBuilder: (_) => AuditEntry(
        entidad: 'PartidaProyecto',
        entidadId: companion.id.value,
        accion: 'editar',
        valorAnterior: anterior != null
            ? {
                'nombre': anterior.nombre,
                'presupuestoCent': anterior.presupuestoCent,
                'estado': anterior.estado,
              }
            : null,
        valorNuevo: {
          'nombre': companion.nombre.present ? companion.nombre.value : anterior?.nombre,
          'presupuestoCent': companion.presupuestoCent.present
              ? companion.presupuestoCent.value
              : anterior?.presupuestoCent,
        },
        resumen: 'Actualización de partida "${companion.nombre.present ? companion.nombre.value : (anterior?.nombre ?? '')}"',
      ),
    );
    return rows > 0;
  }

  // ==========================================
  // COTIZACIONES
  // ==========================================

  Stream<List<Cotizacione>> watchCotizaciones(int partidaId) {
    return (select(cotizaciones)
          ..where((t) => t.partidaId.equals(partidaId))
          ..orderBy([(t) => OrderingTerm.asc(t.montoCent)]))
        .watch();
  }

  Future<List<Cotizacione>> getCotizaciones(int partidaId) {
    return (select(cotizaciones)
          ..where((t) => t.partidaId.equals(partidaId))
          ..orderBy([(t) => OrderingTerm.asc(t.montoCent)]))
        .get();
  }

  Future<Cotizacione?> getCotizacionById(int id) {
    return (select(cotizaciones)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertCotizacion(
    CotizacionesCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(cotizaciones).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Cotizacion',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'partidaId': companion.partidaId.value,
          'proveedor': companion.proveedor.value,
          'montoCent': companion.montoCent.value,
          'fotoRutaRelativa': companion.fotoRutaRelativa.present ? companion.fotoRutaRelativa.value : null,
        },
        resumen: 'Nueva cotizacin de "${companion.proveedor.value}" por S/ ${(companion.montoCent.value / 100).toStringAsFixed(2)}',
      ),
    );
  }

  Future<bool> updateCotizacion(
    CotizacionesCompanion companion,
    AuditedWriter writer,
  ) async {
    final anterior = await getCotizacionById(companion.id.value);
    final rows = await writer.write<int>(
      action: () => (update(cotizaciones)
            ..where((t) => t.id.equals(companion.id.value)))
          .write(companion.copyWith(actualizadoEn: Value(DateTime.now()))),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Cotizacion',
        entidadId: companion.id.value,
        accion: 'editar',
        valorAnterior: anterior != null
            ? {
                'proveedor': anterior.proveedor,
                'montoCent': anterior.montoCent,
              }
            : null,
        valorNuevo: {
          'proveedor': companion.proveedor.present ? companion.proveedor.value : anterior?.proveedor,
          'montoCent': companion.montoCent.present ? companion.montoCent.value : anterior?.montoCent,
        },
        resumen: 'Edición de cotización de "${companion.proveedor.present ? companion.proveedor.value : (anterior?.proveedor ?? '')}"',
      ),
    );
    return rows > 0;
  }

  /// Elige una cotizacin ganadora para una partida de forma atmica y auditada.
  Future<void> elegirCotizacionGanadora({
    required int partidaId,
    required int cotizacionId,
    required AuditedWriter writer,
  }) async {
    final cotizacion = await getCotizacionById(cotizacionId);
    if (cotizacion == null) return;

    await writer.write<void>(
      action: () async {
        // 1. Desmarcar todas las cotizaciones de la partida
        await (update(cotizaciones)..where((t) => t.partidaId.equals(partidaId)))
            .write(const CotizacionesCompanion(elegida: Value(false)));

        // 2. Marcar la cotizacin elegida
        await (update(cotizaciones)..where((t) => t.id.equals(cotizacionId)))
            .write(const CotizacionesCompanion(elegida: Value(true)));

        // 3. Actualizar la partida con la cotizacin elegida y estado 'adjudicado'
        await (update(partidasProyecto)..where((t) => t.id.equals(partidaId)))
            .write(
          PartidasProyectoCompanion(
            cotizacionElegidaId: Value(cotizacionId),
            estado: const Value('adjudicado'),
            actualizadoEn: Value(DateTime.now()),
          ),
        );
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'PartidaProyecto',
        entidadId: partidaId,
        accion: 'elegir_ganadora',
        valorNuevo: {
          'cotizacionElegidaId': cotizacionId,
          'proveedor': cotizacion.proveedor,
          'montoCent': cotizacion.montoCent,
        },
        resumen: 'Adjudicada cotizacin ganadora de "${cotizacion.proveedor}" (S/ ${(cotizacion.montoCent / 100).toStringAsFixed(2)}) para partida #$partidaId',
      ),
    );
  }

  /// Desmarca la cotizacin ganadora de una partida.
  Future<void> desmarcarCotizacionGanadora({
    required int partidaId,
    required AuditedWriter writer,
  }) async {
    await writer.write<void>(
      action: () async {
        await (update(cotizaciones)..where((t) => t.partidaId.equals(partidaId)))
            .write(const CotizacionesCompanion(elegida: Value(false)));

        await (update(partidasProyecto)..where((t) => t.id.equals(partidaId)))
            .write(
          PartidasProyectoCompanion(
            cotizacionElegidaId: const Value(null),
            estado: const Value('cotizado'),
            actualizadoEn: Value(DateTime.now()),
          ),
        );
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'PartidaProyecto',
        entidadId: partidaId,
        accion: 'desmarcar_ganadora',
        resumen: 'Se desmarc la cotizacin ganadora de la partida #$partidaId',
      ),
    );
  }

  // ==========================================
  // CONSOLIDADO FINANCIERO Y AVANCE
  // ==========================================

  Future<ProyectoAvance> calcularAvanceProyecto(int proyectoId) async {
    final proyecto = await getProyectoById(proyectoId);
    if (proyecto == null) {
      throw Exception('Proyecto #$proyectoId no encontrado');
    }

    final partidasList = await getPartidas(proyectoId);
    final partidaIds = partidasList.map((p) => p.id).toList();

    int totalPresupuestoPartidasCent = 0;
    int totalCotizadoCent = 0;
    int adjudicadas = 0;
    int completadas = 0;

    for (final p in partidasList) {
      totalPresupuestoPartidasCent += p.presupuestoCent;
      if (p.cotizacionElegidaId != null) {
        adjudicadas++;
        final cot = await getCotizacionById(p.cotizacionElegidaId!);
        if (cot != null) {
          totalCotizadoCent += cot.montoCent;
        }
      }
      if (p.estado == 'completado') {
        completadas++;
      }
    }

    // Calcular gasto real ejecutado mediante movimientos vinculados
    int gastadoRealCent = 0;
    if (partidaIds.isNotEmpty) {
      final movsGasto = await (select(movimientos)
            ..where((m) =>
                m.partidaId.isIn(partidaIds) &
                m.anulado.equals(false) &
                m.tipo.equals('gasto')))
          .get();

      for (final m in movsGasto) {
        gastadoRealCent += m.montoCent;
      }
    }

    return ProyectoAvance(
      proyecto: proyecto,
      presupuestoObjetivo: Money.fromCents(proyecto.presupuestoObjetivoCent),
      presupuestoPartidas: Money.fromCents(totalPresupuestoPartidasCent),
      totalCotizado: Money.fromCents(totalCotizadoCent),
      gastadoReal: Money.fromCents(gastadoRealCent),
      totalPartidas: partidasList.length,
      partidasAdjudicadas: adjudicadas,
      partidasCompletadas: completadas,
    );
  }

  Future<PartidaAvance> calcularAvancePartida(int partidaId) async {
    final partida = await getPartidaById(partidaId);
    if (partida == null) {
      throw Exception('Partida #$partidaId no encontrada');
    }

    final cotizacionesList = await getCotizaciones(partidaId);
    Cotizacione? elegida;
    Cotizacione? menor;

    for (final c in cotizacionesList) {
      if (c.elegida) elegida = c;
      if (menor == null || c.montoCent < menor.montoCent) {
        menor = c;
      }
    }

    // Gasto real de la partida
    final movsGasto = await (select(movimientos)
          ..where((m) =>
              m.partidaId.equals(partidaId) &
              m.anulado.equals(false) &
              m.tipo.equals('gasto')))
        .get();

    int gastadoRealCent = 0;
    for (final m in movsGasto) {
      gastadoRealCent += m.montoCent;
    }

    return PartidaAvance(
      partida: partida,
      cotizacionElegida: elegida,
      presupuesto: Money.fromCents(partida.presupuestoCent),
      montoCotizado: elegida != null ? Money.fromCents(elegida.montoCent) : null,
      gastadoReal: Money.fromCents(gastadoRealCent),
      totalCotizaciones: cotizacionesList.length,
      cotizacionMasEconomica: menor,
    );
  }

  // ==========================================
  // MOVIMIENTOS VINCULADOS A PARTIDAS
  // ==========================================

  Stream<List<Movimiento>> watchMovimientosDePartida(int partidaId) {
    return (select(movimientos)
          ..where((m) => m.partidaId.equals(partidaId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Stream<List<Movimiento>> watchMovimientosDelProyecto(int proyectoId) {
    // Escucha cambios en movimientos y filtra los de las partidas del proyecto
    return (select(movimientos)
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .asyncMap((allMovs) async {
      final partidas = await getPartidas(proyectoId);
      final partidaIds = partidas.map((p) => p.id).toSet();
      return allMovs
          .where((m) => m.partidaId != null && partidaIds.contains(m.partidaId!))
          .toList();
    });
  }

  Future<void> vincularMovimientoAPartida(
    int movimientoId,
    int? partidaId,
    AuditedWriter writer,
  ) async {
    final mov = await (select(movimientos)..where((m) => m.id.equals(movimientoId))).getSingleOrNull();
    if (mov == null) return;
    final partida = partidaId != null ? await getPartidaById(partidaId) : null;

    await writer.write<int>(
      action: () => (update(movimientos)..where((m) => m.id.equals(movimientoId))).write(
        MovimientosCompanion(
          partidaId: Value(partidaId),
          actualizadoEn: Value(DateTime.now()),
        ),
      ),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: movimientoId,
        accion: partidaId != null ? 'vincular_partida' : 'desvincular_partida',
        valorAnterior: {'partidaId': mov.partidaId},
        valorNuevo: {'partidaId': partidaId},
        resumen: partidaId != null
            ? 'Movimiento "${mov.descripcion}" vinculado a partida "${partida?.nombre}"'
            : 'Movimiento "${mov.descripcion}" desvinculado de partida',
      ),
    );
  }
}
