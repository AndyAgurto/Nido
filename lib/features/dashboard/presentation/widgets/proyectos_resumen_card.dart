import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../dashboard_providers.dart';

/// Tarjeta de proyectos en ejecución o activos en el Dashboard.
class ProyectosResumenCard extends StatelessWidget {
  const ProyectosResumenCard({
    super.key,
    required this.proyectos,
  });

  final List<DashboardProyectoItem> proyectos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.handyman_outlined, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Proyectos en Marcha',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${proyectos.length} activos',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (proyectos.isEmpty) ...[
              Container(
                height: 140,
                alignment: Alignment.center,
                child: Text(
                  'No hay proyectos en marcha actualmente',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: proyectos.take(3).length,
                separatorBuilder: (_, _) => const Divider(height: 24),
                itemBuilder: (context, idx) {
                  final item = proyectos[idx];
                  final p = item.proyecto;
                  final av = item.avance;

                  final pctGastado =
                      (av.porcentajeGastadoVsPresupuesto * 100).toInt();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              p.nombre,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: p.estado == 'enEjecucion'
                                  ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                                  : Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.estado == 'enEjecucion'
                                  ? 'EN EJECUCIÓN'
                                  : 'COTIZANDO',
                              style: TextStyle(
                                color: p.estado == 'enEjecucion'
                                    ? const Color(0xFF3B82F6)
                                    : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: av.porcentajeGastadoVsPresupuesto > 1.0
                              ? 1.0
                              : av.porcentajeGastadoVsPresupuesto,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ejecutado: ${av.gastadoReal.format()} ($pctGastado%)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Objetivo: ${av.presupuestoObjetivo.format()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}