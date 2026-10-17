import 'package:drift/drift.dart';
import '../../../core/audit/audit_entry.dart';
import '../../../core/audit/audited_writer.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';

/// Servicio para inyectar datos de demostración realistas y coherentes en Soles (PEN)
/// para probar y demostrar todas las capacidades y módulos de Nido.
class DemoDataService {
  /// Carga datos demo completos y auditados en la base de datos local.
  static Future<void> cargarDatosDemo({
    required AppDatabase db,
    required AuditedWriter writer,
  }) async {
    final ahora = DateTime.now();
    final mesStr = ahora.month.toString().padLeft(2, '0');
    final periodoActual = '${ahora.year}-$mesStr';

    // 1. Crear Cuentas Demo mediante cuentasDao.insertCuenta
    final bcpId = await db.cuentasDao.insertCuenta(
      CuentasCompanion.insert(
        nombre: 'BCP Cuenta Sueldo',
        tipo: 'banco',
        color: const Value('#0D5D38'),
        icono: const Value('account_balance'),
        saldoInicialCent: const Value(0),
      ),
      writer,
    );

    final ibkId = await db.cuentasDao.insertCuenta(
      CuentasCompanion.insert(
        nombre: 'Interbank Fondo Ahorros',
        tipo: 'banco',
        color: const Value('#15803D'),
        icono: const Value('savings'),
        saldoInicialCent: const Value(0),
      ),
      writer,
    );

    final yapeId = await db.cuentasDao.insertCuenta(
      CuentasCompanion.insert(
        nombre: 'Billetera Yape / Plin',
        tipo: 'billetera',
        color: const Value('#722F37'),
        icono: const Value('phone_android'),
        saldoInicialCent: const Value(0),
      ),
      writer,
    );

    final efectivoId = await db.cuentasDao.insertCuenta(
      CuentasCompanion.insert(
        nombre: 'Efectivo en Bóveda Hogar',
        tipo: 'efectivo',
        color: const Value('#B45309'),
        icono: const Value('payments'),
        saldoInicialCent: const Value(0),
      ),
      writer,
    );

    // Obtener categorías predeterminadas
    final cats = await db.categoriasDao.getCategorias();
    int getCatId(String nombre, [int fallbackIndex = 0]) {
      String normalize(String s) => s.toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
      final target = normalize(nombre);
      final found = cats.where((c) => normalize(c.nombre).contains(target) || target.contains(normalize(c.nombre))).firstOrNull;
      if (found != null) return found.id;
      if (cats.isNotEmpty) {
        final fIdx = fallbackIndex % cats.length;
        return cats[fIdx].id;
      }
      return 1;
    }

    final catAlimentacion = getCatId('Alimentacion', 0);
    final catServicios = getCatId('Servicios', 1);
    final catVivienda = getCatId('Vivienda', 2);
    final catTransporte = getCatId('Transporte', 3);
    final catSalud = getCatId('Salud', 4);
    final catEntretenimiento = getCatId('Entretenimiento', 5);

    // 2. Cargar Movimientos de Ingresos Iniciales
    await writer.write<int>(
      action: () => db.into(db.movimientos).insert(
        MovimientosCompanion.insert(
          fecha: ahora.subtract(const Duration(days: 20)),
          tipo: 'ingreso',
          montoCent: Money.fromSoles(7200.0).cents,
          cuentaOrigenId: bcpId,
          descripcion: 'Ingreso Sueldo Principal',
        ),
      ),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {'descripcion': 'Ingreso Sueldo Principal', 'montoCent': 720000},
        resumen: 'Abono sueldo BCP S/ 7,200.00',
      ),
    );

