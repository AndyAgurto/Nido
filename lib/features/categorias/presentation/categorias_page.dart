import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme/app_colors.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/empty_state_view.dart';
import 'categorias_providers.dart';

/// Pantalla completa de administración de Categorías (Gastos, Ingresos y Proyectos).
/// Mobile-First, responsiva, accesible WCAG y totalmente auditada.
class CategoriasPage extends ConsumerWidget {
  const CategoriasPage({super.key});

  static const List<({String key, String label, IconData icon})> _tiposTabs = [
    (key: 'todos', label: 'Todas', icon: Icons.category_outlined),
    (key: 'gastoVariable', label: 'Gastos Variables', icon: Icons.shopping_bag_outlined),
    (key: 'gastoFijo', label: 'Gastos Fijos', icon: Icons.receipt_long_outlined),
    (key: 'ingreso', label: 'Ingresos', icon: Icons.trending_up_rounded),
    (key: 'proyecto', label: 'Proyectos del Hogar', icon: Icons.handyman_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tipoActual = ref.watch(categoriasFiltroTipoProvider);
    final soloActivas = ref.watch(categoriasMostrarSoloActivasProvider);
    final categoriasAsync = ref.watch(categoriasFiltradasStreamProvider);

    final isMobile = MediaQuery.of(context).size.width < 720;

    // Dividir la lista en 2 sublistas (pares en fila superior, impares en fila inferior)
    final fila1 = [
      for (int i = 0; i < _tiposTabs.length; i += 2) _tiposTabs[i]
    ];
    final fila2 = [
      for (int i = 1; i < _tiposTabs.length; i += 2) _tiposTabs[i]
    ];

    Widget _buildChip(dynamic tab) {
      final isSelected = tipoActual == tab.key;
      return ChoiceChip(
        avatar: Icon(
          tab.icon,
          size: 16,
          color: isSelected ? theme.colorScheme.onPrimary : null,
        ),
        label: Text(tab.label),
        selected: isSelected,
        showCheckmark: false, // Opcional: oculta el check al seleccionar para que no cambie el ancho
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onSelected: (val) {
          if (val) {
            ref.read(categoriasFiltroTipoProvider.notifier).state = tab.key;
          }
        },
      );
    }

    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              title: const Text('Categorías'),
              actions: [
                Tooltip(
                  message: soloActivas ? 'Mostrando solo activas' : 'Mostrando todas',
                  child: IconButton(
                    icon: Icon(soloActivas ? Icons.visibility_rounded : Icons.visibility_off_outlined),
                    onPressed: () {
                      ref.read(categoriasMostrarSoloActivasProvider.notifier).state = !soloActivas;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _mostrarDialogoCrearEditar(context, ref, tipoSugerido: tipoActual == 'todos' ? 'gastoVariable' : tipoActual),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Nueva Categoría'),
                ),
                const SizedBox(width: 16),
              ],
            ),
      floatingActionButton: isMobile
          ? FloatingActionButton.small(
              onPressed: () => _mostrarDialogoCrearEditar(context, ref, tipoSugerido: tipoActual == 'todos' ? 'gastoVariable' : tipoActual),
              tooltip: 'Nueva Categoría',
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: Column(
        children: [
          // Barra de navegación por tipos (Deslizable horizontal para móviles)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.surfaceContainerLowest,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: fila1.map((tab) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildChip(tab),
                    )).toList(),
                  ),
                  const SizedBox(height: 8), // Separación vertical exacta
                  Row(
                    children: fila2.map((tab) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildChip(tab),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Lista de categorías
          Expanded(
            child: categoriasAsync.when(
              data: (lista) {
                if (lista.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.category_outlined,
                    title: 'No hay categorías en este grupo',
                    description: 'Crea tu primera categoría personalizada para organizar tus finanzas o proyectos.',
                    actionLabel: 'Crear Categoría',
                    actionIcon: Icons.add,
                    onAction: () => _mostrarDialogoCrearEditar(context, ref, tipoSugerido: tipoActual == 'todos' ? 'gastoVariable' : tipoActual),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.paddingOf(context).bottom + 88,
            ),
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cat = lista[index];
                    return _CategoriaCardItem(
                      categoria: cat,
                      onEditar: () => _mostrarDialogoCrearEditar(context, ref, categoria: cat),
                      onToggleActiva: (nuevaActiva) async {
                        final dao = ref.read(categoriasDaoProvider);
                        final writer = ref.read(auditedWriterProvider);
                        await dao.toggleActivaCategoria(cat.id, nuevaActiva, writer);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error al cargar categorías: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCrearEditar(
    BuildContext context,
    WidgetRef ref, {
    Categoria? categoria,
    String? tipoSugerido,
  }) {
    showDialog(
      context: context,
      builder: (context) => _DialogoCrearEditarCategoria(
        categoria: categoria,
        tipoSugerido: tipoSugerido,
      ),
    );
  }
}

class _CategoriaCardItem extends StatelessWidget {
  const _CategoriaCardItem({
    required this.categoria,
    required this.onEditar,
    required this.onToggleActiva,
  });

  final Categoria categoria;
  final VoidCallback onEditar;
  final ValueChanged<bool> onToggleActiva;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(categoria.color);
    final iconData = _getIconData(categoria.icono);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: categoria.activa ? theme.colorScheme.outlineVariant : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.18),
          child: Icon(iconData, color: color, size: 22),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                categoria.nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: categoria.activa ? null : TextDecoration.lineThrough,
                  color: categoria.activa ? null : theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (categoria.esSistema)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'SISTEMA',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Text(
          _getTipoNombre(categoria.tipo),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Editar Categoría',
              onPressed: onEditar,
            ),
            Switch(
              value: categoria.activa,
              onChanged: onToggleActiva,
            ),
          ],
        ),
      ),
    );
  }

  String _getTipoNombre(String tipo) {
    switch (tipo) {
      case 'gastoVariable':
        return 'Gasto Variable';
      case 'gastoFijo':
        return 'Gasto Fijo';
      case 'ingreso':
        return 'Ingreso';
      case 'proyecto':
        return 'Proyecto del Hogar';
      default:
        return tipo;
    }
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'build':
        return Icons.build_outlined;
      case 'format_paint':
        return Icons.format_paint_outlined;
      case 'chair':
        return Icons.chair_outlined;
      case 'plumbing':
        return Icons.plumbing_outlined;
      case 'electrical_services':
        return Icons.electrical_services_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'sports_esports':
        return Icons.sports_esports_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'work':
        return Icons.work_outline;
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;
      case 'handyman':
        return Icons.handyman_outlined;
      case 'security':
        return Icons.security_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}

/// Diálogo para crear o editar una Categoría
class _DialogoCrearEditarCategoria extends ConsumerStatefulWidget {
  const _DialogoCrearEditarCategoria({
    this.categoria,
    this.tipoSugerido,
  });

  final Categoria? categoria;
  final String? tipoSugerido;

  @override
  ConsumerState<_DialogoCrearEditarCategoria> createState() => _DialogoCrearEditarCategoriaState();
}

class _DialogoCrearEditarCategoriaState extends ConsumerState<_DialogoCrearEditarCategoria> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late String _tipo;
  late String _iconoSeleccionado;
  late String _colorSeleccionado;
  bool _guardando = false;

  static const List<String> _iconosDisponibles = [
    'category',
    'shopping_cart',
    'restaurant',
    'home',
    'build',
    'format_paint',
    'chair',
    'plumbing',
    'electrical_services',
    'medical_services',
    'directions_car',
    'school',
    'sports_esports',
    'payments',
    'work',
    'cleaning_services',
    'handyman',
    'security',
  ];

  static const List<String> _coloresDisponibles = [
    '#0D5D38', // Verde Nido
    '#15803D', // Verde claro
    '#2563EB', // Azul
    '#0284C7', // Celeste
    '#7C3AED', // Violeta
    '#DB2777', // Fucsia
    '#DC2626', // Rojo
    '#EA580C', // Naranja
    '#D97706', // Ámbar
    '#4B5563', // Gris neutro
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.categoria;
    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _tipo = c?.tipo ?? (widget.tipoSugerido ?? 'gastoVariable');
    _iconoSeleccionado = c?.icono ?? 'category';
    _colorSeleccionado = c?.color ?? '#0D5D38';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.categoria != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 620),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Editar Categoría' : 'Nueva Categoría',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la categoría *',
                            hintText: 'Ej. Supermercado, Albañilería, Pintura...',
                            prefixIcon: Icon(Icons.label_outline_rounded),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _tipo,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Categoría',
                            prefixIcon: Icon(Icons.tune_rounded),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'gastoVariable', child: Text('Gasto Variable')),
                            DropdownMenuItem(value: 'gastoFijo', child: Text('Gasto Fijo')),
                            DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                            DropdownMenuItem(value: 'proyecto', child: Text('Categoría de Proyecto')),
                          ],
                          onChanged: (v) => setState(() => _tipo = v!),
                        ),
                        const SizedBox(height: 20),
                        Text('Selecciona un Ícono', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _iconosDisponibles.map((icoName) {
                            final isSel = _iconoSeleccionado == icoName;
                            return InkWell(
                              onTap: () => setState(() => _iconoSeleccionado = icoName),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSel ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: isSel ? theme.colorScheme.primary : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _resolveIcon(icoName),
                                  color: isSel ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                  size: 22,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text('Color de Identificación', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _coloresDisponibles.map((hex) {
                            final c = _parseColor(hex);
                            final isSel = _colorSeleccionado == hex;
                            return InkWell(
                              onTap: () => setState(() => _colorSeleccionado = hex),
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSel ? theme.colorScheme.onSurface : Colors.white,
                                    width: isSel ? 3 : 1.5,
                                  ),
                                ),
                                child: isSel ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _guardando ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _guardando ? null : _guardar,
                      child: Text(isEditing ? 'Actualizar' : 'Crear Categoría'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final dao = ref.read(categoriasDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    try {
      if (widget.categoria == null) {
        await dao.insertCategoria(
          CategoriasCompanion.insert(
            nombre: _nombreCtrl.text.trim(),
            tipo: _tipo,
            icono: drift.Value(_iconoSeleccionado),
            color: drift.Value(_colorSeleccionado),
          ),
          writer,
        );
      } else {
        await dao.updateCategoria(
          CategoriasCompanion(
            id: drift.Value(widget.categoria!.id),
            nombre: drift.Value(_nombreCtrl.text.trim()),
            tipo: drift.Value(_tipo),
            icono: drift.Value(_iconoSeleccionado),
            color: drift.Value(_colorSeleccionado),
          ),
          writer,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.categoria == null
                  ? 'Categoría creada con éxito.'
                  : 'Categoría actualizada con éxito.',
            ),
            backgroundColor: AppColors.income,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: AppColors.expense),
        );
      }
    }
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'build':
        return Icons.build_outlined;
      case 'format_paint':
        return Icons.format_paint_outlined;
      case 'chair':
        return Icons.chair_outlined;
      case 'plumbing':
        return Icons.plumbing_outlined;
      case 'electrical_services':
        return Icons.electrical_services_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'sports_esports':
        return Icons.sports_esports_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'work':
        return Icons.work_outline;
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;
      case 'handyman':
        return Icons.handyman_outlined;
      case 'security':
        return Icons.security_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
