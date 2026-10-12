import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/features/reportes/data/exportar_csv_service.dart';
import 'package:nido/features/reportes/data/exportar_pdf_service.dart';

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

  group('Fase 5 - Dashboard: Resumen Financiero y Regla de Oro Nido', () {
    test('calcularResumenMensual agrupa ingresos, fijos, variables, proyectos y disponible', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta Principal',
          tipo: 'banco',
          saldoInicialCent: const Value(1000000), // S/ 10,000.00
        ),
        writer,
      );

      final catGasto = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;
      final catIngreso = (await db.categoriasDao.getCategorias(tipo: 'ingreso')).first;

      // 1. Ingreso de S/ 6,000.00 en Octubre 2026
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catIngreso.id),
          tipo: 'ingreso',
          montoCent: 600000,
          fecha: DateTime(2026, 10, 5),
          descripcion: 'Sueldo mensual',
        ),
        writer,
      );

      // 2. Gasto fijo de S/ 1,500.00 en Octubre 2026 (con gastoFijoPagoId)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 150000,
          fecha: DateTime(2026, 10, 10),
          descripcion: 'Alquiler departamento',
          gastoFijoPagoId: const Value(1),
        ),
        writer,
      );

      // 3. Aporte a proyecto de S/ 800.00 en Octubre 2026 (con partidaId)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 80000,
          fecha: DateTime(2026, 10, 15),
          descripcion: 'Pintura y brochas para proyecto',
          partidaId: const Value(1),
        ),
        writer,
      );

      // 4. Gasto variable de S/ 1,200.00 en Octubre 2026 (sin fijo ni proyecto)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 120000,
          fecha: DateTime(2026, 10, 20),
          descripcion: 'Supermercado semanal',
        ),
        writer,
      );

      // 5. Gasto anulado de S/ 500.00 (no debe contar)
      final movAnularId = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 50000,
          fecha: DateTime(2026, 10, 22),
          descripcion: 'Error de cobro',
        ),
        writer,
      );
      await db.movimientosDao.anularMovimiento(
        movAnularId,
        motivo: 'Cobro duplicado por el banco',
        writer: writer,
      );

      final resumen = await db.movimientosDao.calcularResumenMensual('2026-10');

      expect(resumen.ingresos.cents, 600000); // S/ 6,000.00
      expect(resumen.gastosFijos.cents, 150000); // S/ 1,500.00
      expect(resumen.aportesProyectos.cents, 80000); // S/ 800.00
      expect(resumen.gastosVariables.cents, 120000); // S/ 1,200.00
      expect(resumen.gastosTotales.cents, 350000); // S/ 3,500.00
      expect(resumen.disponible.cents, 250000); // S/ 2,500.00
      expect((resumen.porcentajeDisponible * 100).round(), 42); // ~41.67%
    });

    test('Comparación frente al mes anterior calcula delta en Soles y variación porcentual', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Cuenta Corriente',
          tipo: 'banco',
          saldoInicialCent: const Value(500000),
        ),
        writer,
      );
      final catGasto = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;
      final catIngreso = (await db.categoriasDao.getCategorias(tipo: 'ingreso')).first;

      // Mes anterior: Septiembre 2026 (Ingreso 5,000, Gasto 3,000 -> Disponible 2,000)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catIngreso.id),
          tipo: 'ingreso',
          montoCent: 500000,
          fecha: DateTime(2026, 9, 15),
          descripcion: 'Ingreso Septiembre',
        ),
        writer,
      );
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 300000,
          fecha: DateTime(2026, 9, 20),
          descripcion: 'Gasto Septiembre',
        ),
        writer,
      );

      // Mes actual: Octubre 2026 (Ingreso 6,000, Gasto 3,500 -> Disponible 2,500)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catIngreso.id),
          tipo: 'ingreso',
          montoCent: 600000,
          fecha: DateTime(2026, 10, 10),
          descripcion: 'Ingreso Octubre',
        ),
        writer,
      );
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 350000,
          fecha: DateTime(2026, 10, 15),
          descripcion: 'Gasto Octubre',
        ),
        writer,
      );

      final resumen = await db.movimientosDao.calcularResumenMensual('2026-10');
      expect(resumen.mesAnterior, isNotNull);

      // Delta disponible: 2,500 - 2,000 = +S/ 500.00 (50,000 cts)
      expect(resumen.deltaDisponible.cents, 50000);
      // Variación % disponible: +25%
      expect(resumen.variacionDisponiblePct, 0.25);
      // Delta ingresos: 6,000 - 5,000 = +S/ 1,000.00 (+20%)
      expect(resumen.deltaIngresos.cents, 100000);
      expect(resumen.variacionIngresosPct, 0.20);
    });
  });

  group('Fase 5 - Distribución por Categoría y Tendencia Histórica', () {
    test('obtenerGastosPorCategoria calcula montos y porcentajes exactos ordenados', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Billetera',
          tipo: 'efectivo',
          saldoInicialCent: const Value(500000),
        ),
        writer,
      );

      final cats = await db.categoriasDao.getCategorias(tipo: 'gastoVariable');
      final catA = cats[0];
      final catB = cats[1];

      // Gasto A: S/ 1,500.00 (150,000 cts)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catA.id),
          tipo: 'gasto',
          montoCent: 150000,
          fecha: DateTime(2026, 10, 5),
          descripcion: 'Compras Cat A',
        ),
        writer,
      );

      // Gasto B: S/ 500.00 (50,000 cts)
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catB.id),
          tipo: 'gasto',
          montoCent: 50000,
          fecha: DateTime(2026, 10, 10),
          descripcion: 'Compras Cat B',
        ),
        writer,
      );

      final desglose = await db.movimientosDao.obtenerGastosPorCategoria('2026-10');
      expect(desglose.length, 2);
      // Orden descendente
      expect(desglose.first.categoriaId, catA.id);
      expect(desglose.first.monto.cents, 150000);
      expect(desglose.first.porcentaje, 0.75); // 75%

      expect(desglose.last.categoriaId, catB.id);
      expect(desglose.last.monto.cents, 50000);
      expect(desglose.last.porcentaje, 0.25); // 25%
    });

    test('obtenerTendenciaMeses genera serie cronológica para 6 y 12 meses', () async {
      final serie6 = await db.movimientosDao.obtenerTendenciaMeses(
        cantidadMeses: 6,
        periodoFin: '2026-10',
      );
      expect(serie6.length, 6);
      expect(serie6.first.periodo, '2026-05');
      expect(serie6.last.periodo, '2026-10');
      expect(serie6.last.etiqueta, 'OCT');

      final serie12 = await db.movimientosDao.obtenerTendenciaMeses(
        cantidadMeses: 12,
        periodoFin: '2026-10',
      );
      expect(serie12.length, 12);
      expect(serie12.first.periodo, '2025-11');
      expect(serie12.last.periodo, '2026-10');
    });
  });

  group('Fase 5 - Exportación a CSV y PDF (100% Local)', () {
    test('ExportarCsvService genera estructura válida RFC 4180 con UTF-8 BOM', () {
      final mov = Movimiento(
        id: 1,
        fecha: DateTime(2026, 10, 11),
        tipo: 'gasto',
        montoCent: 12550,
        cuentaOrigenId: 1,
        cuentaDestinoId: null,
        categoriaId: 1,
        descripcion: 'Mercado "Plaza Vea", verduras',
        notas: 'Con boleta',
        gastoFijoPagoId: null,
        partidaId: null,
        anulado: false,
        anuladoEn: null,
        motivoAnulacion: null,
        creadoEn: DateTime.now(),
        actualizadoEn: DateTime.now(),
      );

      final csv = ExportarCsvService.generarCsvMovimientos(
        tituloPeriodo: '2026-10',
        movimientos: [mov],
        mapaCategorias: {1: 'Alimentación'},
        mapaCuentas: {1: 'BCP Ahorros'},
      );

      // Inicia con UTF-8 BOM
      expect(csv.startsWith('\uFEFF'), isTrue);
      // Encabezados
      expect(csv.contains('"Fecha","Tipo","Categoría"'), isTrue);
      // Monto formateado en Soles decimales
      expect(csv.contains('125.50'), isTrue);
      // Escapado correcto de comillas dobles
      expect(csv.contains('Mercado ""Plaza Vea"", verduras'), isTrue);
    });

    test('ExportarPdfService genera documento PDF estándar %PDF-1.4 válido', () async {
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Ahorro BCP',
          tipo: 'banco',
          saldoInicialCent: const Value(1000000),
        ),
        writer,
      );
      final catGasto = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;

      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 7500,
          fecha: DateTime(2026, 10, 11),
          descripcion: 'Cena familiar',
        ),
        writer,
      );

      final resumen = await db.movimientosDao.calcularResumenMensual('2026-10');
      final cats = await db.movimientosDao.obtenerGastosPorCategoria('2026-10');
      final movs = await db.movimientosDao.watchMovimientos().first;

      final pdfBytes = ExportarPdfService.generarPdfReporteMensual(
        periodo: '2026-10',
        resumen: resumen,
        categorias: cats,
        ultimosMovimientos: movs,
        mapaCategorias: {catGasto.id: catGasto.nombre},
      );

      expect(pdfBytes.isNotEmpty, isTrue);
      final pdfString = latin1.decode(pdfBytes);

      // Verificación de estructura PDF 1.4
      expect(pdfString.startsWith('%PDF-1.4'), isTrue);
      expect(pdfString.contains('/Type /Catalog'), isTrue);
      expect(pdfString.contains('/Type /Page'), isTrue);
      expect(pdfString.contains('xref'), isTrue);
      expect(pdfString.contains('trailer'), isTrue);
      expect(pdfString.endsWith('%%EOF\n'), isTrue);
    });
  });
}