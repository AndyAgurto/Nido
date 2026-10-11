import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/presupuestos_table.dart';
import '../tables/categorias_table.dart';
import '../tables/movimientos_table.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

part 'presupuestos_dao.g.dart';

/// DAO para presupuestos mensuales por categoría y análisis de ejecución.
@DriftAccessor(tables: [PresupuestosMensuales, Categorias, Movimientos])
class PresupuestosDao extends DatabaseAccessor<AppDatabase>
    with _$PresupuestosDaoMixin {
  PresupuestosDao(super.db);

  Stream<List<PresupuestosMensuale>> watchPresupuestosDelPeriodo(String periodo) {
    return (select(presupuestosMensuales)
          ..where((t) => t.periodo.equals(periodo)))
        .watch();
  }

  Future<List<PresupuestosMensuale>> getPresupuestosDelPeriodo(String periodo) {
    return (select(presupuestosMensuales)
          ..where((t) => t.periodo.equals(periodo)))
        .get();
  }

  /// Establece o actualiza el presupuesto de una categoría para un mes específico.
  Future<void> setPresupuesto({
    required String periodo,
    required int categoriaId,
    required int montoCent,
    required AuditedWriter writer,
  }) {
    return writer.write<void>(
      action: () async {
        await into(presupuestosMensuales).insertOnConflictUpdate(
          PresupuestosMensualesCompanion.insert(
            periodo: periodo,
            categoriaId: categoriaId,
            montoCent: montoCent,
            actualizadoEn: Value(DateTime.now()),
          ),
        );
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'PresupuestosMensuales',
        entidadId: categoriaId,
        accion: 'editar',
        valorNuevo: {
          'periodo': periodo,
          'categoriaId': categoriaId,
          'montoCent': montoCent,
        },
        resumen: 'Presupuesto asignado para categoría #$categoriaId en $periodo: $montoCent céntimos',
      ),
    );
  }

  /// Copia la asignación presupuestaria de un mes anterior a un mes destino.
  Future<int> copiarPresupuestosDelMesAnterior({
    required String periodoOrigen,
    required String periodoDestino,
    required AuditedWriter writer,
  }) async {
    final anteriores = await getPresupuestosDelPeriodo(periodoOrigen);
    int copiados = 0;

    for (final p in anteriores) {
      // Solo insertamos si aún no existe en el periodo destino
      final existente = await (select(presupuestosMensuales)
            ..where((t) =>
                t.periodo.equals(periodoDestino) &
                t.categoriaId.equals(p.categoriaId)))
          .getSingleOrNull();

      if (existente == null) {
        await setPresupuesto(
          periodo: periodoDestino,
          categoriaId: p.categoriaId,
          montoCent: p.montoCent,
          writer: writer,
        );
        copiados++;
      }
    }

    return copiados;
  }

  /// Calcula el monto total gastado en una categoría para un periodo (yyyy-MM).
  Future<int> calcularGastoCategoriaEnPeriodo(int categoriaId, String periodo) async {
    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final inicioMes = DateTime(anio, mes, 1);
    final finMes = DateTime(anio, mes + 1, 0, 23, 59, 59);

    final movs = await (select(movimientos)
          ..where((t) =>
              t.anulado.equals(false) &
              t.tipo.equals('gasto') &
              t.categoriaId.equals(categoriaId) &
              t.fecha.isBiggerOrEqualValue(inicioMes) &
              t.fecha.isSmallerOrEqualValue(finMes)))
        .get();

    int totalCent = 0;
    for (final m in movs) {
      totalCent += m.montoCent;
    }
    return totalCent;
  }
}