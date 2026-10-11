import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';

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

  group('Fase 3 - Presupuestos Mensuales', () {
    test('Asignar presupuesto por categoría y periodo', () async {
      final cat = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;

      await db.presupuestosDao.setPresupuesto(
        periodo: '2026-10',
        categoriaId: cat.id,
        montoCent: 50000, // S/ 500.00
        writer: writer,
      );

      final presupuestos = await db.presupuestosDao.getPresupuestosDelPeriodo('2026-10');
      expect(presupuestos.length, 1);
      expect(presupuestos.first.categoriaId, cat.id);
      expect(presupuestos.first.montoCent, 50000);
    });

    test('Cálculo de ejecución de gasto en periodo', () async {
      final cat = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
          saldoInicialCent: const Value(100000),
        ),
        writer,
      );

      // Presupuesto: S/ 400.00 (40000 céntimos)
      await db.presupuestosDao.setPresupuesto(
        periodo: '2026-10',
        categoriaId: cat.id,
        montoCent: 40000,
        writer: writer,
      );

      // Gasto 1: S/ 250.00 en octubre 2026
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime(2026, 10, 5),
          tipo: 'gasto',
          montoCent: 25000,
          cuentaOrigenId: cuentaId,
          categoriaId: Value(cat.id),
          descripcion: 'Supermercado 1',
        ),
        writer,
      );

      // Gasto 2: S/ 80.00 en octubre 2026
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime(2026, 10, 12),
          tipo: 'gasto',
          montoCent: 8000,
          cuentaOrigenId: cuentaId,
          categoriaId: Value(cat.id),
          descripcion: 'Supermercado 2',
        ),
        writer,
      );

      // Gasto en septiembre (no debe sumar a octubre)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: DateTime(2026, 9, 28),
          tipo: 'gasto',
          montoCent: 10000,
          cuentaOrigenId: cuentaId,
          categoriaId: Value(cat.id),
          descripcion: 'Gasto de mes anterior',
        ),
        writer,
      );

      final totalGastado = await db.presupuestosDao.calcularGastoCategoriaEnPeriodo(cat.id, '2026-10');
      expect(totalGastado, 33000); // 250 + 80 = S/ 330.00

      // Porcentaje de ejecución: 33000 / 40000 = 82.5% (Alerta de >= 80%)
      final ejecucion = totalGastado / 40000;
      expect(ejecucion >= 0.8 && ejecucion < 1.0, isTrue);
    });

    test('Copiar presupuestos del mes anterior a nuevo mes', () async {
      final cats = await db.categoriasDao.getCategorias(tipo: 'gastoVariable');
      final cat1 = cats[0];
      final cat2 = cats[1];

      // Fijamos presupuesto en 2026-09
      await db.presupuestosDao.setPresupuesto(
        periodo: '2026-09',
        categoriaId: cat1.id,
        montoCent: 30000,
        writer: writer,
      );
      await db.presupuestosDao.setPresupuesto(
        periodo: '2026-09',
        categoriaId: cat2.id,
        montoCent: 20000,
        writer: writer,
      );

      // Copiamos de 2026-09 a 2026-10
      final copiados = await db.presupuestosDao.copiarPresupuestosDelMesAnterior(
        periodoOrigen: '2026-09',
        periodoDestino: '2026-10',
        writer: writer,
      );
      expect(copiados, 2);

      final enOctubre = await db.presupuestosDao.getPresupuestosDelPeriodo('2026-10');
      expect(enOctubre.length, 2);
      expect(enOctubre.any((p) => p.categoriaId == cat1.id && p.montoCent == 30000), isTrue);
      expect(enOctubre.any((p) => p.categoriaId == cat2.id && p.montoCent == 20000), isTrue);
    });
  });
}