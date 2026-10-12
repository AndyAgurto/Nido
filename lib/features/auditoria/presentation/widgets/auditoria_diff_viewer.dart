import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/date_formatters.dart';

/// Visor visual de diferencias (Diff) antes y después para registros de auditoría de solo lectura.
class AuditoriaDiffViewer extends StatelessWidget {
  const AuditoriaDiffViewer({
    super.key,
    required this.registro,
  });

  final AuditoriaData registro;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final anteriorMap = _parseJson(registro.valorAnteriorJson);
    final nuevoMap = _parseJson(registro.valorNuevoJson);
    final diffKeys = _obtenerClavesModificadas(anteriorMap, nuevoMap);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            // Cabecera con entidad, ID y acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _getColorAccion(registro.accion).withValues(alpha: 0.12),
                        child: Icon(
                          _getIconoAccion(registro.accion),
                          color: _getColorAccion(registro.accion),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${registro.entidad} #${registro.entidadId}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              AppDateFormats.formatFechaHoraCompleta(registro.fechaHora),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getColorAccion(registro.accion).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    registro.accion.toUpperCase(),
                    style: TextStyle(
                      color: _getColorAccion(registro.accion),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Resumen de la acción
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      registro.resumen,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Título de la sección Diff
            Row(
              children: [
                const Icon(Icons.compare_arrows_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Detalle de Cambios (Diff Antes / Después)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (diffKeys.isEmpty && anteriorMap.isEmpty && nuevoMap.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'No hay valores de estado serializados para esta acción.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ] else if (registro.accion == 'crear') ...[
              // Para creación: muestra campos iniciales
              _buildTablaCreacion(nuevoMap, theme),
            ] else ...[
              // Para edición, anulación o restauración: muestra comparativa visual
              _buildTablaDiff(anteriorMap, nuevoMap, diffKeys, theme),
            ],

            const SizedBox(height: 24),
            // Nota de inmutabilidad y solo lectura
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Registro inmutable de auditoría (Solo lectura)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablaCreacion(Map<String, dynamic> nuevoMap, ThemeData theme) {
    return Table(
      border: TableBorder.all(
        color: theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(7),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Campo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Valor Inicial Asignado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        ...nuevoMap.entries.map(
          (e) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  e.value?.toString() ?? 'null',
                  style: const TextStyle(color: AppColors.income, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTablaDiff(
    Map<String, dynamic> anterior,
    Map<String, dynamic> nuevo,
    Set<String> claves,
    ThemeData theme,
  ) {
    return Table(
      border: TableBorder.all(
        color: theme.colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(4),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Campo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Valor Anterior', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Valor Nuevo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        ...claves.map((key) {
          final valAnt = anterior[key]?.toString() ?? '(no definido)';
          final valNue = nuevo[key]?.toString() ?? '(no definido)';
          final cambio = valAnt != valNue;

          return TableRow(
            decoration: cambio
                ? BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.04),
                  )
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  key,
                  style: TextStyle(
                    fontWeight: cambio ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  valAnt,
                  style: TextStyle(
                    fontSize: 12,
                    color: cambio ? AppColors.expense : theme.colorScheme.onSurface,
                    decoration: cambio ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  valNue,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: cambio ? FontWeight.bold : FontWeight.normal,
                    color: cambio ? AppColors.income : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Map<String, dynamic> _parseJson(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return const {};
  }

  Set<String> _obtenerClavesModificadas(
    Map<String, dynamic> ant,
    Map<String, dynamic> nue,
  ) {
    return {...ant.keys, ...nue.keys};
  }

  Color _getColorAccion(String accion) {
    switch (accion.toLowerCase()) {
      case 'crear':
        return AppColors.income;
      case 'anular':
        return AppColors.expense;
      case 'restaurar':
        return const Color(0xFF8B5CF6);
      case 'editar':
      case 'elegir_ganadora':
      case 'vincular_partida':
        return const Color(0xFF2563EB);
      case 'exportar':
      case 'importar':
        return const Color(0xFFD97706);
      default:
        return AppColors.primary;
    }
  }

  IconData _getIconoAccion(String accion) {
    switch (accion.toLowerCase()) {
      case 'crear':
        return Icons.add_circle_outline_rounded;
      case 'anular':
        return Icons.cancel_outlined;
      case 'restaurar':
        return Icons.restore_rounded;
      case 'editar':
        return Icons.edit_outlined;
      case 'elegir_ganadora':
        return Icons.workspace_premium_outlined;
      case 'vincular_partida':
        return Icons.link_rounded;
      case 'exportar':
        return Icons.upload_file_rounded;
      case 'importar':
        return Icons.download_for_offline_outlined;
      default:
        return Icons.history_rounded;
    }
  }
}