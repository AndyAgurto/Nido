import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categorias_table.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

part 'categorias_dao.g.dart';

/// DAO para gestión de Categorías de movimientos.
@DriftAccessor(tables: [Categorias])
class CategoriasDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriasDaoMixin {
  CategoriasDao(super.db);

  Stream<List<Categoria>> watchCategorias({
    String? tipo,
    bool soloActivas = true,
  }) {
    var query = select(categorias);
    if (soloActivas) {
      query = query..where((t) => t.activa.equals(true));
    }
    if (tipo != null) {
      query = query..where((t) => t.tipo.equals(tipo));
    }
    query = query..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return query.watch();
  }

  Future<List<Categoria>> getCategorias({
    String? tipo,
    bool soloActivas = true,
  }) {
    var query = select(categorias);
    if (soloActivas) {
      query = query..where((t) => t.activa.equals(true));
    }
    if (tipo != null) {
      query = query..where((t) => t.tipo.equals(tipo));
    }
    query = query..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return query.get();
  }

  Future<int> insertCategoria(
    CategoriasCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(categorias).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Categoria',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'nombre': companion.nombre.value,
          'tipo': companion.tipo.value,
        },
        resumen: 'Creación de categoría "${companion.nombre.value}" (${companion.tipo.value})',
      ),
    );
  }

  Future<Categoria?> getCategoriaById(int id) {
    return (select(categorias)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<bool> updateCategoria(
    CategoriasCompanion companion,
    AuditedWriter writer,
  ) async {
    final anterior = await getCategoriaById(companion.id.value);
    final rows = await writer.write<int>(
      action: () => (update(categorias)..where((t) => t.id.equals(companion.id.value))).write(
        companion.copyWith(actualizadoEn: Value(DateTime.now())),
      ),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Categoria',
        entidadId: companion.id.value,
        accion: 'editar',
        valorAnterior: anterior != null
            ? {
                'nombre': anterior.nombre,
                'tipo': anterior.tipo,
                'icono': anterior.icono,
                'color': anterior.color,
                'activa': anterior.activa,
              }
            : null,
        valorNuevo: {
          'nombre': companion.nombre.present ? companion.nombre.value : anterior?.nombre,
          'tipo': companion.tipo.present ? companion.tipo.value : anterior?.tipo,
          'icono': companion.icono.present ? companion.icono.value : anterior?.icono,
          'color': companion.color.present ? companion.color.value : anterior?.color,
          'activa': companion.activa.present ? companion.activa.value : anterior?.activa,
        },
        resumen: 'Actualización de categoría "${companion.nombre.present ? companion.nombre.value : (anterior?.nombre ?? '')}"',
      ),
    );
    return rows > 0;
  }

  Future<bool> toggleActivaCategoria(
    int id,
    bool activa,
    AuditedWriter writer,
  ) async {
    final anterior = await getCategoriaById(id);
    if (anterior == null) return false;

    final rows = await writer.write<int>(
      action: () => (update(categorias)..where((t) => t.id.equals(id))).write(
        CategoriasCompanion(
          activa: Value(activa),
          actualizadoEn: Value(DateTime.now()),
        ),
      ),
      auditBuilder: (_) => AuditEntry(
        entidad: 'Categoria',
        entidadId: id,
        accion: activa ? 'activar' : 'desactivar',
        valorAnterior: {'activa': anterior.activa},
        valorNuevo: {'activa': activa},
        resumen: '${activa ? "Activación" : "Desactivación"} de categoría "${anterior.nombre}"',
      ),
    );
    return rows > 0;
  }
}