import '../../../core/money/money.dart';

/// Modelo de dominio con el resumen financiero consolidado para un periodo mensual (yyyy-MM).
class DashboardResumen {
  const DashboardResumen({
    required this.periodo,
    required this.ingresos,
    required this.gastosFijos,
    required this.gastosVariables,
    required this.aportesProyectos,
    this.mesAnterior,
  });

  final String periodo;
  final Money ingresos;
  final Money gastosFijos;
  final Money gastosVariables;
  final Money aportesProyectos;
  final DashboardResumen? mesAnterior;

  /// Total de gastos del mes (Gastos Fijos + Gastos Variables + Aportes a Proyectos).
  Money get gastosTotales => gastosFijos + gastosVariables + aportesProyectos;

  /// Dinero disponible del mes (Regla de negocio de Nido: Ingresos - Fijos - Variables - Proyectos).
  Money get disponible => ingresos - gastosTotales;

  /// Tasa o porcentaje del disponible frente a los ingresos totales (0.0 a 1.0).
  double get porcentajeDisponible {
    if (ingresos.cents <= 0) return 0.0;
    return disponible.cents / ingresos.cents;
  }

  // --- COMPARACIONES FRENTE AL MES ANTERIOR ---

  /// Diferencia absoluta de dinero disponible frente al mes anterior.
  Money get deltaDisponible =>
      disponible - (mesAnterior?.disponible ?? Money.zero);

  /// Diferencia absoluta de ingresos frente al mes anterior.
  Money get deltaIngresos =>
      ingresos - (mesAnterior?.ingresos ?? Money.zero);

  /// Diferencia absoluta de gastos totales frente al mes anterior.
  Money get deltaGastos =>
      gastosTotales - (mesAnterior?.gastosTotales ?? Money.zero);

  /// Variación porcentual del disponible frente al mes anterior.
  /// Retorna null si no hay datos del mes anterior o si el disponible anterior fue 0.
  double? get variacionDisponiblePct {
    final ant = mesAnterior?.disponible.cents;
    if (ant == null || ant == 0) return null;
    return (disponible.cents - ant) / ant.abs();
  }

  /// Variación porcentual de ingresos frente al mes anterior.
  double? get variacionIngresosPct {
    final ant = mesAnterior?.ingresos.cents;
    if (ant == null || ant == 0) return null;
    return (ingresos.cents - ant) / ant.abs();
  }

  /// Variación porcentual de gastos totales frente al mes anterior.
  double? get variacionGastosPct {
    final ant = mesAnterior?.gastosTotales.cents;
    if (ant == null || ant == 0) return null;
    return (gastosTotales.cents - ant) / ant.abs();
  }
}

/// Elemento del desglose de gastos por categoría en un periodo mensual.
class CategoriaGastoItem {
  const CategoriaGastoItem({
    required this.categoriaId,
    required this.nombre,
    this.icono,
    this.color,
    required this.monto,
    required this.porcentaje,
  });

  final int categoriaId;
  final String nombre;
  final String? icono;
  final String? color;
  final Money monto;
  final double porcentaje; // Entre 0.0 y 1.0
}

/// Punto de datos para la tendencia mensual (6 o 12 meses).
class TendenciaMesItem {
  const TendenciaMesItem({
    required this.periodo,
    required this.etiqueta,
    required this.ingresos,
    required this.gastos,
    required this.disponible,
  });

  final String periodo; // yyyy-MM
  final String etiqueta; // ej: 'MAY', 'JUN'
  final Money ingresos;
  final Money gastos;
  final Money disponible;
}