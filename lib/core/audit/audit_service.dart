import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Servicio para consultar la bitácora de auditoría inmutable de Nido.
class AuditService {
  AuditService(this.db);

  final AppDatabase db;

  /// Obtiene un stream reactivo de registros de auditoría filtrados.
  Stream<List<AuditoriaData>> watchAuditoria({
    String? entidad,
    int? entidadId,
    String? accion,
    DateTime? desde,
    DateTime? hasta,
    int limit = 100,
    int offset = 0,
  }) {
    final query = _buildQuery(
      entidad: entidad,
      entidadId: entidadId,
      accion: accion,
      desde: desde,
      hasta: hasta,
      limit: limit,
      offset: offset,
    );
    return query.watch();
  }

  /// Obtiene la lista de registros de auditoría filtrados una sola vez.
  Future<List<AuditoriaData>> getAuditoria({
    String? entidad,
    int? entidadId,
    String? accion,
    DateTime? desde,
    DateTime? hasta,
    int limit = 100,
    int offset = 0,
  }) {
    final query = _buildQuery(
      entidad: entidad,
      entidadId: entidadId,
      accion: accion,
      desde: desde,
      hasta: hasta,
      limit: limit,
      offset: offset,
    );
    return query.get();
  }

  SimpleSelectStatement<$AuditoriaTable, AuditoriaData> _buildQuery({
    String? entidad,
    int? entidadId,
    String? accion,
    DateTime? desde,
    DateTime? hasta,
    int limit = 100,
    int offset = 0,
  }) {
    var query = db.select(db.auditoria);

    if (entidad != null) {
      query = query..where((t) => t.entidad.equals(entidad));
    }
    if (entidadId != null) {
      query = query..where((t) => t.entidadId.equals(entidadId));
    }
    if (accion != null) {
      query = query..where((t) => t.accion.equals(accion));
    }
    if (desde != null) {
      query = query..where((t) => t.fechaHora.isBiggerOrEqualValue(desde));
    }
    if (hasta != null) {
      query = query..where((t) => t.fechaHora.isSmallerOrEqualValue(hasta));
    }

    query = query
      ..orderBy([(t) => OrderingTerm.desc(t.fechaHora)])
      ..limit(limit, offset: offset);

    return query;
  }
}