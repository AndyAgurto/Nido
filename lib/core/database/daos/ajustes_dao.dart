import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/ajustes_table.dart';

part 'ajustes_dao.g.dart';

/// DAO para configuración y ajustes clave-valor.
@DriftAccessor(tables: [Ajustes])
class AjustesDao extends DatabaseAccessor<AppDatabase> with _$AjustesDaoMixin {
  AjustesDao(super.db);

  Future<String?> getValor(String clave) async {
    final record = await (select(ajustes)..where((t) => t.clave.equals(clave)))
        .getSingleOrNull();
    return record?.valor;
  }

  Future<void> setValor(String clave, String valor) async {
    await into(ajustes).insertOnConflictUpdate(
      AjustesCompanion.insert(
        clave: clave,
        valor: valor,
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  Stream<String?> watchValor(String clave) {
    return (select(ajustes)..where((t) => t.clave.equals(clave)))
        .watchSingleOrNull()
        .map((record) => record?.valor);
  }
}