import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cuentas_table.dart';
import '../tables/movimientos_table.dart';
import '../../money/money.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

part 'cuentas_dao.g.dart';

/// DAO para gestión de Cuentas y cálculo dinámico de saldos derivados.
@DriftAccessor(tables: [Cuentas, Movimientos])
class CuentasDao extends DatabaseAccessor<AppDatabase> with _$CuentasDaoMixin {
  CuentasDao(super.db);

  Stream<List<Cuenta>> watchCuentasActivas() {
    return (select(cuentas)
          ..where((t) => t.activa.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .watch();
  }

  Future<List<Cuenta>> getAllCuentas() {
    return (select(cuentas)..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<Cuenta?> getCuentaById(int id) {
    return (select(cuentas)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Money> calcularSaldoCuenta(int cuentaId) async {
    final cuenta = await getCuentaById(cuentaId);
    if (cuenta == null) return Money.zero;

    final movs = await (select(movimientos)
          ..where((t) =>
              t.anulado.equals(false) &
              (t.cuentaOrigenId.equals(cuentaId) |
                  t.cuentaDestinoId.equals(cuentaId))))
        .get();

    int balanceCent = cuenta.saldoInicialCent;

    for (final m in movs) {
      if (m.tipo == 'ingreso' && m.cuentaOrigenId == cuentaId) {
        balanceCent += m.montoCent;
      } else if (m.tipo == 'gasto' && m.cuentaOrigenId == cuentaId) {
        balanceCent -= m.montoCent;
      } else if (m.tipo == 'transferencia') {
        if (m.cuentaOrigenId == cuentaId) {
          balanceCent -= m.montoCent;
        }
        if (m.cuentaDestinoId == cuentaId) {
          balanceCent += m.montoCent;
        }
      }
    }

    return Money.fromCents(balanceCent);
  }

  Future<Money> calcularDineroActualTotal() async {
    final cuentasList = await (select(cuentas)..where((t) => t.activa.equals(true))).get();
    int totalCents = 0;

    for (final c in cuentasList) {
      final saldo = await calcularSaldoCuenta(c.id);
      totalCents += saldo.cents;
    }

    return Money.fromCents(totalCents);
  }

  Future<int> insertCuenta(
    CuentasCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(cuentas).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Cuenta',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'nombre': companion.nombre.value,
          'tipo': companion.tipo.value,
          'saldoInicialCent': companion.saldoInicialCent.value,
        },
        resumen: 'Creación de cuenta "${companion.nombre.value}" con saldo inicial ${companion.saldoInicialCent.value} céntimos',
      ),
    );
  }

  Future<bool> updateCuenta(
    Cuenta anterior,
    CuentasCompanion nuevo,
    AuditedWriter writer,
  ) {
    return writer.write<bool>(
      action: () => update(cuentas).replace(
        anterior.copyWith(
          nombre: nuevo.nombre.present ? nuevo.nombre.value : anterior.nombre,
          tipo: nuevo.tipo.present ? nuevo.tipo.value : anterior.tipo,
          color: nuevo.color.present ? nuevo.color.value : anterior.color,
          icono: nuevo.icono.present ? nuevo.icono.value : anterior.icono,
          activa: nuevo.activa.present ? nuevo.activa.value : anterior.activa,
          saldoInicialCent: nuevo.saldoInicialCent.present ? nuevo.saldoInicialCent.value : anterior.saldoInicialCent,
          actualizadoEn: DateTime.now(),
        ),
      ),
      auditBuilder: (success) => AuditEntry(
        entidad: 'Cuenta',
        entidadId: anterior.id,
        accion: 'editar',
        valorAnterior: {
          'nombre': anterior.nombre,
          'tipo': anterior.tipo,
          'activa': anterior.activa,
          'saldoInicialCent': anterior.saldoInicialCent,
        },
        valorNuevo: {
          'nombre': nuevo.nombre.present ? nuevo.nombre.value : anterior.nombre,
          'tipo': nuevo.tipo.present ? nuevo.tipo.value : anterior.tipo,
          'activa': nuevo.activa.present ? nuevo.activa.value : anterior.activa,
          'saldoInicialCent': nuevo.saldoInicialCent.present ? nuevo.saldoInicialCent.value : anterior.saldoInicialCent,
        },
        resumen: 'Actualización de cuenta "${anterior.nombre}"',
      ),
    );
  }
}