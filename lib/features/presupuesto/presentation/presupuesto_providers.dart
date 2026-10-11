import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';

/// Periodo actual de presupuesto (formato 'yyyy-MM').
final periodoPresupuestoProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM').format(DateTime.now());
});

/// DTO con el cálculo de ejecución presupuestaria para una categoría.
class CategoriaPresupuestoItem {
  const CategoriaPresupuestoItem({
    required this.categoria,
    required this.presupuestado,
    required this.gastado,
  });

  final Categoria categoria;
  final Money presupuestado;
  final Money gastado;

  Money get restante => presupuestado - gastado;

  double get porcentaje {
    if (presupuestado.cents <= 0) {
      return gastado.cents > 0 ? 1.0 : 0.0;
    }
    return gastado.cents / presupuestado.cents;
  }

  bool get tienePresupuesto => presupuestado.cents > 0;
  bool get alerta80 => porcentaje >= 0.8 && porcentaje < 1.0;
  bool get alerta100 => porcentaje >= 1.0;
}

/// Provider reactivo de la lista de categorías de gasto y su ejecución presupuestaria.
final presupuestosItemsProvider =
    FutureProvider<List<CategoriaPresupuestoItem>>((ref) async {
  final periodo = ref.watch(periodoPresupuestoProvider);
  final categoriasDao = ref.watch(categoriasDaoProvider);
  final presupuestosDao = ref.watch(presupuestosDaoProvider);
  // Escuchamos movimientos para reactividad inmediata al registrar o anular
  ref.watch(movimientosDaoProvider);

  final categoriasGasto = await categoriasDao.getCategorias(tipo: 'gasto');
  final presupuestosList =
      await presupuestosDao.getPresupuestosDelPeriodo(periodo);
  final mapPresupuestos = {
    for (final p in presupuestosList) p.categoriaId: p.montoCent
  };

  final items = <CategoriaPresupuestoItem>[];

  for (final cat in categoriasGasto) {
    final montoPresupuestadoCent = mapPresupuestos[cat.id] ?? 0;
    final montoGastadoCent =
        await presupuestosDao.calcularGastoCategoriaEnPeriodo(cat.id, periodo);

    items.add(
      CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.fromCents(montoPresupuestadoCent),
        gastado: Money.fromCents(montoGastadoCent),
      ),
    );
  }

  // Ordenar: primero los presupuestados con mayor porcentaje de ejecución
  items.sort((a, b) {
    if (a.tienePresupuesto && !b.tienePresupuesto) return -1;
    if (!a.tienePresupuesto && b.tienePresupuesto) return 1;
    return b.porcentaje.compareTo(a.porcentaje);
  });

  return items;
});