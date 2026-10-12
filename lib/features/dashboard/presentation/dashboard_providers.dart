import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/proyectos_dao.dart';
import '../domain/dashboard_resumen.dart';

/// Helper que calcula el periodo actual en formato 'yyyy-MM'.
String calcularPeriodoActual() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

/// Periodo mensual actualmente seleccionado en el Dashboard ('yyyy-MM').
final dashboardPeriodoSeleccionadoProvider =
    StateProvider<String>((ref) => calcularPeriodoActual());

/// Cantidad de meses para el gráfico de tendencia histórica (6 o 12 meses).
final dashboardMesesTendenciaFiltroProvider = StateProvider<int>((ref) => 6);

/// Stream reactivo del resumen financiero mensual consolidado (con comparativa del mes anterior).
final dashboardResumenStreamProvider =
    StreamProvider<DashboardResumen>((ref) {
  final dao = ref.watch(movimientosDaoProvider);
  final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);
  return dao.watchResumenMensual(periodo);
});

/// Stream reactivo de la distribución de gastos por categoría para el mes seleccionado.
final dashboardGastosCategoriasStreamProvider =
    StreamProvider<List<CategoriaGastoItem>>((ref) {
  final dao = ref.watch(movimientosDaoProvider);
  final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);
  return dao.watchGastosPorCategoria(periodo);
});

/// Stream reactivo de la tendencia histórica (6 o 12 meses) con fl_chart.
final dashboardTendenciaStreamProvider =
    StreamProvider<List<TendenciaMesItem>>((ref) {
  final dao = ref.watch(movimientosDaoProvider);
  final meses = ref.watch(dashboardMesesTendenciaFiltroProvider);
  final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);
  return dao.watchTendenciaMeses(
    cantidadMeses: meses,
    periodoFin: periodo,
  );
});

/// Stream reactivo de los pagos de gastos fijos pendientes o vencidos del mes.
final dashboardVencimientosStreamProvider =
    StreamProvider<List<GastosFijosPago>>((ref) {
  final dao = ref.watch(gastosFijosDaoProvider);
  final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);
  return dao.watchPagosDelPeriodo(periodo);
});

/// DTO para el avance de presupuestos en el dashboard
class DashboardPresupuestoItem {
  const DashboardPresupuestoItem({
    required this.categoriaId,
    required this.categoriaNombre,
    required this.presupuestoCent,
    required this.gastadoCent,
  });

  final int categoriaId;
  final String categoriaNombre;
  final int presupuestoCent;
  final int gastadoCent;

  double get porcentajeEjecutado =>
      presupuestoCent > 0 ? (gastadoCent / presupuestoCent) : 0.0;
  bool get esAlerta80 => porcentajeEjecutado >= 0.8 && porcentajeEjecutado < 1.0;
  bool get esAlerta100 => porcentajeEjecutado >= 1.0;
}

/// Stream reactivo del estado de los presupuestos mensuales asignados para el mes seleccionado.
final dashboardPresupuestosStreamProvider =
    StreamProvider<List<DashboardPresupuestoItem>>((ref) async* {
  final presupuestosDao = ref.watch(presupuestosDaoProvider);
  final categoriasDao = ref.watch(categoriasDaoProvider);
  final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);

  await for (final presupuestos
      in presupuestosDao.watchPresupuestosDelPeriodo(periodo)) {
    final categorias = await categoriasDao.getCategorias();
    final catMap = {for (final c in categorias) c.id: c.nombre};

    final List<DashboardPresupuestoItem> items = [];
    for (final p in presupuestos) {
      final gastado =
          await presupuestosDao.calcularGastoCategoriaEnPeriodo(p.categoriaId, periodo);
      items.add(
        DashboardPresupuestoItem(
          categoriaId: p.categoriaId,
          categoriaNombre: catMap[p.categoriaId] ?? 'Categoría #${p.categoriaId}',
          presupuestoCent: p.montoCent,
          gastadoCent: gastado,
        ),
      );
    }
    // Ordenar por porcentaje de ejecución descendente para resaltar los más comprometidos
    items.sort((a, b) => b.porcentajeEjecutado.compareTo(a.porcentajeEjecutado));
    yield items;
  }
});

/// DTO para el resumen de proyectos activos en el dashboard
class DashboardProyectoItem {
  const DashboardProyectoItem({
    required this.proyecto,
    required this.avance,
  });

  final Proyecto proyecto;
  final ProyectoAvance avance;
}

/// Stream reactivo de proyectos en ejecución o activos con su avance financiero.
final dashboardProyectosActivosStreamProvider =
    StreamProvider<List<DashboardProyectoItem>>((ref) async* {
  final proyectosDao = ref.watch(proyectosDaoProvider);

  await for (final proyectos in proyectosDao.watchProyectos()) {
    final activos = proyectos
        .where((p) => p.estado == 'enEjecucion' || p.estado == 'cotizando')
        .toList();

    final List<DashboardProyectoItem> items = [];
    for (final p in activos) {
      final avance = await proyectosDao.calcularAvanceProyecto(p.id);
      items.add(DashboardProyectoItem(proyecto: p, avance: avance));
    }
    yield items;
  }
});