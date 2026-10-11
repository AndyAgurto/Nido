import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/money/money.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/features/presupuesto/presentation/presupuesto_providers.dart';

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

  group('Fase 3 - Presupuesto: Lógica de Barras de Progreso y Alertas 80% / 100%', () {
    test('Item sin presupuesto asignado reporta tienePresupuesto en false', () {
      final cat = Categoria(
        id: 1,
        nombre: 'Servicios',
        tipo: 'gastoVariable',
        icono: 'bolt',
        color: '#FFAA00',
        esSistema: false,
        activa: true,
        creadoEn: DateTime.now(),
        actualizadoEn: DateTime.now(),
      );

      final item = CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.zero,
        gastado: Money.zero,
      );

      expect(item.tienePresupuesto, isFalse);
      expect(item.alerta80, isFalse);
      expect(item.alerta100, isFalse);
      expect(item.porcentaje, equals(0.0));
      expect(item.restante.cents, equals(0));
    });

    test('Ejecución normal (< 80%) no activa ninguna alerta', () {
      final cat = Categoria(
        id: 2,
        nombre: 'Alimentación',
        tipo: 'gastoVariable',
        icono: 'restaurant',
        color: '#4CAF50',
        esSistema: false,
        activa: true,
        creadoEn: DateTime.now(),
        actualizadoEn: DateTime.now(),
      );

      final item = CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.fromCents(100000), // S/ 1,000.00
        gastado: Money.fromCents(50000),       // S/ 500.00 (50%)
      );

      expect(item.tienePresupuesto, isTrue);
      expect(item.porcentaje, equals(0.5));
      expect(item.alerta80, isFalse);
      expect(item.alerta100, isFalse);
      expect(item.restante.cents, equals(50000));
    });

    test('Ejecución entre 80% y 99% activa alerta80 exclusivamente', () {
      final cat = Categoria(
        id: 3,
        nombre: 'Transporte',
        tipo: 'gastoVariable',
        icono: 'directions_bus',
        color: '#2196F3',
        esSistema: false,
        activa: true,
        creadoEn: DateTime.now(),
        actualizadoEn: DateTime.now(),
      );

      // 85% de ejecución
      final item = CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.fromCents(20000), // S/ 200.00
        gastado: Money.fromCents(17000),       // S/ 170.00 (85%)
      );

      expect(item.porcentaje, equals(0.85));
      expect(item.alerta80, isTrue);
      expect(item.alerta100, isFalse);
      expect(item.restante.cents, equals(3000)); // S/ 30.00 restante
    });

    test('Ejecución exacta al 100% o superior activa alerta100', () {
      final cat = Categoria(
        id: 4,
        nombre: 'Entretenimiento',
        tipo: 'gastoVariable',
        icono: 'movie',
        color: '#E91E63',
        esSistema: false,
        activa: true,
        creadoEn: DateTime.now(),
        actualizadoEn: DateTime.now(),
      );

      // Exactamente 100%
      final item100 = CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.fromCents(15000), // S/ 150.00
        gastado: Money.fromCents(15000),       // S/ 150.00 (100%)
      );

      expect(item100.porcentaje, equals(1.0));
      expect(item100.alerta80, isFalse);
      expect(item100.alerta100, isTrue);
      expect(item100.restante.cents, equals(0));

      // Sobregiro 120%
      final itemOver = CategoriaPresupuestoItem(
        categoria: cat,
        presupuestado: Money.fromCents(10000), // S/ 100.00
        gastado: Money.fromCents(12000),       // S/ 120.00 (120%)
      );

      expect(itemOver.porcentaje, equals(1.2));
      expect(itemOver.alerta80, isFalse);
      expect(itemOver.alerta100, isTrue);
      expect(itemOver.restante.isNegative, isTrue);
      expect(itemOver.restante.cents, equals(-2000));
    });

    test('Copiar presupuesto de mes anterior e integración con DAO y auditoría', () async {
      final catId = await db.into(db.categorias).insert(
        CategoriasCompanion.insert(
          nombre: 'Hogar',
          tipo: 'gastoVariable',
        ),
      );

      // Asignar en mes origen
      await db.presupuestosDao.setPresupuesto(
        categoriaId: catId,
        periodo: '2026-09',
        montoCent: 80000,
        writer: writer,
      );

      // Copiar a mes destino
      final copiados = await db.presupuestosDao.copiarPresupuestosDelMesAnterior(
        periodoOrigen: '2026-09',
        periodoDestino: '2026-10',
        writer: writer,
      );

      expect(copiados, equals(1));

      final presupuestosOct = await db.presupuestosDao.getPresupuestosDelPeriodo('2026-10');
      expect(presupuestosOct.length, equals(1));
      expect(presupuestosOct.first.categoriaId, equals(catId));
      expect(presupuestosOct.first.montoCent, equals(80000));

      // Intentar copiar de nuevo: es idempotente, no duplica
      final recopiados = await db.presupuestosDao.copiarPresupuestosDelMesAnterior(
        periodoOrigen: '2026-09',
        periodoDestino: '2026-10',
        writer: writer,
      );
      expect(recopiados, equals(0));
    });
  });
}
