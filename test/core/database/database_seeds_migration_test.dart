import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nido/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Migración v1 y Semillas Iniciales de Base de Datos', () {
    test('Esquema v1 inicializa correctamente', () {
      expect(db.schemaVersion, 1);
    });

    test('Semillas de categorías predeterminadas se insertan al crear la BD', () async {
      final todas = await db.categoriasDao.getCategorias(soloActivas: false);
      expect(todas.length, 25);

      final ingresos = await db.categoriasDao.getCategorias(tipo: 'ingreso');
      expect(ingresos.length, 3);
      expect(ingresos.map((c) => c.nombre), containsAll(['Sueldo', 'Ingreso extra', 'Otros ingresos']));

      final fijos = await db.categoriasDao.getCategorias(tipo: 'gastoFijo');
      expect(fijos.length, 10);
      expect(fijos.map((c) => c.nombre), contains('Alquiler/Cuota vivienda'));
      expect(fijos.map((c) => c.nombre), contains('Luz'));
      expect(fijos.map((c) => c.nombre), contains('Agua'));

      final variables = await db.categoriasDao.getCategorias(tipo: 'gastoVariable');
      expect(variables.length, 8);
      expect(variables.map((c) => c.nombre), containsAll(['Alimentación', 'Salud', 'Ocio']));

      final proyectos = await db.categoriasDao.getCategorias(tipo: 'proyecto');
      expect(proyectos.length, 4);
      expect(proyectos.map((c) => c.nombre), containsAll(['Decoración', 'Construcción', 'Arreglos', 'Mobiliario']));
    });

    test('Semillas de Ajustes iniciales se registran correctamente', () async {
      final moneda = await db.ajustesDao.getValor('moneda');
      expect(moneda, 'PEN');

      final bloqueo = await db.ajustesDao.getValor('bloqueoActivo');
      expect(bloqueo, 'false');

      final onboarding = await db.ajustesDao.getValor('onboardingCompletado');
      expect(onboarding, 'false');
    });

    test('Registro inicial de Auditoría se genera al crear el esquema', () async {
      final logs = await db.select(db.auditoria).get();
      expect(logs.isNotEmpty, isTrue);
      expect(logs.first.entidad, 'Sistema');
      expect(logs.first.accion, 'crear');
      expect(logs.first.resumen, contains('Inicialización de esquema v1'));
    });
  });
}