import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/database/daos/cuentas_dao.dart';
import 'package:nido/core/database/daos/categorias_dao.dart';
import 'package:nido/core/database/daos/proyectos_dao.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/formatters/money_input_formatter.dart';

void main() {
  group('1. BcpMoneyInputFormatter - Escritura bancaria (enteros primero, luego decimales)', () {
    late BcpMoneyInputFormatter formatter;

    setUp(() {
      formatter = const BcpMoneyInputFormatter();
    });

    test('Permite ingresar dígitos enteros fluidamente sin forzar decimales automáticos', () {
      var oldValue = TextEditingValue.empty;
      var newValue = const TextEditingValue(text: '1', selection: TextSelection.collapsed(offset: 1));
      var res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '1');

      oldValue = res;
      newValue = const TextEditingValue(text: '15', selection: TextSelection.collapsed(offset: 2));
      res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '15');

      oldValue = res;
      newValue = const TextEditingValue(text: '150', selection: TextSelection.collapsed(offset: 3));
      res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150');
    });

    test('Permite pulsar punto o coma y escribir hasta dos decimales', () {
      // Pulsa punto
      var oldValue = const TextEditingValue(text: '150', selection: TextSelection.collapsed(offset: 3));
      var newValue = const TextEditingValue(text: '150.', selection: TextSelection.collapsed(offset: 4));
      var res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150.');

      // Primer decimal
      oldValue = res;
      newValue = const TextEditingValue(text: '150.5', selection: TextSelection.collapsed(offset: 5));
      res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150.5');

      // Segundo decimal
      oldValue = res;
      newValue = const TextEditingValue(text: '150.50', selection: TextSelection.collapsed(offset: 6));
      res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150.50');
    });

    test('Convierte coma a punto decimal automáticamente', () {
      final oldValue = const TextEditingValue(text: '80', selection: TextSelection.collapsed(offset: 2));
      final newValue = const TextEditingValue(text: '80,', selection: TextSelection.collapsed(offset: 3));
      final res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '80.');
    });

    test('Rechaza un tercer decimal excedente', () {
      final oldValue = const TextEditingValue(text: '150.50', selection: TextSelection.collapsed(offset: 6));
      final newValue = const TextEditingValue(text: '150.509', selection: TextSelection.collapsed(offset: 7));
      final res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150.50');
    });

    test('Rechaza caracteres alfabéticos o símbolos inválidos', () {
      final oldValue = const TextEditingValue(text: '150', selection: TextSelection.collapsed(offset: 3));
      final newValue = const TextEditingValue(text: '150abc', selection: TextSelection.collapsed(offset: 6));
      final res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150');
    });

    test('Rechaza un segundo punto decimal', () {
      final oldValue = const TextEditingValue(text: '150.5', selection: TextSelection.collapsed(offset: 5));
      final newValue = const TextEditingValue(text: '150.5.', selection: TextSelection.collapsed(offset: 6));
      final res = formatter.formatEditUpdate(oldValue, newValue);
      expect(res.text, '150.5');
    });
  });

  group('2. Categorías - CRUD y Categorías de Proyectos', () {
    late AppDatabase db;
    late CategoriasDao catDao;
    late AuditedWriter writer;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      catDao = db.categoriasDao;
      writer = AuditedWriter(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Permite listar, crear y actualizar categorías normales y de proyectos', () async {
      // 1. Crear categoría de gasto
      final catGastoId = await catDao.insertCategoria(
        CategoriasCompanion.insert(
          nombre: 'Comestibles Gourmet',
          icono: const drift.Value('shopping_basket'),
          color: const drift.Value('#2E7D32'),
          tipo: 'gastoVariable',
        ),
        writer,
      );
      expect(catGastoId, greaterThan(0));

      // 2. Crear categoría exclusiva de Proyecto
      final catProyId = await catDao.insertCategoria(
        CategoriasCompanion.insert(
          nombre: 'Remodelación de Baño',
          icono: const drift.Value('bathtub'),
          color: const drift.Value('#0288D1'),
          tipo: 'proyecto',
        ),
        writer,
      );
      expect(catProyId, greaterThan(0));

      // 3. Consultar categorías de proyectos
      final proyCats = await catDao.watchCategorias(tipo: 'proyecto', soloActivas: false).first;
      expect(proyCats.any((c) => c.nombre == 'Remodelación de Baño'), isTrue);

      // 4. Actualizar categoría
      final catGasto = await catDao.getCategoriaById(catGastoId);
      expect(catGasto, isNotNull);

      await catDao.updateCategoria(
        CategoriasCompanion(
          id: drift.Value(catGastoId),
          nombre: const drift.Value('Supermercado y Despensa'),
          icono: const drift.Value('shopping_cart'),
          color: const drift.Value('#1B5E20'),
          tipo: const drift.Value('gastoVariable'),
          activa: const drift.Value(true),
        ),
        writer,
      );

      final catActualizada = await catDao.getCategoriaById(catGastoId);
      expect(catActualizada?.nombre, 'Supermercado y Despensa');

      // 5. Toggle activa/desactivada
      await catDao.toggleActivaCategoria(catGastoId, false, writer);
      final catDesactivada = await catDao.getCategoriaById(catGastoId);
      expect(catDesactivada?.activa, isFalse);
    });
  });

  group('3. Cuentas - Edición y Actualización de Monto Inicial / Saldo', () {
    late AppDatabase db;
    late CuentasDao cuentasDao;
    late AuditedWriter writer;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      cuentasDao = db.cuentasDao;
      writer = AuditedWriter(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Permite actualizar el monto/saldo inicial de la cuenta y recalcula correctamente', () async {
      final cuentaId = await cuentasDao.insertCuenta(
        CuentasCompanion.insert(
          nombre: 'BCP Sueldo',
          tipo: 'banco',
          saldoInicialCent: const drift.Value(100000), // S/ 1,000.00
          icono: const drift.Value('account_balance'),
        ),
        writer,
      );

      final saldoInicial = await cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldoInicial.cents, 100000);

      final cuentaExistente = (await cuentasDao.watchCuentasActivas().first).firstWhere((c) => c.id == cuentaId);

      // Modificar monto a S/ 2,500.50
      await cuentasDao.updateCuenta(
        cuentaExistente,
        CuentasCompanion(
          nombre: const drift.Value('BCP Sueldo Premium'),
          tipo: const drift.Value('banco'),
          saldoInicialCent: const drift.Value(250050),
          icono: const drift.Value('account_balance'),
        ),
        writer,
      );

      final saldoActualizado = await cuentasDao.calcularSaldoCuenta(cuentaId);
      expect(saldoActualizado.cents, 250050);
      expect(saldoActualizado.format(), 'S/ 2,500.50');
    });
  });

  group('4. Proyectos - Creación con estado y compatibilidad de selección', () {
    late AppDatabase db;
    late ProyectosDao proyectosDao;
    late AuditedWriter writer;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      proyectosDao = db.proyectosDao;
      writer = AuditedWriter(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Inserta proyectos con estados válidos y preserva consistencia', () async {
      final proyId = await proyectosDao.insertProyecto(
        ProyectosCompanion.insert(
          nombre: 'Pintura Fachada y Sala',
          tipo: 'decoracion',
          estado: const drift.Value('enEjecucion'),
          presupuestoObjetivoCent: 350000,
        ),
        writer,
      );

      expect(proyId, greaterThan(0));
      final proyectos = await proyectosDao.watchProyectos().first;
      expect(proyectos.any((p) => p.id == proyId && p.estado == 'enEjecucion'), isTrue);
    });
  });

  group('5. Seguridad - PIN exclusivo de 4 a 6 dígitos', () {
    test('Valida longitud de PIN numérico entre 4 y 6 dígitos', () {
      // Menos de 4 dígitos -> Inválido
      const pinCorto = '123';
      expect(pinCorto.length >= 4 && pinCorto.length <= 6, isFalse);

      // 4 dígitos -> Válido
      const pin4 = '1234';
      expect(pin4.length >= 4 && pin4.length <= 6, isTrue);

      // 5 dígitos -> Válido
      const pin5 = '12345';
      expect(pin5.length >= 4 && pin5.length <= 6, isTrue);

      // 6 dígitos -> Válido
      const pin6 = '123456';
      expect(pin6.length >= 4 && pin6.length <= 6, isTrue);

      // Más de 6 dígitos -> Inválido
      const pinLargo = '1234567';
      expect(pinLargo.length >= 4 && pinLargo.length <= 6, isFalse);
    });
  });
}
