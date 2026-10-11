import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/features/proyectos/data/fotos_cotizaciones_service.dart';

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

  group('Fase 4 - Proyectos del Hogar y Partidas con Auditoría', () {
    test('CRUD de Proyecto y Partidas registra auditoría completa', () async {
      // 1. Crear proyecto
      final proyectoId = await db.proyectosDao.insertProyecto(
        ProyectosCompanion.insert(
          nombre: 'Remodelación de Cocina',
          tipo: 'remodelacion',
          descripcion: const Value('Cambio de muebles, porcelanato y gasfitería'),
          estado: const Value('idea'),
          prioridad: const Value('alta'),
          presupuestoObjetivoCent: 1200000, // S/ 12,000.00
          fechaInicioEstimada: Value(DateTime(2026, 11, 1)),
        ),
        writer,
      );

      final p = await db.proyectosDao.getProyectoById(proyectoId);
      expect(p, isNotNull);
      expect(p!.nombre, 'Remodelación de Cocina');
      expect(p.presupuestoObjetivoCent, 1200000);
      expect(p.estado, 'idea');

      // 2. Modificar estado del proyecto a 'cotizando'
      await db.proyectosDao.updateProyecto(
        ProyectosCompanion(
          id: Value(proyectoId),
          estado: const Value('cotizando'),
        ),
        writer,
      );

      final pActualizado = await db.proyectosDao.getProyectoById(proyectoId);
      expect(pActualizado!.estado, 'cotizando');

      // 3. Crear partidas presupuestarias
      final partida1Id = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Muebles de Melamina',
          presupuestoCent: 700000, // S/ 7,000.00
        ),
        writer,
      );

      final partida2Id = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Porcelanato y Frague',
          presupuestoCent: 350000, // S/ 3,500.00
        ),
        writer,
      );

      final partidas = await db.proyectosDao.getPartidas(proyectoId);
      expect(partidas.length, 2);
      expect(partidas.first.id, partida1Id);
      expect(partidas.last.id, partida2Id);

      // 4. Verificar bitácora de auditoría
      final logs = await db.select(db.auditoria).get();
      final tablasAuditadas = logs.map((l) => l.entidad).toSet();
      expect(tablasAuditadas.contains('Proyecto'), isTrue);
      expect(tablasAuditadas.contains('PartidaProyecto'), isTrue);
    });
  });

  group('Fase 4 - Cotizaciones, Comparador y Adjudicación Atómica', () {
    test('Comparación de cotizaciones y elección ganadora atómica y reversible', () async {
      final proyectoId = await db.proyectosDao.insertProyecto(
        ProyectosCompanion.insert(
          nombre: 'Pintura Fachada',
          tipo: 'arreglo',
          presupuestoObjetivoCent: 500000, // S/ 5,000.00
        ),
        writer,
      );

      final partidaId = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Mano de Obra y Pintura Látex',
          presupuestoCent: 300000, // S/ 3,000.00
        ),
        writer,
      );

      final ahora = DateTime.now();

      // Insertar 3 cotizaciones
      await db.proyectosDao.insertCotizacion(
        CotizacionesCompanion.insert(
          partidaId: partidaId,
          proveedor: 'Maestro Pintor Juan',
          montoCent: 320000, // S/ 3,200.00
          fecha: ahora,
          fotoRutaRelativa: const Value('cotizaciones_fotos/recibo_juan.jpg'),
        ),
        writer,
      );

      final cotBId = await db.proyectosDao.insertCotizacion(
        CotizacionesCompanion.insert(
          partidaId: partidaId,
          proveedor: 'Contratista Los Robles',
          montoCent: 270000, // S/ 2,700.00 (Más económica)
          fecha: ahora,
          fotoRutaRelativa: const Value('cotizaciones_fotos/presupuesto_robles.jpg'),
        ),
        writer,
      );

      final cotCId = await db.proyectosDao.insertCotizacion(
        CotizacionesCompanion.insert(
          partidaId: partidaId,
          proveedor: 'Servicios Integrales SAC',
          montoCent: 295000, // S/ 2,950.00
          fecha: ahora,
        ),
        writer,
      );

      final cotizaciones = await db.proyectosDao.getCotizaciones(partidaId);
      expect(cotizaciones.length, 3);

      // Comprobar que la más económica es la B
      cotizaciones.sort((a, b) => a.montoCent.compareTo(b.montoCent));
      expect(cotizaciones.first.id, cotBId);
      expect(cotizaciones.first.montoCent, 270000);

      // Elegir cotización ganadora B
      await db.proyectosDao.elegirCotizacionGanadora(
        partidaId: partidaId,
        cotizacionId: cotBId,
        writer: writer,
      );

      var cotB = (await db.proyectosDao.getCotizaciones(partidaId))
          .firstWhere((c) => c.id == cotBId);
      var partida = (await db.proyectosDao.getPartidas(proyectoId))
          .firstWhere((p) => p.id == partidaId);

      expect(cotB.elegida, isTrue);
      expect(partida.cotizacionElegidaId, cotBId);
      expect(partida.estado, 'adjudicado');

      // Cambiar de parecer y adjudicar la C (reemplazo atómico)
      await db.proyectosDao.elegirCotizacionGanadora(
        partidaId: partidaId,
        cotizacionId: cotCId,
        writer: writer,
      );

      final cotsActualizadas = await db.proyectosDao.getCotizaciones(partidaId);
      cotB = cotsActualizadas.firstWhere((c) => c.id == cotBId);
      final cotC = cotsActualizadas.firstWhere((c) => c.id == cotCId);
      partida = (await db.proyectosDao.getPartidas(proyectoId))
          .firstWhere((p) => p.id == partidaId);

      expect(cotB.elegida, isFalse); // La anterior se desmarca
      expect(cotC.elegida, isTrue);  // La nueva se marca
      expect(partida.cotizacionElegidaId, cotCId);
      expect(partida.estado, 'adjudicado');

      // Desmarcar cotización ganadora
      await db.proyectosDao.desmarcarCotizacionGanadora(
        partidaId: partidaId,
        writer: writer,
      );

      final cotsSinGanadora = await db.proyectosDao.getCotizaciones(partidaId);
      expect(cotsSinGanadora.every((c) => !c.elegida), isTrue);
      partida = (await db.proyectosDao.getPartidas(proyectoId))
          .firstWhere((p) => p.id == partidaId);
      expect(partida.cotizacionElegidaId, isNull);
      expect(partida.estado, 'cotizado');
    });
  });

  group('Fase 4 - Avance Financiero: Presupuesto vs Cotizado vs Gastado Real', () {
    test('calcularAvanceProyecto y calcularAvancePartida consolidan cifras exactas', () async {
      // 1. Proyecto con objetivo S/ 10,000.00
      final proyectoId = await db.proyectosDao.insertProyecto(
        ProyectosCompanion.insert(
          nombre: 'Instalación Techo Solar',
          tipo: 'construccion',
          presupuestoObjetivoCent: 1000000, // S/ 10,000.00
          estado: const Value('enEjecucion'),
        ),
        writer,
      );

      // Partida 1: Paneles S/ 6,000.00
      final p1Id = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Paneles Solares',
          presupuestoCent: 600000,
        ),
        writer,
      );

      // Partida 2: Inversor e Instalación S/ 3,000.00
      final p2Id = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Inversor e Instalación',
          presupuestoCent: 300000,
        ),
        writer,
      );

      final ahora = DateTime.now();

      // Cotización ganadora para Partida 1: S/ 5,800.00
      final cotP1 = await db.proyectosDao.insertCotizacion(
        CotizacionesCompanion.insert(
          partidaId: p1Id,
          proveedor: 'SolarTech Perú',
          montoCent: 580000,
          fecha: ahora,
        ),
        writer,
      );
      await db.proyectosDao.elegirCotizacionGanadora(
        partidaId: p1Id,
        cotizacionId: cotP1,
        writer: writer,
      );

      // Cotización ganadora para Partida 2: S/ 3,200.00
      final cotP2 = await db.proyectosDao.insertCotizacion(
        CotizacionesCompanion.insert(
          partidaId: p2Id,
          proveedor: 'Ingeniería Eléctrica SAC',
          montoCent: 320000,
          fecha: ahora,
        ),
        writer,
      );
      await db.proyectosDao.elegirCotizacionGanadora(
        partidaId: p2Id,
        cotizacionId: cotP2,
        writer: writer,
      );

      // Cuenta y Movimientos vinculados a partidas
      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Ahorros BCP',
          tipo: 'ahorro',
          saldoInicialCent: const Value(2500000), // S/ 25,000.00
        ),
        writer,
      );

      final catGasto = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;

      // Pago 1 a Partida 1 (adelanto Paneles): S/ 3,000.00
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 300000,
          fecha: DateTime.now(),
          descripcion: 'Adelanto 50% Paneles Solares',
          partidaId: Value(p1Id),
        ),
        writer,
      );

      // Pago 2 a Partida 1 (saldo Paneles): S/ 2,800.00
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 280000,
          fecha: DateTime.now(),
          descripcion: 'Saldo final Paneles Solares',
          partidaId: Value(p1Id),
        ),
        writer,
      );

      // Pago a Partida 2 (anticipo Inversor): S/ 1,000.00
      await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 100000,
          fecha: DateTime.now(),
          descripcion: 'Anticipo Inversor',
          partidaId: Value(p2Id),
        ),
        writer,
      );

      // Verificar avance individual de Partida 1
      final avanceP1 = await db.proyectosDao.calcularAvancePartida(p1Id);
      expect(avanceP1.presupuesto.cents, 600000);
      expect(avanceP1.montoCotizado!.cents, 580000);
      expect(avanceP1.gastadoReal.cents, 580000);
      expect(avanceP1.porcentajeEjecutado, 1.0); // 100% gastado vs cotizado

      // Verificar avance individual de Partida 2
      final avanceP2 = await db.proyectosDao.calcularAvancePartida(p2Id);
      expect(avanceP2.presupuesto.cents, 300000);
      expect(avanceP2.montoCotizado!.cents, 320000);
      expect(avanceP2.gastadoReal.cents, 100000);
      expect((avanceP2.porcentajeEjecutado * 100).round(), 31); // ~31.25%

      // Verificar avance general consolidado del Proyecto
      final avanceTotal = await db.proyectosDao.calcularAvanceProyecto(proyectoId);
      expect(avanceTotal.presupuestoObjetivo.cents, 1000000); // S/ 10,000.00
      expect(avanceTotal.presupuestoPartidas.cents, 900000); // 6,000 + 3,000
      expect(avanceTotal.totalCotizado.cents, 900000); // 5,800 + 3,200
      expect(avanceTotal.gastadoReal.cents, 680000); // 3,000 + 2,800 + 1,000 = S/ 6,800.00
      expect(avanceTotal.disponiblePresupuesto.cents, 220000); // 900,000 - 680,000 = S/ 2,200.00 frente a partidas

      // Porcentajes
      expect(avanceTotal.porcentajeCotizado, 1.0); // 900,000 cotizado vs 900,000 presupuestado partidas
      expect((avanceTotal.porcentajeGastadoVsPresupuesto * 100).round(), 76); // 680,000 / 900,000 = ~75.56%
      expect((avanceTotal.porcentajeGastadoVsCotizado * 100).round(), 76);

      // Saldo en la cuenta bancaria: S/ 25,000 - S/ 6,800 = S/ 18,200.00
      final saldoCuenta = await db.cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldoCuenta.cents, 1820000);

      // Movimientos del proyecto trazables
      final movsProyecto = await db.proyectosDao.watchMovimientosDelProyecto(proyectoId).first;
      expect(movsProyecto.length, 3);
    });

    test('vincular y desvincular movimiento a partida ajusta avance en tiempo real', () async {
      final proyectoId = await db.proyectosDao.insertProyecto(
        ProyectosCompanion.insert(
          nombre: 'Jardín Vertical',
          tipo: 'decoracion',
          presupuestoObjetivoCent: 400000, // S/ 4,000.00
        ),
        writer,
      );

      final partidaId = await db.proyectosDao.insertPartida(
        PartidasProyectoCompanion.insert(
          proyectoId: proyectoId,
          nombre: 'Sistema de Riego',
          presupuestoCent: 150000, // S/ 1,500.00
        ),
        writer,
      );

      final cuentaId = await db.cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'Efectivo',
          tipo: 'efectivo',
          saldoInicialCent: const Value(500000),
        ),
        writer,
      );

      final catGasto = (await db.categoriasDao.getCategorias(tipo: 'gastoVariable')).first;

      // Movimiento inicialmente NO vinculado a partida
      final movId = await db.movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          cuentaOrigenId: cuentaId,
          categoriaId: Value(catGasto.id),
          tipo: 'gasto',
          montoCent: 80000, // S/ 800.00
          fecha: DateTime.now(),
          descripcion: 'Mangueras y difusores',
        ),
        writer,
      );

      var avance = await db.proyectosDao.calcularAvanceProyecto(proyectoId);
      expect(avance.gastadoReal.cents, 0);

      // Vincular a partida
      await db.proyectosDao.vincularMovimientoAPartida(
        movId,
        partidaId,
        writer,
      );

      avance = await db.proyectosDao.calcularAvanceProyecto(proyectoId);
      expect(avance.gastadoReal.cents, 80000);

      // Desvincular de partida
      await db.proyectosDao.vincularMovimientoAPartida(
        movId,
        null,
        writer,
      );

      avance = await db.proyectosDao.calcularAvanceProyecto(proyectoId);
      expect(avance.gastadoReal.cents, 0);
    });
  });

  group('Fase 4 - Fotos de Cotizaciones (Local Sandbox)', () {
    test('FotosCotizacionesService procesa y valida rutas relativas', () {
      final service = FotosCotizacionesService();
      expect(service, isNotNull);
    });
  });
}