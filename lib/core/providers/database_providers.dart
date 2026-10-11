import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos/cuentas_dao.dart';
import '../database/daos/movimientos_dao.dart';
import '../database/daos/categorias_dao.dart';
import '../database/daos/ajustes_dao.dart';
import '../database/daos/gastos_fijos_dao.dart';
import '../database/daos/presupuestos_dao.dart';
import '../audit/audited_writer.dart';
import '../audit/audit_service.dart';

/// Provider singleton de la base de datos SQLite local de Nido.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider de AuditedWriter para mutaciones atómicas con auditoría.
final auditedWriterProvider = Provider<AuditedWriter>((ref) {
  final db = ref.watch(databaseProvider);
  return AuditedWriter(db);
});

/// Provider del servicio de consulta de auditoría.
final auditServiceProvider = Provider<AuditService>((ref) {
  final db = ref.watch(databaseProvider);
  return AuditService(db);
});

// Providers de DAOs
final cuentasDaoProvider = Provider<CuentasDao>((ref) {
  return ref.watch(databaseProvider).cuentasDao;
});

final movimientosDaoProvider = Provider<MovimientosDao>((ref) {
  return ref.watch(databaseProvider).movimientosDao;
});

final categoriasDaoProvider = Provider<CategoriasDao>((ref) {
  return ref.watch(databaseProvider).categoriasDao;
});

final ajustesDaoProvider = Provider<AjustesDao>((ref) {
  return ref.watch(databaseProvider).ajustesDao;
});

final gastosFijosDaoProvider = Provider<GastosFijosDao>((ref) {
  return ref.watch(databaseProvider).gastosFijosDao;
});

final presupuestosDaoProvider = Provider<PresupuestosDao>((ref) {
  return ref.watch(databaseProvider).presupuestosDao;
});