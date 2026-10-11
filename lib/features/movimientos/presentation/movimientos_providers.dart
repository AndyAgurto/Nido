import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';

/// Estado inmutable de los filtros aplicables a la lista de movimientos.
class MovimientosFiltroState {
  const MovimientosFiltroState({
    this.tipo,
    this.cuentaId,
    this.categoriaId,
    required this.mes,
    this.busqueda = '',
    this.incluirAnulados = false,
  });

  final String? tipo;
  final int? cuentaId;
  final int? categoriaId;
  final DateTime mes;
  final String busqueda;
  final bool incluirAnulados;

  DateTime get fechaInicio => DateTime(mes.year, mes.month, 1);
  DateTime get fechaFin => DateTime(mes.year, mes.month + 1, 0, 23, 59, 59);

  MovimientosFiltroState copyWith({
    String? tipo,
    bool clearTipo = false,
    int? cuentaId,
    bool clearCuenta = false,
    int? categoriaId,
    bool clearCategoria = false,
    DateTime? mes,
    String? busqueda,
    bool? incluirAnulados,
  }) {
    return MovimientosFiltroState(
      tipo: clearTipo ? null : (tipo ?? this.tipo),
      cuentaId: clearCuenta ? null : (cuentaId ?? this.cuentaId),
      categoriaId: clearCategoria ? null : (categoriaId ?? this.categoriaId),
      mes: mes ?? this.mes,
      busqueda: busqueda ?? this.busqueda,
      incluirAnulados: incluirAnulados ?? this.incluirAnulados,
    );
  }
}

/// Notifier para la gestión de los filtros de movimientos.
class MovimientosFiltrosNotifier extends StateNotifier<MovimientosFiltroState> {
  MovimientosFiltrosNotifier()
      : super(
          MovimientosFiltroState(
            mes: DateTime(DateTime.now().year, DateTime.now().month),
          ),
        );

  void setTipo(String? tipo) {
    if (tipo == null) {
      state = state.copyWith(clearTipo: true);
    } else {
      state = state.copyWith(tipo: tipo);
    }
  }

  void setCuenta(int? cuentaId) {
    if (cuentaId == null) {
      state = state.copyWith(clearCuenta: true);
    } else {
      state = state.copyWith(cuentaId: cuentaId);
    }
  }

  void setCategoria(int? categoriaId) {
    if (categoriaId == null) {
      state = state.copyWith(clearCategoria: true);
    } else {
      state = state.copyWith(categoriaId: categoriaId);
    }
  }

  void setMes(DateTime mes) {
    state = state.copyWith(mes: DateTime(mes.year, mes.month));
  }

  void avanzarMes() {
    state = state.copyWith(mes: DateTime(state.mes.year, state.mes.month + 1));
  }

  void retrocederMes() {
    state = state.copyWith(mes: DateTime(state.mes.year, state.mes.month - 1));
  }

  void setBusqueda(String texto) {
    state = state.copyWith(busqueda: texto);
  }

  void toggleIncluirAnulados() {
    state = state.copyWith(incluirAnulados: !state.incluirAnulados);
  }

  void limpiarFiltros() {
    state = MovimientosFiltroState(
      mes: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }
}

final movimientosFiltrosProvider =
    StateNotifierProvider<MovimientosFiltrosNotifier, MovimientosFiltroState>(
  (ref) => MovimientosFiltrosNotifier(),
);

/// Stream reactivo de movimientos filtrados.
final movimientosFiltradosStreamProvider =
    StreamProvider<List<Movimiento>>((ref) {
  final dao = ref.watch(movimientosDaoProvider);
  final filtros = ref.watch(movimientosFiltrosProvider);

  return dao.watchMovimientos(
    tipo: filtros.tipo,
    cuentaId: filtros.cuentaId,
    categoriaId: filtros.categoriaId,
    desde: filtros.fechaInicio,
    hasta: filtros.fechaFin,
    busqueda: filtros.busqueda.isEmpty ? null : filtros.busqueda,
    incluirAnulados: filtros.incluirAnulados,
  );
});

/// Movimiento actualmente seleccionado en el panel master-detail.
final movimientoSeleccionadoIdProvider = StateProvider<int?>((ref) => null);

/// Stream reactivo de cuentas activas para selección en movimientos.
final cuentasActivasStreamProvider = StreamProvider<List<Cuenta>>((ref) {
  final dao = ref.watch(cuentasDaoProvider);
  return dao.watchCuentasActivas();
});

/// Mapa de categorías activas para resolución rápida O(1).
final categoriasMapProvider = StreamProvider<Map<int, Categoria>>((ref) {
  final dao = ref.watch(categoriasDaoProvider);
  return dao.watchCategorias(soloActivas: false).map((list) {
    return {for (final c in list) c.id: c};
  });
});

/// Mapa de cuentas para resolución rápida O(1).
final cuentasMapProvider = StreamProvider<Map<int, Cuenta>>((ref) {
  final dao = ref.watch(cuentasDaoProvider);
  return dao.watchCuentasActivas().map((list) {
    return {for (final c in list) c.id: c};
  });
});