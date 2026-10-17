import '../../../shared/widgets/empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../core/widgets/master_detail_layout.dart';
import 'auditoria_providers.dart';
import 'widgets/auditoria_diff_viewer.dart';

/// Pantalla de Bitácora de Auditoría inmutable de solo lectura.
/// Diseñada con layout Master-Detail para Tablet.
class AuditoriaPage extends ConsumerWidget {
  const AuditoriaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 720;
    final listaAsync = ref.watch(auditoriaListStreamProvider);
    final seleccionado = ref.watch(auditoriaSeleccionadaProvider);

    return Scaffold(
      appBar: isMobile ? null : AppBar(
        title: const Text("Auditoría"),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera institucional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      children: [
                        const Icon(Icons.history_toggle_off_rounded, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'Bitácora de Auditoría',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Trazabilidad completa, inmutable y de solo lectura de todas las operaciones',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        '100% INMUTABLE',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filtros rápidos
            _buildBarraFiltros(ref, theme),
            const SizedBox(height: 16),

            // Contenedor Master-Detail
            Expanded(
              child: MasterDetailLayout(
                masterWidth: 420,
                master: _buildMasterList(listaAsync, ref, theme),
                detail: seleccionado != null
                    ? AuditoriaDiffViewer(registro: seleccionado)
                    : const Center(
                        child: Text('Selecciona un evento para ver su diff'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraFiltros(WidgetRef ref, ThemeData theme) {
    final entidadFiltro = ref.watch(auditoriaFiltroEntidadProvider);
    final accionFiltro = ref.watch(auditoriaFiltroAccionProvider);

    const entidades = [
      'Movimiento',
      'Cuenta',
      'Proyecto',
      'PartidaProyecto',
      'Cotizacion',
      'PresupuestosMensuales',
    ];

    const acciones = [
      'crear',
      'editar',
      'anular',
      'restaurar',
      'elegir_ganadora',
      'exportar',
      'importar',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filtro por Entidad
          DropdownButton<String?>(
            value: entidadFiltro,
            hint: const Text('Todas las Entidades'),
            underline: const SizedBox.shrink(),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas las Entidades')),
              ...entidades.map((e) => DropdownMenuItem(value: e, child: Text(e))),
            ],
            onChanged: (val) {
              ref.read(auditoriaFiltroEntidadProvider.notifier).state = val;
            },
          ),
          const SizedBox(width: 12),

          // Filtro por Acción
          DropdownButton<String?>(
            value: accionFiltro,
            hint: const Text('Todas las Acciones'),
            underline: const SizedBox.shrink(),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas las Acciones')),
              ...acciones.map((a) => DropdownMenuItem(value: a, child: Text(a.toUpperCase()))),
            ],
            onChanged: (val) {
              ref.read(auditoriaFiltroAccionProvider.notifier).state = val;
            },
          ),
          const SizedBox(width: 12),

          if (entidadFiltro != null || accionFiltro != null) ...[
            TextButton.icon(
              onPressed: () {
                ref.read(auditoriaFiltroEntidadProvider.notifier).state = null;
                ref.read(auditoriaFiltroAccionProvider.notifier).state = null;
              },
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: const Text('Limpiar Filtros'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMasterList(
    AsyncValue<List<AuditoriaData>> listaAsync,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: listaAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyStateView(
              icon: Icons.history_edu_outlined,
              title: 'Sin registros de auditoría',
              description: 'No hay eventos que coincidan con los filtros seleccionados o aún no se han realizado operaciones.',
            );
          }

          final seleccionadoId = ref.watch(auditoriaSeleccionadaIdProvider);

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, idx) {
              final it = items[idx];
              final isSelected = (seleccionadoId ?? items.first.id) == it.id;

              return ListTile(
                selected: isSelected,
                selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _getColor(it.accion).withValues(alpha: 0.15),
                  child: Icon(
                    _getIcon(it.accion),
                    size: 16,
                    color: _getColor(it.accion),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${it.entidad} #${it.entidadId}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      AppDateFormats.formatSimpleHora(it.fechaHora),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    it.resumen,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                onTap: () {
                  ref.read(auditoriaSeleccionadaIdProvider.notifier).state = it.id;
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _getColor(String accion) {
    switch (accion.toLowerCase()) {
      case 'crear':
        return AppColors.income;
      case 'anular':
        return AppColors.expense;
      case 'restaurar':
        return const Color(0xFF8B5CF6);
      case 'editar':
      case 'elegir_ganadora':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFFD97706);
    }
  }

  IconData _getIcon(String accion) {
    switch (accion.toLowerCase()) {
      case 'crear':
        return Icons.add_rounded;
      case 'anular':
        return Icons.cancel_outlined;
      case 'restaurar':
        return Icons.restore_rounded;
      case 'editar':
        return Icons.edit_outlined;
      case 'elegir_ganadora':
        return Icons.workspace_premium_outlined;
      default:
        return Icons.history_rounded;
    }
  }
}