    await writer.write<int>(
      action: () => db.into(db.movimientos).insert(
        MovimientosCompanion.insert(
          fecha: ahora.subtract(const Duration(days: 25)),
          tipo: 'ingreso',
          montoCent: Money.fromSoles(12000.0).cents,
          cuentaOrigenId: ibkId,
          descripcion: 'Ahorro Acumulado Familiar',
        ),
      ),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {'descripcion': 'Ahorro Acumulado Familiar', 'montoCent': 1200000},
        resumen: 'Fondo inicial Interbank S/ 12,000.00',
      ),
    );

    await writer.write<int>(
      action: () => db.into(db.movimientos).insert(
        MovimientosCompanion.insert(
          fecha: ahora.subtract(const Duration(days: 15)),
          tipo: 'ingreso',
          montoCent: Money.fromSoles(800.0).cents,
          cuentaOrigenId: efectivoId,
          descripcion: 'Caja Chica Efectivo Hogar',
        ),
      ),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {'descripcion': 'Caja Chica Efectivo', 'montoCent': 80000},
        resumen: 'Caja chica S/ 800.00',
      ),
    );

    // Transferencia: BCP a Yape
    await writer.write<int>(
      action: () => db.into(db.movimientos).insert(
        MovimientosCompanion.insert(
          fecha: ahora.subtract(const Duration(days: 10)),
          tipo: 'transferencia',
          montoCent: Money.fromSoles(500.0).cents,
          cuentaOrigenId: bcpId,
          cuentaDestinoId: Value(yapeId),
          descripcion: 'Recarga a Yape desde BCP',
        ),
      ),
      auditBuilder: (id) => AuditEntry(
        entidad: 'Movimiento',
        entidadId: id,
        accion: 'crear',
        valorNuevo: {'origen': bcpId, 'destino': yapeId, 'montoCent': 50000},
        resumen: 'Transferencia BCP a Yape S/ 500.00',
      ),
    );

    // Gastos variados realistas
    final gastos = [
      {'cuenta': bcpId, 'cat': catAlimentacion, 'monto': 485.50, 'dias': 8, 'desc': 'Supermercado Wong Quincena'},
      {'cuenta': yapeId, 'cat': catAlimentacion, 'monto': 65.00, 'dias': 5, 'desc': 'Frutas y Verduras Mercado'},
      {'cuenta': bcpId, 'cat': catServicios, 'monto': 185.00, 'dias': 12, 'desc': 'Recibo Luz del Sur / Enel'},
      {'cuenta': bcpId, 'cat': catServicios, 'monto': 129.90, 'dias': 11, 'desc': 'Internet Fibra Óptica 300Mbps'},
      {'cuenta': bcpId, 'cat': catTransporte, 'monto': 160.00, 'dias': 6, 'desc': 'Combustible Gasolina Primax'},
      {'cuenta': yapeId, 'cat': catSalud, 'monto': 78.50, 'dias': 4, 'desc': 'Medicamentos Inkafarma'},
      {'cuenta': efectivoId, 'cat': catAlimentacion, 'monto': 45.00, 'dias': 2, 'desc': 'Panadería y Desayuno Domingo'},
      {'cuenta': yapeId, 'cat': catEntretenimiento, 'monto': 110.00, 'dias': 3, 'desc': 'Cineplanet Entradas y Snacks'},
    ];

    for (final g in gastos) {
      final mCents = Money.fromSoles(g['monto'] as double).cents;
      await db.into(db.movimientos).insert(
        MovimientosCompanion.insert(
          fecha: ahora.subtract(Duration(days: g['dias'] as int)),
          tipo: 'gasto',
          montoCent: mCents,
          cuentaOrigenId: g['cuenta'] as int,
          categoriaId: Value(g['cat'] as int),
          descripcion: g['desc'] as String,
        ),
      );
    }

    // 3. Plantillas de Gastos Fijos
    final fijoLuz = await db.into(db.gastosFijos).insert(
      GastosFijosCompanion.insert(
        nombre: 'Luz Eléctrica del Hogar',
        montoEstimadoCent: Money.fromSoles(185.0).cents,
        categoriaId: catServicios,
        cuentaPagoId: bcpId,
        diaVencimiento: 15,
        fechaInicio: ahora.subtract(const Duration(days: 60)),
      ),
    );

    final fijoInternet = await db.into(db.gastosFijos).insert(
      GastosFijosCompanion.insert(
        nombre: 'Internet Fibra y Telefonía',
        montoEstimadoCent: Money.fromSoles(130.0).cents,
        categoriaId: catServicios,
        cuentaPagoId: bcpId,
        diaVencimiento: 10,
        fechaInicio: ahora.subtract(const Duration(days: 60)),
      ),
    );

    final fijoMantenimiento = await db.into(db.gastosFijos).insert(
      GastosFijosCompanion.insert(
        nombre: 'Mantenimiento del Edificio',
        montoEstimadoCent: Money.fromSoles(250.0).cents,
        categoriaId: catVivienda,
        cuentaPagoId: bcpId,
        diaVencimiento: 5,
        fechaInicio: ahora.subtract(const Duration(days: 60)),
      ),
    );

    final fijoSeguro = await db.into(db.gastosFijos).insert(
      GastosFijosCompanion.insert(
        nombre: 'Seguro Médico Familiar EPS',
        montoEstimadoCent: Money.fromSoles(380.0).cents,
        categoriaId: catSalud,
        cuentaPagoId: bcpId,
        diaVencimiento: 28,
        fechaInicio: ahora.subtract(const Duration(days: 60)),
      ),
    );

    // Generar cuotas mensuales para los gastos fijos
    await db.into(db.gastosFijosPagos).insert(
      GastosFijosPagosCompanion.insert(
        gastoFijoId: fijoLuz,
        periodo: periodoActual,
        montoEsperadoCent: Money.fromSoles(185.0).cents,
        estado: const Value('pagado'),
        fechaVencimiento: DateTime(ahora.year, ahora.month, 15),
      ),
    );

    await db.into(db.gastosFijosPagos).insert(
      GastosFijosPagosCompanion.insert(
        gastoFijoId: fijoInternet,
        periodo: periodoActual,
        montoEsperadoCent: Money.fromSoles(130.0).cents,
        estado: const Value('pagado'),
        fechaVencimiento: DateTime(ahora.year, ahora.month, 10),
      ),
    );

    await db.into(db.gastosFijosPagos).insert(
      GastosFijosPagosCompanion.insert(
        gastoFijoId: fijoMantenimiento,
        periodo: periodoActual,
        montoEsperadoCent: Money.fromSoles(250.0).cents,
        estado: const Value('pendiente'),
        fechaVencimiento: DateTime(ahora.year, ahora.month, 5),
      ),
    );

    await db.into(db.gastosFijosPagos).insert(
      GastosFijosPagosCompanion.insert(
        gastoFijoId: fijoSeguro,
        periodo: periodoActual,
        montoEsperadoCent: Money.fromSoles(380.0).cents,
        estado: const Value('pendiente'),
        fechaVencimiento: DateTime(ahora.year, ahora.month, 28),
      ),
    );

    // 4. Presupuestos Mensuales del Periodo
    await db.presupuestosDao.setPresupuesto(
      periodo: periodoActual,
      categoriaId: catAlimentacion,
      montoCent: Money.fromSoles(1500.0).cents,
      writer: writer,
    );

    await db.presupuestosDao.setPresupuesto(
      periodo: periodoActual,
      categoriaId: catServicios,
      montoCent: Money.fromSoles(600.0).cents,
      writer: writer,
    );

    await db.presupuestosDao.setPresupuesto(
      periodo: periodoActual,
      categoriaId: catTransporte,
      montoCent: Money.fromSoles(450.0).cents,
      writer: writer,
    );

    await db.presupuestosDao.setPresupuesto(
      periodo: periodoActual,
      categoriaId: catSalud,
      montoCent: Money.fromSoles(500.0).cents,
      writer: writer,
    );

    await db.presupuestosDao.setPresupuesto(
      periodo: periodoActual,
      categoriaId: catEntretenimiento,
      montoCent: Money.fromSoles(350.0).cents,
      writer: writer,
    );

    // 5. Proyectos del Hogar con Partidas y Cotizaciones
    final proyBano = await db.proyectosDao.insertProyecto(
      ProyectosCompanion.insert(
        nombre: 'Remodelación Baño Principal',
        tipo: 'construccion',
        descripcion: const Value('Cambio de sanitarios, inodoro ecológico y cerámico porcelanato'),
        presupuestoObjetivoCent: Money.fromSoles(5500.0).cents,
        estado: const Value('enEjecucion'),
      ),
      writer,
    );

    final partidaSanitarios = await db.proyectosDao.insertPartida(
      PartidasProyectoCompanion.insert(
        proyectoId: proyBano,
        nombre: 'Sanitarios y Grifería Vainsa',
        presupuestoCent: Money.fromSoles(2200.0).cents,
      ),
      writer,
    );

    await db.proyectosDao.insertPartida(
      PartidasProyectoCompanion.insert(
        proyectoId: proyBano,
        nombre: 'Porcelanato y Pegamento Gris',
        presupuestoCent: Money.fromSoles(1800.0).cents,
      ),
      writer,
    );

    // Cotizaciones para la partida sanitarios
    final cot1 = await db.proyectosDao.insertCotizacion(
      CotizacionesCompanion.insert(
        partidaId: partidaSanitarios,
        proveedor: 'Sodimac San Miguel',
        montoCent: Money.fromSoles(2150.0).cents,
        fecha: ahora.subtract(const Duration(days: 7)),
        notas: const Value('Incluye válvula de descarga y accesorios'),
      ),
      writer,
    );

    await db.proyectosDao.insertCotizacion(
      CotizacionesCompanion.insert(
        partidaId: partidaSanitarios,
        proveedor: 'Promart Salaverry',
        montoCent: Money.fromSoles(2340.0).cents,
        fecha: ahora.subtract(const Duration(days: 5)),
        notas: const Value('Precio incluye transporte a domicilio'),
      ),
      writer,
    );

    // Adjudicar cotización ganadora en Sodimac
    await db.proyectosDao.elegirCotizacionGanadora(
      partidaId: partidaSanitarios,
      cotizacionId: cot1,
      writer: writer,
    );

    // Segundo proyecto en estado Idea
    await db.proyectosDao.insertProyecto(
      ProyectosCompanion.insert(
        nombre: 'Pintura y Mantenimiento Fachada',
        tipo: 'arreglo',
        descripcion: const Value('Pintado con sellador antihumedad para temporada de invierno'),
        presupuestoObjetivoCent: Money.fromSoles(2400.0).cents,
        estado: const Value('idea'),
      ),
      writer,
    );

    // 6. Marcar flags en Ajustes
    await db.ajustesDao.setValor('onboarding_completado', 'true');
    await db.ajustesDao.setValor('datos_demo_cargados', 'true');
  }

  /// Limpia todos los datos del usuario manteniendo la integridad de tablas y semillas.
  static Future<void> restablecerDatosLimpios({
    required AppDatabase db,
    required AuditedWriter writer,
  }) async {
    await db.transaction(() async {
      await db.delete(db.cotizaciones).go();
      await db.delete(db.partidasProyecto).go();
      await db.delete(db.proyectos).go();
      await db.delete(db.presupuestosMensuales).go();
      await db.delete(db.gastosFijosPagos).go();
      await db.delete(db.gastosFijos).go();
      await db.delete(db.movimientos).go();
      await db.delete(db.cuentas).go();
    });

    await writer.write<void>(
      action: () async {},
      auditBuilder: (_) => const AuditEntry(
        entidad: 'Sistema',
        entidadId: 0,
        accion: 'restaurar',
        valorNuevo: {'accion': 'restablecer_datos_limpios'},
        resumen: 'Base de datos restablecida a estado limpio inicial',
      ),
    );
  }
}