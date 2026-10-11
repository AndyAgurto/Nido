import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';

/// Stream reactivo de cuentas activas.
final cuentasActivasStreamProvider = StreamProvider<List<Cuenta>>((ref) {
  final dao = ref.watch(cuentasDaoProvider);
  return dao.watchCuentasActivas();
});

/// Future provider para el saldo calculado de una cuenta específica.
final saldoCuentaProvider = FutureProvider.family<Money, int>((ref, cuentaId) async {
  final dao = ref.watch(cuentasDaoProvider);
  // Escuchamos movimientos para recalcular reactivamente
  ref.watch(movimientosDaoProvider);
  return dao.calcularSaldoCuenta(cuentaId);
});

/// Saldo total combinado de todas las cuentas activas.
final dineroTotalActualProvider = FutureProvider<Money>((ref) async {
  final dao = ref.watch(cuentasDaoProvider);
  ref.watch(movimientosDaoProvider);
  return dao.calcularDineroActualTotal();
});

/// Cuenta actualmente seleccionada en el panel maestro de tablet.
final cuentaSeleccionadaIdProvider = StateProvider<int?>((ref) => null);