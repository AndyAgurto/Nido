import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cuentas_table.dart';
import '../tables/movimientos_table.dart';
import '../tables/categorias_table.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

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
}