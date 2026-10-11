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
}