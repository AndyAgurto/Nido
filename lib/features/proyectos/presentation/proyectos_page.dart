import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/master_detail_layout.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import 'proyectos_providers.dart';
import 'dialogs/nuevo_proyecto_dialog.dart';
import 'dialogs/nueva_partida_dialog.dart';
import 'widgets/comparador_cotizaciones_card.dart';

/// Pantalla principal de Proyectos del Hogar optimizada para Tablet (Master-Detail).
/// Integra avance financiero (Presupuesto vs Cotizado vs Gastado), partidas, comparador de cotizaciones
/// con fotos y trazabilidad de gastos ejecutados.
class ProyectosPage extends ConsumerWidget {
  const ProyectosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final proyectosAsync = ref.watch(proyectosStreamProvider);
    final selectedId = ref.watch(proyectoSeleccionadoIdProvider);
    final filtroEstado = ref.watch(proyectosFiltroEstadoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos del Hogar'),
        actions: [
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NuevoProyectoDialog(),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo Proyecto'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: proyectosAsync.when(
        data: (proyectos) {
          if (proyectos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_repair_service_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    filtroEstado != null
                        ? 'No hay proyectos con estado "$filtroEstado"'
                        : 'No tienes proyectos del hogar registrados',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Planifica remodelaciones, muebles, reparaciones y cotizaciones.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const NuevoProyectoDialog(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Primer Proyecto'),
                  ),
                ],
              ),
            );
          }

          final selectedProyecto = selectedId != null
              ? proyectos.where((p) => p.id == selectedId).firstOrNull ??
                  proyectos.first
              : proyectos.first;

          return MasterDetailLayout(
            master: Column(
              children: [
                _FiltrosEstadoBar(filtroActual: filtroEstado),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: proyectos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final p = proyectos[index];
                      final isSelected = p.id == selectedProyecto.id;
                      return _ProyectoListItem(
                        proyecto: p,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(proyectoSeleccionadoIdProvider.notifier).state = p.id;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            detail: _ProyectoDetallePanel(proyecto: selectedProyecto),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar proyectos: $e')),
      ),
    );
  }
}

/// Selector horizontal de filtros por estado del proyecto.
class _FiltrosEstadoBar extends ConsumerWidget {
  const _FiltrosEstadoBar({required this.filtroActual});

  final String? filtroActual;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(proyectosFiltroEstadoProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ChoiceChip(
              label: const Text('Todos'),
              selected: filtroActual == null,
              onSelected: (_) => notifier.state = null,
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('En Idea'),
              selected: filtroActual == 'idea',
              onSelected: (_) => notifier.state = 'idea',
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Cotizando'),
              selected: filtroActual == 'cotizando',
              onSelected: (_) => notifier.state = 'cotizando',
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('En EjecuciÃ³n'),
              selected: filtroActual == 'enEjecucion',
              onSelected: (_) => notifier.state = 'enEjecucion',
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Terminados'),
              selected: filtroActual == 'terminado',
              onSelected: (_) => notifier.state = 'terminado',
            ),
          ],
        ),
      ),
    );
  }
}

/// Elemento de lista en el panel maestro de proyectos.
class _ProyectoListItem extends ConsumerWidget {
  const _ProyectoListItem({
    required this.proyecto,
    required this.isSelected,
    required this.onTap,
  });

