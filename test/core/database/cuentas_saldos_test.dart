import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
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

  group('CuentasDao - Regla de Oro: Cálculo Dinámico de Saldos', () {
    test('El saldo inicial de la cuenta se refleja correctamente sin movimientos', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Ahorro BCP',
          tipo: 'ahorro',
          saldoInicialCent: const Value(100000), // S/ 1,000.00
        ),
        writer,
      );

      final saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(100000));
      expect(saldo.format(), 'S/ 1,000.00');
    });

    test('Ingresos y gastos modifican dinámicamente el saldo calculado', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta Corriente',
          tipo: 'banco',
          saldoInicialCent: const Value(20000), // S/ 200.00
        ),
        writer,
      );

      // 1. Ingreso de S/ 500.00 (50000 céntimos)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'ingreso',
          montoCent: 50000,
          cuentaOrigenId: cuentaId,
          descripcion: 'Sueldo quincena',
        ),
        writer,
      );

      var saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(70000)); // 200 + 500 = 700

      // 2. Gasto de S/ 150.50 (15050 céntimos)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'gasto',
          montoCent: 15050,
          cuentaOrigenId: cuentaId,
          descripcion: 'Supermercado',
        ),
        writer,
      );

      saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(54950)); // 700 - 150.50 = 549.50
      expect(saldo.format(), 'S/ 549.50');
    });

    test('Transferencias descuentan de origen y abonan a destino', () async {
      final cuentaOrigen = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
          saldoInicialCent: const Value(30000), // S/ 300.00
        ),
        writer,
      );

      final cuentaDestino = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Billetera Digital',
          tipo: 'banco',
          saldoInicialCent: const Value(5000), // S/ 50.00
        ),
        writer,
      );

      // Transferencia de S/ 100.00 de Efectivo a Billetera Digital
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'transferencia',
          montoCent: 10000,
          cuentaOrigenId: cuentaOrigen,
          cuentaDestinoId: Value(cuentaDestino),
          descripcion: 'Recarga de billetera digital',
        ),
        writer,
      );

      final saldoOrigen = await db.cuentasDao.calcularSaldoCuenta(cuentaOrigen);
      final saldoDestino = await db.cuentasDao.calcularSaldoCuenta(cuentaDestino);

      expect(saldoOrigen, const Money.fromCents(20000)); // 300 - 100 = 200
      expect(saldoDestino, const Money.fromCents(15000)); // 50 + 100 = 150
    });

    test('Anulación lógica: excluye de inmediato el movimiento del saldo', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Caja Fuerte',
          tipo: 'efectivo',
          saldoInicialCent: const Value(100000), // S/ 1,000.00
        ),
        writer,
      );

      // Gasto de S/ 400.00
      final movGastoId = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'gasto',
          montoCent: 40000,
          cuentaOrigenId: cuentaId,
          descripcion: 'Compra errónea',
        ),
        writer,
      );

      var saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(60000)); // 1000 - 400 = 600

      // Anulamos el movimiento
      final anuladoOk = await db.movimientosDao.anularMovimiento(
        movGastoId,
        motivo: 'Compra cancelada por el comercio',
        writer: writer,
      );
      expect(anuladoOk, isTrue);

      // El saldo debe recalcularse como si el movimiento no existiera
      saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(100000)); // Vuelve a 1,000.00

      // Restauramos el movimiento
      final restauradoOk = await db.movimientosDao.restaurarMovimiento(
        movGastoId,
        writer: writer,
      );
      expect(restauradoOk, isTrue);

      // El gasto vuelve a computar
      saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(60000));
    });

    test('calcularDineroActualTotal suma todas las cuentas activas', () async {
      await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta A',
          tipo: 'banco',
          saldoInicialCent: const Value(50000), // S/ 500.00
        ),
        writer,
      );
      await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta B',
          tipo: 'efectivo',
          saldoInicialCent: const Value(25000), // S/ 250.00
        ),
        writer,
      );

      final total = await db.cuentasDao.calcularDineroActualTotal();
      expect(total, const Money.fromCents(75000)); // S/ 750.00
      expect(total.format(), 'S/ 750.00');
    });
  });
}