import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/audit/audit_service.dart';
import 'package:nido/core/money/money.dart';

void main() {
  late AppDatabase db;
  late AuditedWriter writer;
  late AuditService auditService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = AuditedWriter(db);
    auditService = AuditService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 2 - Movimientos: Anulación y Trazabilidad de Auditoría', () {
    test('Anulación de Ingreso descuenta del saldo y registra en bitácora de auditoría', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta BBVA',
          tipo: 'banco',
          saldoInicialCent: const Value(10000), // S/ 100.00
        ),
        writer,
      );

      final movId = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'ingreso',
          montoCent: 5000, // S/ 50.00
          cuentaOrigenId: cuentaId,
          descripcion: 'Depósito erróneo',
        ),
        writer,
      );

      var saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(15000));

      // Anular ingreso con motivo
      const motivo = 'Depósito no correspondía al titular';
      final ok = await db.movimientosDao.anularMovimiento(
        movId,
        motivo: motivo,
        writer: writer,
      );
      expect(ok, isTrue);

      // El saldo vuelve a ser S/ 100.00
      saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, const Money.fromCents(10000));

      // Verificar que el movimiento tiene los campos de anulación
      final mov = await db.movimientosDao.getMovimientoById(movId);
      expect(mov, isNotNull);
      expect(mov!.anulado, isTrue);
      expect(mov.motivoAnulacion, motivo);
      expect(mov.anuladoEn, isNotNull);

      // Verificar registro de auditoría
      final auditorias = await auditService.getAuditoria(entidad: 'Movimiento', entidadId: movId);
      expect(auditorias.length, greaterThanOrEqualTo(2)); // Crear + Anular
      final auditAnulacion = auditorias.firstWhere((a) => a.accion == 'anular');
      expect(auditAnulacion.resumen, contains(motivo));
      final jsonNuevo = jsonDecode(auditAnulacion.valorNuevoJson!) as Map<String, dynamic>;
      expect(jsonNuevo['anulado'], isTrue);
      expect(jsonNuevo['motivoAnulacion'], motivo);
    });

    test('Anulación de Transferencia reversa saldos en ambas cuentas', () async {
      final origenId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Origen',
          tipo: 'banco',
          saldoInicialCent: const Value(50000), // S/ 500.00
        ),
        writer,
      );

      final destinoId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Destino',
          tipo: 'ahorro',
          saldoInicialCent: const Value(10000), // S/ 100.00
        ),
        writer,
      );

      final transId = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime.now(),
          tipo: 'transferencia',
          montoCent: 20000, // S/ 200.00
          cuentaOrigenId: origenId,
          cuentaDestinoId: Value(destinoId),
          descripcion: 'Ahorro programado',
        ),
        writer,
      );

      expect(await db.cuentasDao.calcularSaldoCuenta(origenId), const Money.fromCents(30000));
      expect(await db.cuentasDao.calcularSaldoCuenta(destinoId), const Money.fromCents(30000));

      // Anular transferencia
      await db.movimientosDao.anularMovimiento(
        transId,
        motivo: 'Transferencia duplicada por error',
        writer: writer,
      );

      // Se restablecen los saldos originales
      expect(await db.cuentasDao.calcularSaldoCuenta(origenId), const Money.fromCents(50000));
      expect(await db.cuentasDao.calcularSaldoCuenta(destinoId), const Money.fromCents(10000));

      // Restaurar transferencia
      await db.movimientosDao.restaurarMovimiento(transId, writer: writer);
      expect(await db.cuentasDao.calcularSaldoCuenta(origenId), const Money.fromCents(30000));
      expect(await db.cuentasDao.calcularSaldoCuenta(destinoId), const Money.fromCents(30000));
    });

    test('Filtros y búsqueda en stream de movimientos', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
          saldoInicialCent: const Value(100000),
        ),
        writer,
      );

      final mov1 = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime(2026, 10, 5),
          tipo: 'gasto',
          montoCent: 4500,
          cuentaOrigenId: cuentaId,
          descripcion: 'Farmacia compra medicinas',
        ),
        writer,
      );

      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime(2026, 10, 8),
          tipo: 'gasto',
          montoCent: 8000,
          cuentaOrigenId: cuentaId,
          descripcion: 'Supermercado semanal',
        ),
        writer,
      );

      // Búsqueda por término
      final resultados = await db.movimientosDao.watchMovimientos(busqueda: 'medicinas').first;
      expect(resultados.length, 1);
      expect(resultados.first.descripcion, contains('Farmacia'));

      // Anulamos mov1
      await db.movimientosDao.anularMovimiento(mov1, motivo: 'Devolución', writer: writer);

      // Por defecto no incluye anulados
      final activos = await db.movimientosDao.watchMovimientos(busqueda: 'medicinas').first;
      expect(activos.isEmpty, isTrue);

      // Con flag incluirAnulados = true
      final todos = await db.movimientosDao.watchMovimientos(busqueda: 'medicinas', incluirAnulados: true).first;
      expect(todos.length, 1);
      expect(todos.first.anulado, isTrue);
    });
  });
}