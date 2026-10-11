import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'audit_entry.dart';

/// Intermediario transaccional obligatorio para escrituras de negocio.
/// Asegura de forma atómica (ACID) que toda mutación quede registrada
/// en la tabla inmutable de Auditoría con el diff JSON correspondiente.
class AuditedWriter {
  AuditedWriter(this.db);

  final AppDatabase db;

  /// Ejecuta [action] dentro de una transacción SQLite y registra la auditoría.
  /// Si ocurre cualquier excepción en [action] o en el registro de auditoría,
  /// toda la transacción se revierte (rollback automático).
  Future<T> write<T>({
    required Future<T> Function() action,
    required FutureOr<AuditEntry> Function(T result) auditBuilder,
  }) async {
    return await db.transaction(() async {
      final result = await action();
      final entry = await auditBuilder(result);

      final now = DateTime.now();
      await db.into(db.auditoria).insert(
            AuditoriaCompanion.insert(
              entidad: entry.entidad,
              entidadId: entry.entidadId,
              accion: entry.accion,
              valorAnteriorJson: Value(
                entry.valorAnterior != null ? jsonEncode(entry.valorAnterior) : null,
              ),
              valorNuevoJson: Value(
                entry.valorNuevo != null ? jsonEncode(entry.valorNuevo) : null,
              ),
              resumen: entry.resumen,
              fechaHora: Value(now),
              creadoEn: Value(now),
            ),
          );

      return result;
    });
  }

  /// Atajo para cuando los datos de auditoría se conocen antes de la acción.
  Future<T> writeWithEntry<T>({
    required Future<T> Function() action,
    required AuditEntry entry,
  }) {
    return write<T>(
      action: action,
      auditBuilder: (_) => entry,
    );
  }
}
