import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cuentas_table.dart';
import '../tables/movimientos_table.dart';
import '../tables/categorias_table.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';
import '../../money/money.dart';
import '../../../features/dashboard/domain/dashboard_resumen.dart';

part 'movimientos_dao.g.dart';

/// DAO para operaciones de Movimientos y anulación lógica con auditoría.
@DriftAccessor(tables: [Movimientos, Cuentas, Categorias])
class MovimientosDao extends DatabaseAccessor<AppDatabase>
    with _$MovimientosDaoMixin {
  MovimientosDao(super.db);

  Stream<List<Movimiento>> watchMovimientos({
    int? cuentaId,
    int? categoriaId,
    String? tipo,
    DateTime? desde,
    DateTime? hasta,
    String? busqueda,
    bool incluirAnulados = false,
  }) {
    var query = select(movimientos);

    if (!incluirAnulados) {
      query = query..where((t) => t.anulado.equals(false));
    }
    if (cuentaId != null) {
      query = query
        ..where(
            (t) => t.cuentaOrigenId.equals(cuentaId) | t.cuentaDestinoId.equals(cuentaId));
    }
    if (categoriaId != null) {
      query = query..where((t) => t.categoriaId.equals(categoriaId));
    }
    if (tipo != null) {
      query = query..where((t) => t.tipo.equals(tipo));
    }
    if (desde != null) {
      query = query..where((t) => t.fecha.isBiggerOrEqualValue(desde));
    }
    if (hasta != null) {
      query = query..where((t) => t.fecha.isSmallerOrEqualValue(hasta));
    }
    if (busqueda != null && busqueda.trim().isNotEmpty) {
      final term = '%${busqueda.trim()}%';
      query = query..where((t) => t.descripcion.like(term) | (t.notas.isNotNull() & t.notas.like(term)));
    }

    query = query..orderBy([(t) => OrderingTerm.desc(t.fecha)]);
    return query.watch();
  }

  Future<Movimiento?> getMovimientoById(int id) {
    return (select(movimientos)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> registrarMovimiento(
    MovimientosCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(movimientos).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'tipo': companion.tipo.value,
          'montoCent': companion.montoCent.value,
          'descripcion': companion.descripcion.value,
          'cuentaOrigenId': companion.cuentaOrigenId.value,
          'cuentaDestinoId': companion.cuentaDestinoId.value,
          'categoriaId': companion.categoriaId.value,
        },
        resumen: 'Registro de ${companion.tipo.value}: "${companion.descripcion.value}" por ${companion.montoCent.value} céntimos',
      ),
    );
  }

  Future<bool> anularMovimiento(
    int id, {
    required String motivo,
    required AuditedWriter writer,
  }) async {
    final original = await getMovimientoById(id);
    if (original == null) return false;
    if (original.anulado) return true;

    final now = DateTime.now();

    return writer.write<bool>(
      action: () async {
        final rows = await (update(movimientos)..where((t) => t.id.equals(id))).write(
          MovimientosCompanion(
            anulado: const Value(true),
            anuladoEn: Value(now),
            motivoAnulacion: Value(motivo),
            actualizadoEn: Value(now),
          ),
        );
        return rows > 0;
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'anular',
        valorAnterior: {
          'anulado': false,
          'descripcion': original.descripcion,
          'montoCent': original.montoCent,
        },
        valorNuevo: {
          'anulado': true,
          'anuladoEn': now.toIso8601String(),
          'motivoAnulacion': motivo,
        },
        resumen: 'Anulación de movimiento #$id ("${original.descripcion}"): $motivo',
      ),
    );
  }

  Future<bool> restaurarMovimiento(
    int id, {
    required AuditedWriter writer,
  }) async {
    final original = await getMovimientoById(id);
    if (original == null || !original.anulado) return false;

    final now = DateTime.now();

    return writer.write<bool>(
      action: () async {
        final rows = await (update(movimientos)..where((t) => t.id.equals(id))).write(
          MovimientosCompanion(
            anulado: const Value(false),
            anuladoEn: const Value(null),
            motivoAnulacion: const Value(null),
            actualizadoEn: Value(now),
          ),
        );
        return rows > 0;
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'restaurar',
        valorAnterior: {
          'anulado': true,
          'motivoAnulacion': original.motivoAnulacion,
        },
        valorNuevo: {
          'anulado': false,
        },
        resumen: 'Restauración de movimiento #$id ("${original.descripcion}")',
      ),
    );
  }

  // ==========================================
  // AGREGACIONES FINANCIERAS (DASHBOARD & REPORTES)
  // ==========================================

  /// Calcula el resumen financiero consolidado para un mes ('yyyy-MM')
  /// y opcionalmente incluye la comparativa frente al mes anterior.
  Future<DashboardResumen> calcularResumenMensual(
    String periodo, {
    bool incluirMesAnterior = true,
  }) async {
    final inicio = _inicioMes(periodo);
    final fin = _finMes(periodo);

    final movs = await (select(movimientos)
          ..where((t) =>
              t.anulado.equals(false) &
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerOrEqualValue(fin)))
        .get();

    int ingresosCent = 0;
    int gastosFijosCent = 0;
    int gastosVariablesCent = 0;
    int aportesProyectosCent = 0;

    for (final m in movs) {
      if (m.tipo == 'ingreso') {
        ingresosCent += m.montoCent;
      } else if (m.tipo == 'gasto') {
        if (m.partidaId != null) {
          aportesProyectosCent += m.montoCent;
        } else if (m.gastoFijoPagoId != null) {
          gastosFijosCent += m.montoCent;
        } else {
          gastosVariablesCent += m.montoCent;
        }
      }
    }

    DashboardResumen? mesAnteriorResumen;
    if (incluirMesAnterior) {
      final perAnterior = _periodoAnterior(periodo);
      mesAnteriorResumen = await calcularResumenMensual(
        perAnterior,
        incluirMesAnterior: false,
      );
    }

    return DashboardResumen(
      periodo: periodo,
      ingresos: Money.fromCents(ingresosCent),
      gastosFijos: Money.fromCents(gastosFijosCent),
      gastosVariables: Money.fromCents(gastosVariablesCent),
      aportesProyectos: Money.fromCents(aportesProyectosCent),
      mesAnterior: mesAnteriorResumen,
    );
  }

  /// Stream reactivo del resumen financiero mensual.
  Stream<DashboardResumen> watchResumenMensual(String periodo) {
    return (select(movimientos)..where((t) => t.anulado.equals(false)))
        .watch()
        .asyncMap((_) => calcularResumenMensual(periodo));
  }

  /// Obtiene la distribución de gastos por categoría en un periodo mensual ('yyyy-MM').
  Future<List<CategoriaGastoItem>> obtenerGastosPorCategoria(String periodo) async {
    final inicio = _inicioMes(periodo);
    final fin = _finMes(periodo);

    final movsGasto = await (select(movimientos)
          ..where((t) =>
              t.anulado.equals(false) &
              t.tipo.equals('gasto') &
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerOrEqualValue(fin)))
        .get();

    if (movsGasto.isEmpty) return const [];

    final todasCategorias = await select(categorias).get();
    final catMap = {for (final c in todasCategorias) c.id: c};

    final Map<int?, int> acumuladoPorCat = {};
    int totalGastosCent = 0;

    for (final m in movsGasto) {
      totalGastosCent += m.montoCent;
      acumuladoPorCat[m.categoriaId] =
          (acumuladoPorCat[m.categoriaId] ?? 0) + m.montoCent;
    }

    final List<CategoriaGastoItem> items = [];
    acumuladoPorCat.forEach((catId, montoCent) {
      final cat = catId != null ? catMap[catId] : null;
      final pct = totalGastosCent > 0 ? (montoCent / totalGastosCent) : 0.0;
      items.add(
        CategoriaGastoItem(
          categoriaId: catId ?? 0,
          nombre: cat?.nombre ?? 'Sin Categoría',
          icono: cat?.icono,
          color: cat?.color,
          monto: Money.fromCents(montoCent),
          porcentaje: pct,
        ),
      );
    });

    items.sort((a, b) => b.monto.cents.compareTo(a.monto.cents));
    return items;
  }

  /// Stream reactivo de la distribución de gastos por categoría.
  Stream<List<CategoriaGastoItem>> watchGastosPorCategoria(String periodo) {
    return (select(movimientos)..where((t) => t.anulado.equals(false)))
        .watch()
        .asyncMap((_) => obtenerGastosPorCategoria(periodo));
  }

  /// Obtiene la serie histórica de tendencia para los últimos [cantidadMeses] meses (6 o 12)
  /// terminando en [periodoFin] (por defecto el mes actual).
  Future<List<TendenciaMesItem>> obtenerTendenciaMeses({
    int cantidadMeses = 6,
    String? periodoFin,
  }) async {
    final perFin = periodoFin ?? _periodoActual();
    final fechaFin = _inicioMes(perFin);

    // Generar lista de periodos de más antiguo a más reciente
    final List<DateTime> meses = [];
    for (int i = cantidadMeses - 1; i >= 0; i--) {
      meses.add(DateTime(fechaFin.year, fechaFin.month - i, 1));
    }

    final fechaInicioRango = meses.first;
    final fechaFinRango = DateTime(
      fechaFin.year,
      fechaFin.month + 1,
      0,
      23,
      59,
      59,
      999,
    );

    // Consulta en bloque de todos los movimientos del rango para óptimo rendimiento
    final movsRango = await (select(movimientos)
          ..where((t) =>
              t.anulado.equals(false) &
              t.fecha.isBiggerOrEqualValue(fechaInicioRango) &
              t.fecha.isSmallerOrEqualValue(fechaFinRango)))
        .get();

    final List<TendenciaMesItem> resultado = [];

    for (final mFecha in meses) {
      final pKey = '${mFecha.year}-${mFecha.month.toString().padLeft(2, '0')}';
      final ini = DateTime(mFecha.year, mFecha.month, 1);
      final fin = DateTime(mFecha.year, mFecha.month + 1, 0, 23, 59, 59, 999);

      int ingCent = 0;
      int gasCent = 0;

      for (final mov in movsRango) {
        if (mov.fecha.isAfter(ini.subtract(const Duration(milliseconds: 1))) &&
            mov.fecha.isBefore(fin.add(const Duration(milliseconds: 1)))) {
          if (mov.tipo == 'ingreso') {
            ingCent += mov.montoCent;
          } else if (mov.tipo == 'gasto') {
            gasCent += mov.montoCent;
          }
        }
      }

      resultado.add(
        TendenciaMesItem(
          periodo: pKey,
          etiqueta: _etiquetaMes(mFecha),
          ingresos: Money.fromCents(ingCent),
          gastos: Money.fromCents(gasCent),
          disponible: Money.fromCents(ingCent - gasCent),
        ),
      );
    }

    return resultado;
  }

  /// Stream reactivo de la tendencia histórica de meses.
  Stream<List<TendenciaMesItem>> watchTendenciaMeses({
    int cantidadMeses = 6,
    String? periodoFin,
  }) {
    return (select(movimientos)..where((t) => t.anulado.equals(false)))
        .watch()
        .asyncMap(
          (_) => obtenerTendenciaMeses(
            cantidadMeses: cantidadMeses,
            periodoFin: periodoFin,
          ),
        );
  }

  // --- MÉTODOS AUXILIARES DE FECHAS ---

  static String _periodoActual() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  static DateTime _inicioMes(String periodo) {
    final parts = periodo.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
  }

  static DateTime _finMes(String periodo) {
    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    return DateTime(anio, mes + 1, 0, 23, 59, 59, 999);
  }

  static String _periodoAnterior(String periodo) {
    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final prev = DateTime(anio, mes - 1, 1);
    return '${prev.year}-${prev.month.toString().padLeft(2, '0')}';
  }

  static String _etiquetaMes(DateTime fecha) {
    const meses = [
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OCT',
      'NOV',
      'DIC'
    ];
    return meses[fecha.month - 1];
  }
}