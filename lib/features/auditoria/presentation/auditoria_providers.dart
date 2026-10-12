import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';

/// Filtro de entidad para la bitácora de auditoría (null = todas).
final auditoriaFiltroEntidadProvider = StateProvider<String?>((ref) => null);

/// Filtro de acción para la bitácora de auditoría (null = todas).
final auditoriaFiltroAccionProvider = StateProvider<String?>((ref) => null);

/// Filtro de fecha inicio.
final auditoriaFiltroDesdeProvider = StateProvider<DateTime?>((ref) => null);

/// Filtro de fecha fin.
final auditoriaFiltroHastaProvider = StateProvider<DateTime?>((ref) => null);

/// ID del registro de auditoría seleccionado actualmente para visualización de diff.
final auditoriaSeleccionadaIdProvider = StateProvider<int?>((ref) => null);

/// Stream reactivo de la lista de registros de auditoría filtrados en tiempo real.
final auditoriaListStreamProvider =
    StreamProvider<List<AuditoriaData>>((ref) {
  final service = ref.watch(auditServiceProvider);
  final entidad = ref.watch(auditoriaFiltroEntidadProvider);
  final accion = ref.watch(auditoriaFiltroAccionProvider);
  final desde = ref.watch(auditoriaFiltroDesdeProvider);
  final hasta = ref.watch(auditoriaFiltroHastaProvider);

  return service.watchAuditoria(
    entidad: entidad,
    accion: accion,
    desde: desde,
    hasta: hasta,
    limit: 200,
  );
});

/// Registro de auditoría seleccionado para mostrar en el panel de detalle con diff visual.
final auditoriaSeleccionadaProvider = Provider<AuditoriaData?>((ref) {
  final id = ref.watch(auditoriaSeleccionadaIdProvider);
  final listAsync = ref.watch(auditoriaListStreamProvider);

  return listAsync.maybeWhen(
    data: (items) {
      if (items.isEmpty) return null;
      if (id == null) return items.first;
      return items.firstWhere(
        (it) => it.id == id,
        orElse: () => items.first,
      );
    },
    orElse: () => null,
  );
});