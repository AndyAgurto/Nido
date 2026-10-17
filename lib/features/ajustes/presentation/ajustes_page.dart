import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/security/seguridad_providers.dart';
import '../../../core/utils/date_formatters.dart';
import '../../onboarding/data/demo_data_service.dart';
import '../../onboarding/presentation/onboarding_page.dart';
import '../data/respaldo_service.dart';
import 'ajustes_providers.dart';
import '../../categorias/presentation/categorias_page.dart';

/// Pantalla de Configuración, Apariencia, Seguridad Local, Respaldos ZIP y Datos Demo.
class AjustesPage extends ConsumerStatefulWidget {
  const AjustesPage({super.key});

  @override
  ConsumerState<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends ConsumerState<AjustesPage> {
  bool _estaExportando = false;
  bool _estaImportando = false;
  bool _estaCargandoDemo = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requiereRecordatorioAsync = ref.watch(
      requiereRecordatorioRespaldoProvider,
    );
    final ultimoRespaldoAsync = ref.watch(ultimoRespaldoFechaProvider);
    final diasDesdeRespaldoAsync = ref.watch(diasDesdeUltimoRespaldoProvider);
    final tienePinAsync = ref.watch(tienePinConfiguradoProvider);
    final biometriaDispAsync = ref.watch(biometriaDisponibleProvider);
    // biometria removida
    final currentThemeMode = ref.watch(themeModeProvider);

    final requiereRecordatorio = requiereRecordatorioAsync.value ?? false;
    final tienePin = tienePinAsync.value ?? false;
    final biometriaDisponible = biometriaDispAsync.value ?? false;
    const biometriaActiva = false;

    final isMobile = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              leading: isMobile
                  ? Builder(
                      builder: (ctx) => IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        tooltip: 'Menú',
                        onPressed: () => ctx
                            .findRootAncestorStateOfType<ScaffoldState>()
                            ?.openDrawer(),
                      ),
                    )
                  : null,
              title: const Text('Ajustes del Sistema'),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.paddingOf(context).bottom + 88,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera institucional con Logo
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.settings_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ajustes del Sistema',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // 2. EL TEXTO YA NO LLEVA EXPANDED NI FLEXIBLE:
                          Text(
                            'Personalización, seguridad biométrica, respaldos y datos de prueba',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 1. BANNER DE RECORDATORIO DE RESPALDO (>30 días o nunca)
                if (requiereRecordatorio)
                  _buildBannerRecordatorioRespaldo(
                    theme,
                    diasDesdeRespaldoAsync.value,
                  )
                else
                  _buildBannerEstadoRespaldoOk(
                    theme,
                    ultimoRespaldoAsync.value,
                    diasDesdeRespaldoAsync.value,
                  ),

                const SizedBox(height: 24),

                // 2. SECCIÓN DE APARIENCIA (MODO OSCURO / CLARO)
                _buildSeccionApariencia(theme, currentThemeMode),

                const SizedBox(height: 24),

                // SECCIÓN DE CATEGORÍAS DEL HOGAR Y PROYECTOS
                _buildSeccionCategorias(context, theme),

                const SizedBox(height: 24),

                // 3. SECCIÓN DE SEGURIDAD LOCAL (PIN Y BIOMETRÍA)
                _buildSeccionSeguridad(
                  theme: theme,
                  tienePin: tienePin,
                  biometriaDisponible: biometriaDisponible,
                  biometriaActiva: biometriaActiva,
                ),

                const SizedBox(height: 24),

                // 4. SECCIÓN DE RESPALDO Y RESTAURACIÓN (.ZIP)
                _buildSeccionRespaldos(
                  theme: theme,
                  ultimoRespaldoFecha: ultimoRespaldoAsync.value,
                ),

                const SizedBox(height: 24),

                // 5. SECCIÓN DE DATOS DEMO Y TUTORIAL
                _buildSeccionDatosDemoYTutorial(theme),

                const SizedBox(height: 24),

                // 6. INFORMACIÓN DEL SISTEMA
                _buildSeccionAcercaDe(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionApariencia(ThemeData theme, ThemeMode currentMode) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.palette_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Apariencia y Modo Visual',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Selecciona entre el tema claro con tono lino cálido, modo oscuro de alto confort visual o sincronización automática con tu tablet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 28),

            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 500;
                return SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        icon: const Icon(Icons.brightness_auto_rounded),
                        label: Text(isNarrow ? 'Auto' : 'Sistema'),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: const Icon(Icons.light_mode_rounded),
                        label: Text(isNarrow ? 'Claro' : 'Modo Claro'),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: const Icon(Icons.dark_mode_rounded),
                        label: Text(isNarrow ? 'Oscuro' : 'Modo Oscuro'),
                      ),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (newSelection) {
                      ref.read(themeModeProvider.notifier).state =
                          newSelection.first;
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionDatosDemoYTutorial(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Datos de Prueba y Tutorial',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Herramientas para poblar la aplicación con un conjunto completo de datos familiares realistas o reiniciar a estado limpio.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 28),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(160, 48), // Touch target >= 48dp
                  ),
                  onPressed: _estaCargandoDemo
                      ? null
                      : _confirmarYCargarDatosDemo,
                  icon: _estaCargandoDemo
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.dataset_rounded),
                  label: const Text('Cargar Datos Demo'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(160, 48),
                  ),
                  onPressed: _abrirOnboardingTutorial,
                  icon: const Icon(Icons.school_outlined),
                  label: const Text('Ver Introducción (Onboarding)'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(160, 48),
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: _confirmarYRestablecerLimpio,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Restablecer Base Limpia'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _abrirOnboardingTutorial() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingPage(
          onCompletado: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _confirmarYCargarDatosDemo() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dataset_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Cargar Datos Familiares Demo'),
          ],
        ),
        content: const Text(
          'Se agregarán cuentas bancarias (BCP, Interbank, Yape), ingresos, gastos habituales, gastos fijos, presupuestos y proyectos con cotizaciones.\n\n¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cargar Datos Demo'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _estaCargandoDemo = true);
    try {
      final db = ref.read(databaseProvider);
      final writer = ref.read(auditedWriterProvider);

      await DemoDataService.cargarDatosDemo(db: db, writer: writer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Datos familiares de prueba cargados exitosamente!'),
          backgroundColor: AppColors.income,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos demo: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _estaCargandoDemo = false);
    }
  }

  Future<void> _confirmarYRestablecerLimpio() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(ctx).colorScheme.error,
            ),
            const SizedBox(width: 10),
            const Text('¿Restablecer Base Limpia?'),
          ],
        ),
        content: const Text(
          'Se eliminarán todas las cuentas, movimientos, presupuestos y proyectos. Las categorías predeterminadas y los ajustes del sistema se conservarán.\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí, Restablecer'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final db = ref.read(databaseProvider);
      final writer = ref.read(auditedWriterProvider);

      await DemoDataService.restablecerDatosLimpios(db: db, writer: writer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Base de datos restablecida a estado limpio inicial.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al restablecer: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _buildBannerRecordatorioRespaldo(ThemeData theme, int? dias) {
    final mensajeDias = dias == null
        ? 'Aún no has generado ninguna copia de seguridad de tus finanzas.'
        : 'Han transcurrido $dias días desde tu último respaldo registrado.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recordatorio de Respaldo (>30 días)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$mensajeDias En Nido tus datos no viajan a ninguna nube. Te recomendamos exportar un archivo .zip para prevenir pérdidas ante eventualidades con tu dispositivo.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: _estaExportando ? null : _exportarRespaldoZip,
              icon: _estaExportando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black87,
                      ),
                    )
                  : const Icon(Icons.download_rounded),
              label: const Text('Respaldar Ahora (.zip)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerEstadoRespaldoOk(
    ThemeData theme,
    String? fechaIso,
    int? dias,
  ) {
    if (fechaIso == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.income.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.income.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.income,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Copia de seguridad al día: Último respaldo realizado el ${AppDateFormats.formatSimple(DateTime.parse(fechaIso))} (${dias ?? 0} días atrás).',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionSeguridad({
    required ThemeData theme,
    required bool tienePin,
    required bool biometriaDisponible,
    required bool biometriaActiva,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.security_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Seguridad de Acceso Local',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Protege tu información confidencial con hash criptográfico SHA-256 y sal única almacenada en hardware seguro.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 28),

            // Item 1: PIN de Acceso
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (tienePin
                              ? AppColors.income
                              : theme.colorScheme.surfaceContainerHighest)
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tienePin ? Icons.pin_drop_rounded : Icons.pin_outlined,
                  color: tienePin
                      ? AppColors.income
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              title: const Text('PIN de Acceso (4 a 6 dígitos)'),
              subtitle: Text(
                tienePin
                    ? 'Activado con sal aleatoria de 32 bytes y hash SHA-256'
                    : 'Desactivado. La aplicación se abre sin solicitar código.',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tienePin) ...[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: _mostrarDialogoDesactivarPin,
                      child: const Text('Desactivar PIN'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(100, 44),
                    ),
                    onPressed: _mostrarDialogoConfigurarPin,
                    child: Text(tienePin ? 'Cambiar PIN' : 'Activar PIN'),
                  ),
                ],
              ),
            ),

            const Divider(height: 20),

            const Divider(height: 20),

            // Item 3: Bloquear ahora
            if (tienePin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bloquear Pantalla Inmediatamente',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bloquea la sesión actual para requerir PIN o biometría de inmediato.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(140, 44),
                    ),
                    onPressed: () {
                      ref.read(estaBloqueadoProvider.notifier).state = true;
                    },
                    icon: const Icon(Icons.lock_clock_outlined),
                    label: const Text('Bloquear Ahora'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionRespaldos({
    required ThemeData theme,
    required String? ultimoRespaldoFecha,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.archive_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Copia de Seguridad y Restauración (.zip)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Exporta e importa paquetes completos y autocontenidos con tu base de datos SQLite, comprobantes fotográficos y manifiesto de integridad SHA-256.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 28),

            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;

                final exportBox = Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.cloud_upload_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Exportar Respaldo',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Empaqueta toda tu información en un archivo .zip para guardarlo en tu tarjeta SD o pendrive USB.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: _estaExportando
                            ? null
                            : _exportarRespaldoZip,
                        icon: _estaExportando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.file_download_outlined),
                        label: const Text('Exportar Archivo .zip'),
                      ),
                    ],
                  ),
                );

                final importBox = Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.settings_backup_restore_rounded,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Restaurar Respaldo',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Restaura tus datos desde un respaldo previo. Se crea automáticamente una copia de seguridad previa.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: _estaImportando
                            ? null
                            : _seleccionarEImportarRespaldoZip,
                        icon: _estaImportando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.folder_open_rounded),
                        label: const Text('Importar Archivo .zip'),
                      ),
                    ],
                  ),
                );

                if (isNarrow) {
                  return Column(
                    children: [
                      exportBox,
                      const SizedBox(height: 16),
                      importBox,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: exportBox),
                    const SizedBox(width: 16),
                    Expanded(child: importBox),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionAcercaDe(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.home_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nido Finanzas v1.0.0 (Esquema v${RespaldoService.versionEsquemaActual})',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Arquitectura 100% Local, Privada y Soberana. Diseñado exclusivamente para tablets y teléfonos del hogar. Cero servidores en la nube.',
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
    );
  }

  Future<void> _exportarRespaldoZip() async {
    setState(() => _estaExportando = true);
    try {
      final db = ref.read(databaseProvider);
      final writer = ref.read(auditedWriterProvider);

      final file = await RespaldoService.exportarRespaldo(
        db: db,
        writer: writer,
      );

      ref.invalidate(ultimoRespaldoFechaProvider);
      ref.invalidate(diasDesdeUltimoRespaldoProvider);
      ref.invalidate(requiereRecordatorioRespaldoProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Respaldo generado exitosamente:\n${file.path}'),
          backgroundColor: AppColors.income,
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Compartir',
            textColor: Colors.white,
            onPressed: () {
              RespaldoService.compartirRespaldo(file.path);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar respaldo: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _estaExportando = false);
    }
  }

  Future<void> _seleccionarEImportarRespaldoZip() async {
    final pickedFiles = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (pickedFiles.isEmpty) return;

    final filePath = pickedFiles.first.path;
    if (filePath == null) return;

    final file = File(filePath);
    if (!await file.exists()) return;

    if (!mounted) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: 10),
            Text('Restaurar Respaldo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas restaurar este respaldo? Tus datos actuales serán reemplazados por los datos contenidos en el archivo .zip.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Por seguridad, Nido creará una copia previa automática de tu base activa antes de restaurar.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.black87,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí, Restaurar Datos'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _estaImportando = true);
    try {
      final db = ref.read(databaseProvider);
      final writer = ref.read(auditedWriterProvider);
      final bytes = await file.readAsBytes();

      await RespaldoService.validarEImportarRespaldo(
        zipBytes: bytes,
        db: db,
        writer: writer,
      );

      ref.invalidate(ultimoRespaldoFechaProvider);
      ref.invalidate(diasDesdeUltimoRespaldoProvider);
      ref.invalidate(requiereRecordatorioRespaldoProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Respaldo restaurado exitosamente. Los datos han sido actualizados.',
          ),
          backgroundColor: AppColors.income,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al restaurar respaldo: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) setState(() => _estaImportando = false);
    }
  }

  Future<void> _mostrarDialogoConfigurarPin() async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    String? errorLocal;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return AlertDialog(
              title: const Text('Configurar PIN de Acceso'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ingresa un PIN numérico de 4 a 6 dígitos para proteger tu información en esta tablet.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Nuevo PIN (4 a 6 dígitos)',
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar PIN',
                        prefixIcon: Icon(Icons.lock_reset_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (errorLocal != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorLocal!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(modalCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final p1 = pinController.text.trim();
                    final p2 = confirmController.text.trim();

                    if (p1.length < 4 ||
                        p1.length > 6 ||
                        int.tryParse(p1) == null) {
                      setModalState(() {
                        errorLocal =
                            'El PIN debe tener entre 4 y 6 dígitos numéricos.';
                      });
                      return;
                    }
                    if (p1 != p2) {
                      setModalState(() {
                        errorLocal = 'Los dígitos ingresados no coinciden.';
                      });
                      return;
                    }

                    await ref.read(seguridadServiceProvider).guardarPin(p1);
                    ref.invalidate(tienePinConfiguradoProvider);

                    if (modalCtx.mounted) Navigator.of(modalCtx).pop();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'PIN configurado exitosamente con sal y hash SHA-256.',
                          ),
                          backgroundColor: AppColors.income,
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar PIN'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarDialogoDesactivarPin() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Desactivar PIN de Acceso?'),
        content: const Text(
          'Al desactivar el PIN, cualquier persona que tenga acceso a esta tablet podrá abrir la aplicación y consultar tus finanzas sin clave.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ref.read(seguridadServiceProvider).desactivarPin();
      ref.invalidate(tienePinConfiguradoProvider);
      ref.invalidate(biometriaActivaProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN de acceso desactivado.')),
        );
      }
    }
  }

  Widget _buildSeccionCategorias(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Categorías del Hogar y Proyectos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Personaliza las categorías de gastos, ingresos familiares y los tipos de proyectos de tu hogar.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
              title: const Text('Administrar Categorías'),
              subtitle: const Text(
                'Crear, editar, activar o cambiar colores e íconos',
              ),
              trailing: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoriasPage()),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Abrir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
