import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../proyectos_providers.dart';
import '../dialogs/nueva_cotizacion_dialog.dart';
import '../dialogs/foto_viewer_dialog.dart';
import '../dialogs/registrar_gasto_partida_dialog.dart';

/// Comparador visual interactivo de cotizaciones para una partida de proyecto.
/// Resalta la opción más económica, permite ver fotografías y elegir la ganadora auditada.
class ComparadorCotizacionesCard extends ConsumerWidget {
  const ComparadorCotizacionesCard({
    super.key,
    required this.partida,
    required this.proyecto,
  });

  final PartidasProyectoData partida;
  final Proyecto proyecto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cotizacionesAsync = ref.watch(cotizacionesDePartidaStreamProvider(partida.id));
    final partidaAvanceAsync = ref.watch(partidaAvanceStreamProvider(partida.id));
    final presupuestoMoney = Money.fromCents(partida.presupuestoCent);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera de la Partida y Acciones
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: const Icon(Icons.compare_arrows_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            partida.nombre,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildEstadoBadge(partida.estado, theme),
                        ],
                      ),
                      Text(
                        'Presupuesto Asignado: ${presupuestoMoney.format()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => RegistrarGastoPartidaDialog(
                        partida: partida,
                        proyecto: proyecto,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: const Text('Registrar Gasto'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NuevaCotizacionDialog(
                        partidaId: partida.id,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Agregar Cotización'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Resumen de Avance Real de la Partida
            partidaAvanceAsync.when(
              data: (avance) => _buildResumenAvance(avance, theme),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Lista Comparativa de Cotizaciones
            cotizacionesAsync.when(
              data: (cotizaciones) {
                if (cotizaciones.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.request_quote_outlined,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No hay cotizaciones registradas para esta partida.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => NuevaCotizacionDialog(
                                partidaId: partida.id,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Cotizar con Proveedor'),
                        ),
                      ],
                    ),
                  );
                }

                // Identificar la menor cotización para resaltado inteligente
                final menorCent = cotizaciones
                    .map((c) => c.montoCent)
                    .reduce((curr, min) => curr < min ? curr : min);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comparativa de Proveedores (${cotizaciones.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...cotizaciones.map(
                      (cot) => _CotizacionItemTile(
                        cotizacion: cot,
                        presupuestoPartida: presupuestoMoney,
                        esMenorPrecio: cot.montoCent == menorCent && cotizaciones.length > 1,
                        esElegida: cot.elegida || cot.id == partida.cotizacionElegidaId,
                        onElegir: () => _elegirGanadora(context, ref, cot),
                        onDesmarcar: () => _desmarcarGanadora(context, ref),
                        onVerFoto: cot.fotoRutaRelativa != null
                            ? () => _verFoto(context, cot)
                            : null,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error al cargar cotizaciones: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(String estado, ThemeData theme) {
    Color bg = theme.colorScheme.surfaceContainerHighest;
    Color fg = theme.colorScheme.onSurfaceVariant;
    String label = estado.toUpperCase();

    if (estado == 'adjudicado') {
      bg = AppColors.primary.withValues(alpha: 0.12);
      fg = AppColors.primary;
      label = 'ADJUDICADA';
    } else if (estado == 'completado') {
      bg = AppColors.income.withValues(alpha: 0.12);
      fg = AppColors.income;
      label = 'COMPLETADA';
    } else if (estado == 'cotizado') {
      bg = Colors.amber.withValues(alpha: 0.15);
      fg = Colors.amber.shade900;
      label = 'COTIZANDO';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResumenAvance(PartidaAvance avance, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniDato(
              label: 'Presupuestado',
              valor: avance.presupuesto.format(),
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MiniDato(
              label: 'Cotizado Ganador',
              valor: avance.montoCotizado?.format() ?? 'Pendiente',
              color: avance.montoCotizado != null ? AppColors.primary : theme.colorScheme.outline,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MiniDato(
              label: 'Gastado Real',
              valor: avance.gastadoReal.format(),
              color: AppColors.expense,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MiniDato(
              label: avance.restante.isNegative ? 'Sobregiro' : 'Disponible',
              valor: avance.restante.format(),
              color: avance.restante.isNegative ? AppColors.expense : AppColors.income,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _elegirGanadora(
    BuildContext context,
    WidgetRef ref,
    Cotizacione cot,
  ) async {
    final dao = ref.read(proyectosDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    await dao.elegirCotizacionGanadora(
      partidaId: partida.id,
      cotizacionId: cot.id,
      writer: writer,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Se adjudicó la cotización de "${cot.proveedor}" como ganadora.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _desmarcarGanadora(BuildContext context, WidgetRef ref) async {
    final dao = ref.read(proyectosDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    await dao.desmarcarCotizacionGanadora(
      partidaId: partida.id,
      writer: writer,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cotización desmarcada. La partida vuelve a estado cotizado.'),
        ),
      );
    }
  }

  void _verFoto(BuildContext context, Cotizacione cot) {
    showDialog(
      context: context,
      builder: (context) => FotoViewerDialog(
        rutaRelativa: cot.fotoRutaRelativa!,
        proveedor: cot.proveedor,
      ),
    );
  }
}

class _MiniDato extends StatelessWidget {
  const _MiniDato({
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
        Text(
          valor,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Fila individual de cotización con comparación de precio, badge ganadora y botón de acción.
class _CotizacionItemTile extends StatelessWidget {
  const _CotizacionItemTile({
    required this.cotizacion,
    required this.presupuestoPartida,
    required this.esMenorPrecio,
    required this.esElegida,
    required this.onElegir,
    required this.onDesmarcar,
    this.onVerFoto,
  });

  final Cotizacione cotizacion;
  final Money presupuestoPartida;
  final bool esMenorPrecio;
  final bool esElegida;
  final VoidCallback onElegir;
  final VoidCallback onDesmarcar;
  final VoidCallback? onVerFoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final montoMoney = Money.fromCents(cotizacion.montoCent);
    final diferencia = cotizacion.montoCent - presupuestoPartida.cents;
    final esAhorro = diferencia <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esElegida
            ? AppColors.primary.withValues(alpha: 0.06)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: esElegida
              ? AppColors.primary
              : (esMenorPrecio
                  ? Colors.green.shade400
                  : theme.colorScheme.outlineVariant),
          width: esElegida ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Icono / Foto
          if (onVerFoto != null) ...[
            InkWell(
              onTap: onVerFoto,
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: const Icon(Icons.photo_rounded, size: 22, color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.zoom_in, size: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.storefront_rounded, size: 20),
            ),
            const SizedBox(width: 12),
          ],

          // Datos del Proveedor y Fechas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cotizacion.proveedor,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (esElegida) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GANADORA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (esMenorPrecio) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'MÁS ECONÓMICA',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Fecha: ${AppDateFormats.formatSimple(cotizacion.fecha)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    if (cotizacion.contacto != null && cotizacion.contacto!.isNotEmpty) ...[
                      const Text(' • '),
                      Text(
                        'Tel: ${cotizacion.contacto}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Monto y Desvío frente al Presupuesto
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                montoMoney.format(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: esElegida ? AppColors.primary : theme.colorScheme.onSurface,
                ),
              ),
              Text(
                esAhorro
                    ? 'Ahorro: ${Money.fromCents(diferencia.abs()).format()}'
                    : '+${Money.fromCents(diferencia).format()}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: esAhorro ? AppColors.income : AppColors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Botón de Elección de Ganadora
          if (esElegida)
            OutlinedButton(
              onPressed: onDesmarcar,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.expense,
                side: BorderSide(color: AppColors.expense.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Desmarcar'),
            )
          else
            FilledButton.tonal(
              onPressed: onElegir,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Elegir Ganadora'),
            ),
        ],
      ),
    );
  }
}
