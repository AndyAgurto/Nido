import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/gastos_fijos_table.dart';
import '../tables/ingresos_fijos_table.dart';
import '../tables/movimientos_table.dart';
import '../tables/cuentas_table.dart';
import '../tables/categorias_table.dart';
import '../../audit/audited_writer.dart';
import '../../audit/audit_entry.dart';

part 'gastos_fijos_dao.g.dart';

/// DAO para plantillas de gastos/ingresos fijos y sus instancias mensuales.
@DriftAccessor(tables: [
  GastosFijos,
  GastosFijosPagos,
  IngresosFijos,
  IngresosFijosCobros,
  Movimientos,
  Cuentas,
  Categorias,
])
class GastosFijosDao extends DatabaseAccessor<AppDatabase>
    with _$GastosFijosDaoMixin {
  GastosFijosDao(super.db);

  Stream<List<GastosFijo>> watchGastosFijosActivos() {
    return (select(gastosFijos)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.diaVencimiento)]))
        .watch();
  }

  Future<List<GastosFijo>> getGastosFijosActivos() {
    return (select(gastosFijos)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.diaVencimiento)]))
        .get();
  }

  Stream<List<IngresosFijo>> watchIngresosFijosActivos() {
    return (select(ingresosFijos)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.diaCobro)]))
        .watch();
  }

  Future<int> insertGastoFijo(
    GastosFijosCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(gastosFijos).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'GastoFijo',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'nombre': companion.nombre.value,
          'montoEstimadoCent': companion.montoEstimadoCent.value,
          'diaVencimiento': companion.diaVencimiento.value,
        },
        resumen: 'Creación de plantilla de gasto fijo "${companion.nombre.value}"',
      ),
    );
  }

  Future<int> insertIngresoFijo(
    IngresosFijosCompanion companion,
    AuditedWriter writer,
  ) {
    return writer.write<int>(
      action: () => into(ingresosFijos).insert(companion),
      auditBuilder: (id) => AuditEntry(
        entidad: 'IngresoFijo',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {
          'nombre': companion.nombre.value,
          'montoEstimadoCent': companion.montoEstimadoCent.value,
          'diaCobro': companion.diaCobro.value,
        },
        resumen: 'Creación de plantilla de ingreso fijo "${companion.nombre.value}"',
      ),
    );
  }

  Stream<List<GastosFijosPago>> watchPagosDelPeriodo(String periodo) {
    return (select(gastosFijosPagos)
          ..where((t) => t.periodo.equals(periodo))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaVencimiento)]))
        .watch();
  }

  Future<List<GastosFijosPago>> getPagosDelPeriodo(String periodo) {
    return (select(gastosFijosPagos)
          ..where((t) => t.periodo.equals(periodo))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaVencimiento)]))
        .get();
  }

  Stream<List<IngresosFijosCobro>> watchCobrosDelPeriodo(String periodo) {
    return (select(ingresosFijosCobros)
          ..where((t) => t.periodo.equals(periodo))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaCobroEsperada)]))
        .watch();
  }

  /// Generación mensual IDEMPOTENTE de instancias de gastos e ingresos fijos.
  /// Si se ejecuta múltiples veces en el mismo periodo (yyyy-MM), no duplicará registros.
  Future<int> generarInstanciasMensuales(
    String periodo,
    AuditedWriter writer,
  ) async {
    // Descomponer periodo 'yyyy-MM'
    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);

    // Último día del mes (ej. febrero 28 o 29)
    final ultimoDiaDelMes = DateTime(anio, mes + 1, 0).day;

    final fijosActivos = await getGastosFijosActivos();
    int generados = 0;

    for (final fijo in fijosActivos) {
      // Verificar si ya existe para este periodo
      final existente = await (select(gastosFijosPagos)
            ..where((t) =>
                t.gastoFijoId.equals(fijo.id) & t.periodo.equals(periodo)))
          .getSingleOrNull();

      if (existente == null) {
        final dia = fijo.diaVencimiento > ultimoDiaDelMes
            ? ultimoDiaDelMes
            : fijo.diaVencimiento;
        final fechaVenc = DateTime(anio, mes, dia);

        await writer.write<int>(
          action: () => into(gastosFijosPagos).insert(
            GastosFijosPagosCompanion.insert(
              gastoFijoId: fijo.id,
              periodo: periodo,
              montoEsperadoCent: fijo.montoEstimadoCent,
              fechaVencimiento: fechaVenc,
              estado: const Value('pendiente'),
            ),
          ),
          auditBuilder: (id) => AuditEntry(
            entidad: 'GastosFijosPago',
            entidadId: id,
            accion: 'crear',
            valorNuevo: {
              'gastoFijoId': fijo.id,
              'periodo': periodo,
              'monto': fijo.montoEstimadoCent,
            },
            resumen: 'Instancia mensual de "${fijo.nombre}" generada para $periodo',
          ),
        );
        generados++;
      }
    }

    // Ingresos fijos
    final ingresosActivos = await (select(ingresosFijos)
          ..where((t) => t.activo.equals(true)))
        .get();

    for (final ing in ingresosActivos) {
      final existente = await (select(ingresosFijosCobros)
            ..where((t) =>
                t.ingresoFijoId.equals(ing.id) & t.periodo.equals(periodo)))
          .getSingleOrNull();

      if (existente == null) {
        final dia = ing.diaCobro > ultimoDiaDelMes
            ? ultimoDiaDelMes
            : ing.diaCobro;
        final fechaCobro = DateTime(anio, mes, dia);

        await writer.write<int>(
          action: () => into(ingresosFijosCobros).insert(
            IngresosFijosCobrosCompanion.insert(
              ingresoFijoId: ing.id,
              periodo: periodo,
              montoEsperadoCent: ing.montoEstimadoCent,
              fechaCobroEsperada: fechaCobro,
              estado: const Value('pendiente'),
            ),
          ),
          auditBuilder: (id) => AuditEntry(
            entidad: 'IngresosFijosCobro',
            entidadId: id,
            accion: 'crear',
            valorNuevo: {
              'ingresoFijoId': ing.id,
              'periodo': periodo,
            },
            resumen: 'Instancia mensual de ingreso "${ing.nombre}" para $periodo',
          ),
        );
        generados++;
      }
    }

    return generados;
  }

  /// Acción transaccional "Marcar Pagado":
  /// 1. Crea el Movimiento de gasto vinculado a la cuenta y categoría.
  /// 2. Asocia el movimiento a la instancia de pago y cambia su estado a 'pagado'.
  /// 3. Audita la operación con [AuditedWriter].
  Future<void> marcarGastoFijoPagado({
    required int pagoId,
    required int cuentaId,
    required int montoRealCent,
    required DateTime fechaPago,
    required AuditedWriter writer,
  }) async {
    final pago = await (select(gastosFijosPagos)
          ..where((t) => t.id.equals(pagoId)))
        .getSingleOrNull();
    if (pago == null) throw ArgumentError('Pago fijo no encontrado');

    final plantilla = await (select(gastosFijos)
          ..where((t) => t.id.equals(pago.gastoFijoId)))
        .getSingle();

    await writer.write<void>(
      action: () async {
        // 1. Crear movimiento de gasto
        final movId = await into(movimientos).insert(
          MovimientosCompanion.insert(
            fecha: fechaPago,
            tipo: 'gasto',
            montoCent: montoRealCent,
            cuentaOrigenId: cuentaId,
            categoriaId: Value(plantilla.categoriaId),
            gastoFijoPagoId: Value(pago.id),
            descripcion: 'Pago fijo: ${plantilla.nombre} (${pago.periodo})',
          ),
        );

        // 2. Actualizar estado del pago a 'pagado'
        await (update(gastosFijosPagos)..where((t) => t.id.equals(pagoId))).write(
          GastosFijosPagosCompanion(
            estado: const Value('pagado'),
            movimientoId: Value(movId),
            actualizadoEn: Value(DateTime.now()),
          ),
        );
      },
      auditBuilder: (_) => AuditEntry(
        entidad: 'GastosFijosPago',
        entidadId: pagoId,
        accion: 'editar',
        valorAnterior: {'estado': pago.estado},
        valorNuevo: {
          'estado': 'pagado',
          'montoPagadoCent': montoRealCent,
        },
        resumen: 'Pago realizado para gasto fijo "${plantilla.nombre}" en periodo ${pago.periodo}',
      ),
    );
  }
}