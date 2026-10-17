import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';

/// Tipo de categoría seleccionado para filtrar en la pantalla de gestión:
/// - 'gastoVariable'
/// - 'gastoFijo'
/// - 'ingreso'
/// - 'proyecto'
/// - 'todos'
final categoriasFiltroTipoProvider = StateProvider<String>((ref) => 'gastoVariable');

/// Mostrar solo activas o todas
final categoriasMostrarSoloActivasProvider = StateProvider<bool>((ref) => false);

/// Stream reactivo de categorías filtradas
final categoriasFiltradasStreamProvider = StreamProvider<List<Categoria>>((ref) {
  final dao = ref.watch(categoriasDaoProvider);
  final tipoFiltro = ref.watch(categoriasFiltroTipoProvider);
  final soloActivas = ref.watch(categoriasMostrarSoloActivasProvider);

  final tipoParam = tipoFiltro == 'todos' ? null : tipoFiltro;
  return dao.watchCategorias(tipo: tipoParam, soloActivas: soloActivas);
});