  final Proyecto proyecto;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final avanceAsync = ref.watch(proyectoAvanceStreamProvider(proyecto.id));
    final presupuesto = Money.fromCents(proyecto.presupuestoObjetivoCent);

    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Icon(_getIconoTipo(proyecto.tipo), size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      proyecto.nombre,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildEstadoPill(proyecto.estado),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Presupuesto: ${presupuesto.format()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  avanceAsync.when(
                    data: (avance) => Text(
                      'Gastado: ${avance.gastadoReal.format()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: avance.gastadoReal.cents > avance.presupuestoReferencia.cents
                            ? AppColors.expense
                            : AppColors.primary,
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              avanceAsync.when(
                data: (avance) {
                  final ratio = avance.porcentajeGastadoVsPresupuesto.clamp(0.0, 1.0);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        avance.gastadoReal.cents > avance.presupuestoReferencia.cents
                            ? AppColors.expense
                            : AppColors.primary,
                      ),
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(minHeight: 6),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconoTipo(String tipo) {
    switch (tipo) {
      case 'decoracion':
        return Icons.format_paint_rounded;
      case 'construccion':
        return Icons.foundation_rounded;
      case 'arreglo':
        return Icons.build_rounded;
      case 'mobiliario':
        return Icons.chair_rounded;
      default:
        return Icons.handyman_rounded;
    }
  }

  Widget _buildEstadoPill(String estado) {
    Color bg = Colors.grey.shade200;
    Color fg = Colors.grey.shade800;
    String label = estado;

    switch (estado) {
      case 'idea':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        label = 'IDEA';
        break;
      case 'cotizando':
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade900;
        label = 'COTIZANDO';
        break;
      case 'aprobado':
        bg = Colors.teal.shade50;
        fg = Colors.teal.shade800;
        label = 'APROBADO';
        break;
      case 'enEjecucion':
        bg = AppColors.primary.withValues(alpha: 0.15);
        fg = AppColors.primary;
        label = 'EN EJECUCIÃ“N';
        break;
      case 'terminado':
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
        label = 'TERMINADO';
        break;
      case 'cancelado':
        bg = Colors.red.shade100;
        fg = Colors.red.shade900;
        label = 'CANCELADO';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
/// Panel de detalle del proyecto seleccionado para tablet.
class _ProyectoDetallePanel extends ConsumerStatefulWidget {
  const _ProyectoDetallePanel({required this.proyecto});

  final Proyecto proyecto;

  @override
  ConsumerState<_ProyectoDetallePanel> createState() => _ProyectoDetallePanelState();
}

class _ProyectoDetallePanelState extends ConsumerState<_ProyectoDetallePanel> {
  int? _partidaExpandidaId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.proyecto;
    final avanceAsync = ref.watch(proyectoAvanceStreamProvider(p.id));
    final partidasAsync = ref.watch(partidasDelProyectoStreamProvider(p.id));
    final movimientosAsync = ref.watch(movimientosDelProyectoStreamProvider(p.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta de Cabecera del Proyecto
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.nombre,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (p.descripcion != null && p.descripcion!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                p.descripcion!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Selector de Estado RÃ¡pido
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: p.estado,
                            items: const [
                              DropdownMenuItem(value: 'idea', child: Text('En Idea')),
                              DropdownMenuItem(value: 'cotizando', child: Text('Cotizando')),
                              DropdownMenuItem(value: 'aprobado', child: Text('Aprobado')),
                              DropdownMenuItem(value: 'enEjecucion', child: Text('En EjecuciÃ³n')),
                              DropdownMenuItem(value: 'terminado', child: Text('Terminado')),
                              DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
                            ],
                            onChanged: (val) {
                              if (val != null) _cambiarEstado(val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Editar Proyecto',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => NuevoProyectoDialog(proyecto: p),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildChip(Icons.category_outlined, p.tipo.toUpperCase(), theme),
                      _buildChip(Icons.flag_outlined, 'Prioridad: ${p.prioridad.toUpperCase()}', theme),
                      if (p.fechaInicioEstimada != null)
                        _buildChip(
                          Icons.calendar_today_rounded,
                          'Inicio: ${AppDateFormats.formatSimple(p.fechaInicioEstimada!)}',
                          theme,
                        ),
                      if (p.fechaFinEstimada != null)
                        _buildChip(
                          Icons.event_available_rounded,
                          'Fin: ${AppDateFormats.formatSimple(p.fechaFinEstimada!)}',
                          theme,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Consolidado de Avance Financiero: Presupuesto vs Cotizado vs Gastado
          avanceAsync.when(
            data: (avance) => _buildConsolidadoFinanciero(avance, theme),
            loading: () => const Card(child: Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))),
            error: (e, _) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Error al calcular avance: $e'))),
          ),
          const SizedBox(height: 24),

          // SecciÃ³n de Partidas Presupuestarias y Comparador
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partidas Presupuestarias y Cotizaciones',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => NuevaPartidaDialog(proyectoId: p.id),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Nueva Partida'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de Partidas
          partidasAsync.when(
            data: (partidas) {
              if (partidas.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.assignment_outlined, size: 48, color: theme.colorScheme.outline),
                          const SizedBox(height: 12),
                          const Text('No hay partidas definidas para este proyecto.'),
                          const SizedBox(height: 8),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => NuevaPartidaDialog(proyectoId: p.id),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar Primera Partida'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: partidas.map((partida) {
                  final isExpandida = _partidaExpandidaId == partida.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        _buildPartidaRow(partida, isExpandida, theme),
                        if (isExpandida) ...[
                          const SizedBox(height: 8),
                          ComparadorCotizacionesCard(
                            partida: partida,
                            proyecto: p,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error al cargar partidas: $e'),
          ),
          const SizedBox(height: 24),

          // Historial de Gastos Ejecutados Vinculados
          Text(
            'Historial de Desembolsos Vinculados al Proyecto',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          movimientosAsync.when(
            data: (movs) {
              if (movs.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'AÃºn no hay desembolsos registrados para las partidas de este proyecto.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: movs.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final m = movs[idx];
                    final montoMoney = Money.fromCents(m.montoCent);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.expense.withValues(alpha: 0.12),
                        child: const Icon(Icons.arrow_upward_rounded, color: AppColors.expense, size: 20),
                      ),
                      title: Text(
                        m.descripcion,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Fecha: ${AppDateFormats.formatSimple(m.fecha)} â€¢ Cuenta #${m.cuentaOrigenId} â€¢ Partida #${m.partidaId}',
                      ),
                      trailing: Text(
                        '-${montoMoney.format()}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.expense,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error al cargar gastos: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjeta de Consolidado Financiero (Presupuesto vs Cotizado vs Gastado)
  Widget _buildConsolidadoFinanciero(ProyectoAvance avance, ThemeData theme) {
    final pctCotizado = (avance.porcentajeCotizado * 100).toInt();
    final pctGastado = (avance.porcentajeGastadoVsPresupuesto * 100).toInt();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consolidado Financiero de Avance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Partidas Adjudicadas: ${avance.partidasAdjudicadas} de ${avance.totalPartidas}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barras de Progreso Comparativas
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cotizado Adjudicado', style: theme.textTheme.labelSmall),
                          Text('$pctCotizado% del presupuesto', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: avance.porcentajeCotizado.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Gasto Real Desembolsado', style: theme.textTheme.labelSmall),
                          Text(
                            '$pctGastado% ejecutado',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: pctGastado > 100 ? AppColors.expense : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: avance.porcentajeGastadoVsPresupuesto.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            pctGastado > 100 ? AppColors.expense : Colors.amber.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            // 4 Columnas de MÃ©tricas Clave
            Row(
              children: [
                Expanded(
                  child: _MiniResumenItem(
                    label: 'Presupuesto Base',
                    valor: avance.presupuestoReferencia.format(),
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: _MiniResumenItem(
                    label: 'Total Cotizado',
                    valor: avance.totalCotizado.format(),
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _MiniResumenItem(
                    label: 'Gastado Real',
                    valor: avance.gastadoReal.format(),
                    color: AppColors.expense,
                  ),
                ),
                Expanded(
                  child: _MiniResumenItem(
                    label: avance.disponiblePresupuesto.isNegative ? 'Sobregiro' : 'Saldo Disponible',
                    valor: avance.disponiblePresupuesto.format(),
                    color: avance.disponiblePresupuesto.isNegative ? AppColors.expense : AppColors.income,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartidaRow(
    PartidasProyectoData partida,
    bool isExpandida,
    ThemeData theme,
  ) {
    final presupuestoMoney = Money.fromCents(partida.presupuestoCent);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: isExpandida ? AppColors.primary : theme.colorScheme.outlineVariant,
          width: isExpandida ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: isExpandida
              ? AppColors.primary
              : theme.colorScheme.surfaceContainerHighest,
          foregroundColor: isExpandida ? Colors.white : theme.colorScheme.onSurface,
          child: const Icon(Icons.assignment_outlined, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                partida.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildBadgeEstadoPartida(partida.estado),
          ],
        ),
        subtitle: Text('Presupuesto Asignado: ${presupuestoMoney.format()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'Editar Partida',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => NuevaPartidaDialog(
                    proyectoId: widget.proyecto.id,
                    partida: partida,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                isExpandida ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: isExpandida ? AppColors.primary : null,
              ),
              tooltip: isExpandida ? 'Cerrar Cotizaciones' : 'Ver y Comparar Cotizaciones',
              onPressed: () {
                setState(() {
                  _partidaExpandidaId = isExpandida ? null : partida.id;
                });
              },
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _partidaExpandidaId = isExpandida ? null : partida.id;
          });
        },
      ),
    );
  }

  Widget _buildBadgeEstadoPartida(String estado) {
    Color bg = Colors.grey.shade200;
    Color fg = Colors.grey.shade800;
    String label = estado.toUpperCase();

    if (estado == 'adjudicado') {
      bg = AppColors.primary.withValues(alpha: 0.15);
      fg = AppColors.primary;
      label = 'ADJUDICADA';
    } else if (estado == 'completado') {
      bg = Colors.green.shade100;
      fg = Colors.green.shade900;
      label = 'COMPLETADA';
    } else if (estado == 'cotizado') {
      bg = Colors.amber.shade100;
      fg = Colors.amber.shade900;
      label = 'COTIZANDO';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _cambiarEstado(String nuevoEstado) async {
    final dao = ref.read(proyectosDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    await dao.cambiarEstadoProyecto(widget.proyecto.id, nuevoEstado, writer);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a "$nuevoEstado" con auditorÃ­a.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}

class _MiniResumenItem extends StatelessWidget {
  const _MiniResumenItem({
    required this.label,
    required this.valor,
    required this.color,
  });

  final String label;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}