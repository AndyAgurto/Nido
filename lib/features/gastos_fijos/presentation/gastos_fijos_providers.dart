import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';

/// Periodo actual de consulta y control de pagos fijos (formato 'yyyy-MM').
final periodoGastosFijosProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM').format(DateTime.now());
});

/// Stream de plantillas de gastos fijos activas.
final plantillasGastosFijosStreamProvider =
    StreamProvider<List<GastosFijo>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  return dao.watchGastosFijosActivos();
});

/// Mapa de plantillas de gastos fijos para lookup rápido por ID.
final plantillasGastosMapProvider = StreamProvider<Map<int, GastosFijo>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  return dao.watchGastosFijosActivos().map((list) {
    return {for (final p in list) p.id: p};
  });
});

/// Stream de plantillas de ingresos fijos activas.
final plantillasIngresosFijosStreamProvider =
    StreamProvider<List<IngresosFijo>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  return dao.watchIngresosFijosActivos();
});

/// Stream de pagos (instancias mensuales de gastos fijos) del periodo seleccionado.
final pagosPeriodoStreamProvider = StreamProvider<List<GastosFijosPago>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  final periodo = ref.watch(periodoGastosFijosProvider);
  return dao.watchPagosDelPeriodo(periodo);
});

/// Stream de cobros (instancias mensuales de ingresos fijos) del periodo seleccionado.
final cobrosPeriodoStreamProvider =
    StreamProvider<List<IngresosFijosCobro>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  final periodo = ref.watch(periodoGastosFijosProvider);
  return dao.watchCobrosDelPeriodo(periodo);
});