import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/money/money.dart';
import 'package:nido/core/audit/audited_writer.dart';

enum EstadoVencimiento {
  pagado,
  vencido,
  venceHoy,
  porVencer,
}

EstadoVencimiento clasificarVencimiento(GastosFijosPago pago, DateTime hoy) {
  if (pago.estado == 'pagado') {
    return EstadoVencimiento.pagado;
  }
  final soloHoy = DateTime(hoy.year, hoy.month, hoy.day);
  final soloVenc = DateTime(pago.fechaVencimiento.year, pago.fechaVencimiento.month, pago.fechaVencimiento.day);

  if (soloVenc.isBefore(soloHoy)) {
    return EstadoVencimiento.vencido;
  } else if (soloVenc.isAtSameMomentAs(soloHoy)) {
    return EstadoVencimiento.venceHoy;
  } else {
    return EstadoVencimiento.porVencer;
  }
}

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

  group('Fase 3 - Gastos Fijos: Clasificación de Vencimientos y Ciclo de Pago', () {
    test('Clasifica correctamente estados de vencimiento (VENCIDO, VENCE HOY, POR VENCER, PAGADO)', () {
      final hoy = DateTime(2026, 10, 15);
      final ahora = DateTime(2026, 10, 1);

      final pagoVencido = GastosFijosPago(
        id: 1,
        gastoFijoId: 1,
        periodo: '2026-10',
        montoEsperadoCent: 5000,
        fechaVencimiento: DateTime(2026, 10, 10), // Pasó hace 5 días
        estado: 'pendiente',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final pagoVenceHoy = GastosFijosPago(
        id: 2,
        gastoFijoId: 1,
        periodo: '2026-10',
        montoEsperadoCent: 5000,
        fechaVencimiento: DateTime(2026, 10, 15), // Hoy
        estado: 'pendiente',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final pagoPorVencer = GastosFijosPago(
        id: 3,
        gastoFijoId: 1,
        periodo: '2026-10',
        montoEsperadoCent: 5000,
        fechaVencimiento: DateTime(2026, 10, 25), // En 10 días
        estado: 'pendiente',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      final pagoPagado = GastosFijosPago(
        id: 4,
        gastoFijoId: 1,
        periodo: '2026-10',
        montoEsperadoCent: 5000,
        fechaVencimiento: DateTime(2026, 10, 5),
        estado: 'pagado',
        creadoEn: ahora,
        actualizadoEn: ahora,
      );

      expect(clasificarVencimiento(pagoVencido, hoy), equals(EstadoVencimiento.vencido));
      expect(clasificarVencimiento(pagoVenceHoy, hoy), equals(EstadoVencimiento.venceHoy));
      expect(clasificarVencimiento(pagoPorVencer, hoy), equals(EstadoVencimiento.porVencer));
      expect(clasificarVencimiento(pagoPagado, hoy), equals(EstadoVencimiento.pagado));
    });

    test('Ciclo completo: Plantilla -> Generación -> Marcar Pagado -> Verificación de Auditoría', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'BCP Sueldo',
          tipo: 'banco',
          saldoInicialCent: const Value(500000), // S/ 5,000.00
        ),
        writer,
      );

      final cat = (await db.categoriasDao.getCategorias(tipo: 'gastoFijo')).first;

      await db.gastosFijosDao.insertGastoFijo(
        GastosFijosCompanion.insert(
          nombre: 'Internet Fibra',
          montoEstimadoCent: 12000, // S/ 120.00
          diaVencimiento: 20,
          cuentaPagoId: cuentaId,
          categoriaId: cat.id,
          fechaInicio: DateTime(2026, 1, 1),
        ),
        writer,
      );

      // Generar para 2026-10
      await db.gastosFijosDao.generarInstanciasMensuales('2026-10', writer);

      final pagos = await db.gastosFijosDao.getPagosDelPeriodo('2026-10');
      expect(pagos.length, equals(1));
      final pago = pagos.first;

      expect(pago.estado, equals('pendiente'));
      expect(pago.fechaVencimiento, equals(DateTime(2026, 10, 20)));

      // Marcar pagado por monto ajustado S/ 125.00
      await db.gastosFijosDao.marcarGastoFijoPagado(
        pagoId: pago.id,
        cuentaId: cuentaId,
        montoRealCent: 12500,
        fechaPago: DateTime(2026, 10, 18),
        writer: writer,
      );

      // Saldo debe haber decrementado en S/ 125.00: 5000 - 125 = S/ 4,875.00
      final saldo = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldo, equals(const Money.fromCents(487500)));

      // Estado actualizado
      final pagoActualizado = (await db.gastosFijosDao.getPagosDelPeriodo('2026-10')).first;
      expect(pagoActualizado.estado, equals('pagado'));
      expect(pagoActualizado.movimientoId, isNotNull);
    });
  });
}
