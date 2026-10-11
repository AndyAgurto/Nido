import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/money/money.dart';

void main() {
  late AppDatabase db;
  late AuditedWriter writer;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = AuditedWriter(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 3 - Gastos e Ingresos Fijos', () {
    test('Generación mensual idempotente: no duplica pagos para el mismo periodo', () async {
      // Obtenemos una categoría de gasto fijo
      final cat = (await db.categoriasDao.getCategorias(tipo: 'gastoFijo')).first;

      // Creamos una cuenta
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'BCP Principal',
          tipo: 'banco',
          saldoInicialCent: const Value(150000), // S/ 1,500.00
        ),
        writer,
      );

      // Creamos una plantilla de gasto fijo (ej. Internet S/ 120.00)
      await db.gastosFijosDao.insertGastoFijo(
        GastosFijosCompanion.insert(
          nombre: 'Internet Fibra',
          montoEstimadoCent: 12000,
          categoriaId: cat.id,
          cuentaPagoId: cuentaId,
          diaVencimiento: 15,
          fechaInicio: DateTime(2026, 1, 1),
        ),
        writer,
      );

      // 1. Primera ejecución para periodo 2026-10: debe generar 1 instancia
      final primeraGen = await db.gastosFijosDao.generarInstanciasMensuales('2026-10', writer);
      expect(primeraGen, 1);

      final pagos10 = await db.gastosFijosDao.getPagosDelPeriodo('2026-10');
      expect(pagos10.length, 1);
      expect(pagos10.first.montoEsperadoCent, 12000);
      expect(pagos10.first.estado, 'pendiente');

      // 2. Segunda ejecución para el MISMO periodo 2026-10: debe ser IDEMPOTENTE (0 generados)
      final segundaGen = await db.gastosFijosDao.generarInstanciasMensuales('2026-10', writer);
      expect(segundaGen, 0);

      final pagos10Repetido = await db.gastosFijosDao.getPagosDelPeriodo('2026-10');
      expect(pagos10Repetido.length, 1); // No duplicado
    });

    test('Marcar Pagado: crea movimiento vinculado, actualiza estado y descuenta saldo', () async {
      final cat = (await db.categoriasDao.getCategorias(tipo: 'gastoFijo')).first;
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta Sueldo',
          tipo: 'banco',
          saldoInicialCent: const Value(100000), // S/ 1,000.00
        ),
        writer,
      );

      await db.gastosFijosDao.insertGastoFijo(
        GastosFijosCompanion.insert(
          nombre: 'Servicio de Luz',
          montoEstimadoCent: 8500, // S/ 85.00
          categoriaId: cat.id,
          cuentaPagoId: cuentaId,
          diaVencimiento: 20,
          fechaInicio: DateTime(2026, 1, 1),
        ),
        writer,
      );

      await db.gastosFijosDao.generarInstanciasMensuales('2026-10', writer);
      final pago = (await db.gastosFijosDao.getPagosDelPeriodo('2026-10')).first;
      expect(pago.estado, 'pendiente');

      // Saldo antes del pago
      var saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(100000));

      // Acción "Marcar Pagado"
      await db.gastosFijosDao.marcarGastoFijoPagado(
        pagoId: pago.id,
        cuentaId: cuentaId,
        montoRealCent: 8900, // Pagó S/ 89.00
        fechaPago: DateTime(2026, 10, 20),
        writer: writer,
      );

      // Verificamos que el pago cambió a 'pagado' y tiene movimiento vinculado
      final pagoActualizado = (await db.gastosFijosDao.getPagosDelPeriodo('2026-10')).first;
      expect(pagoActualizado.estado, 'pagado');
      expect(pagoActualizado.movimientoId, isNotNull);

      // Verificamos que el movimiento existe en la tabla movimientos
      final mov = await db.movimientosDao.getMovimientoById(pagoActualizado.movimientoId!);
      expect(mov, isNotNull);
      expect(mov!.montoCent, 8900);
      expect(mov.gastoFijoPagoId, pago.id);
      expect(mov.descripcion, contains('Servicio de Luz'));

      // Verificamos que el saldo de la cuenta se redujo dinámicamente
      saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(91100)); // 1000 - 89 = S/ 911.00
    });
  });
}