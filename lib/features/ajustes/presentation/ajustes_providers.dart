import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../data/respaldo_service.dart';

/// Fecha ISO del último respaldo registrado.
final ultimoRespaldoFechaProvider = FutureProvider<String?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.ajustesDao.getValor(RespaldoService.keyUltimoRespaldo);
});

/// Días transcurridos desde el último respaldo registrado.
final diasDesdeUltimoRespaldoProvider = FutureProvider<int?>((ref) async {
  final db = ref.watch(databaseProvider);
  return RespaldoService.diasDesdeUltimoRespaldo(db.ajustesDao);
});

/// Determina si la aplicación debe mostrar el banner de alerta/recordatorio de respaldo.
final requiereRecordatorioRespaldoProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  return RespaldoService.requiereRecordatorioRespaldo(db.ajustesDao);
});
