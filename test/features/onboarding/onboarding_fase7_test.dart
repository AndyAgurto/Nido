import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/providers/database_providers.dart';
import 'package:nido/core/widgets/tablet_scaffold.dart';
import 'package:nido/core/widgets/master_detail_layout.dart';
import 'package:nido/shared/widgets/empty_state_view.dart';
import 'package:nido/features/onboarding/data/demo_data_service.dart';
import 'package:nido/features/onboarding/presentation/onboarding_page.dart';
import 'package:nido/app/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Fase 7 - DemoDataService & Restablecimiento', () {
    late AppDatabase db;
    late AuditedWriter writer;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      writer = AuditedWriter(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('cargarDatosDemo inserta cuentas, movimientos, presupuestos y proyectos', () async {
      await DemoDataService.cargarDatosDemo(db: db, writer: writer);

      // Cuentas
      final cuentas = await db.cuentasDao.getAllCuentas();
      expect(cuentas.length, greaterThanOrEqualTo(4));
      expect(cuentas.any((c) => c.nombre.contains('BCP')), isTrue);
      expect(cuentas.any((c) => c.nombre.contains('Yape')), isTrue);

      // Movimientos
      final movimientos = await db.movimientosDao.watchMovimientos().first;
      expect(movimientos.length, greaterThanOrEqualTo(5));

      // Gastos fijos
      final fijos = await db.gastosFijosDao.getGastosFijosActivos();
      expect(fijos.length, greaterThanOrEqualTo(3));

      // Proyectos
      final proyectos = await db.proyectosDao.getProyectos();
      expect(proyectos.isNotEmpty, isTrue);

      // Partidas del proyecto
      final partidas = await db.proyectosDao.getPartidas(proyectos.first.id);
      expect(partidas.isNotEmpty, isTrue);

      // Cotizaciones con adjudicada
      final cotizaciones = await db.proyectosDao.getCotizaciones(partidas.first.id);
      expect(cotizaciones.any((cot) => cot.elegida), isTrue);
    });

    test('restablecerDatosLimpios deja la base de datos limpia con categorias base', () async {
      await DemoDataService.cargarDatosDemo(db: db, writer: writer);
      await DemoDataService.restablecerDatosLimpios(db: db, writer: writer);

      final cuentas = await db.cuentasDao.getAllCuentas();
      expect(cuentas.isEmpty, isTrue);

      final movimientos = await db.movimientosDao.watchMovimientos().first;
      expect(movimientos.isEmpty, isTrue);

      final categorias = await db.categoriasDao.getCategorias();
      expect(categorias.isNotEmpty, isTrue);
    });
  });

  group('Fase 7 - EmptyStateView & Accesibilidad (a11y)', () {
    testWidgets('EmptyStateView renderiza correctamente y boton cumple touch target >= 48dp', (tester) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateView(
              icon: Icons.account_balance_wallet_outlined,
              title: 'No hay cuentas registradas',
              description: 'Crea tu primera cuenta para controlar tus finanzas.',
              actionLabel: 'Crear cuenta',
              onAction: () => actionPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('No hay cuentas registradas'), findsOneWidget);
      expect(find.text('Crea tu primera cuenta para controlar tus finanzas.'), findsOneWidget);
      expect(find.text('Crear cuenta'), findsOneWidget);

      final buttonFinder = find.byWidgetPredicate((w) => w is ButtonStyleButton);
      final size = tester.getSize(buttonFinder);
      expect(size.height, greaterThanOrEqualTo(48.0));

      await tester.tap(buttonFinder);
      await tester.pump();
      expect(actionPressed, isTrue);
    });

    testWidgets('EmptyStateView soporta modo oscuro sin fallos de renderizado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: EmptyStateView(
              icon: Icons.history_toggle_off,
              title: 'Sin auditoría',
              description: 'Los registros aparecerán aquí.',
            ),
          ),
        ),
      );

      expect(find.text('Sin auditoría'), findsOneWidget);
    });
  });

  group('Fase 7 - OnboardingPage UI & Interaccion', () {
    testWidgets('Flujo de 3 pasos de onboarding permite completar y persistir estado', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: OnboardingPage(),
          ),
        ),
      );

      // Paso 1: Bienvenida
      expect(find.text('Nido'), findsWidgets);
      expect(find.text('Siguiente'), findsOneWidget);

      // Avanzar a Paso 2
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Paso 2: Cargar datos o iniciar limpio
      expect(find.text('Comienza a tu ritmo'), findsOneWidget);
      expect(find.text('Cargar Datos Demo y Comenzar'), findsOneWidget);

      // Avanzar a Paso 3
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Paso 3: Seguridad y privacidad
      expect(find.text('Tu seguridad está en tus manos'), findsOneWidget);
      expect(find.text('Comenzar'), findsOneWidget);

      // Finalizar onboarding pulsando Comenzar
      await tester.tap(find.text('Comenzar'));
      await tester.pumpAndSettle();

      final val = await db.ajustesDao.getValor('onboarding_completado');
      expect(val, 'true');

      await db.close();
    });
  });

  group('Fase 7 - Responsive Layouts (Tablet Nativa vs Movil)', () {
    testWidgets('En Tablet (>=720dp) muestra NavigationRail lateral', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: TabletScaffold(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            body: const Center(child: Text('Contenido Tablet')),
          ),
        ),
      );

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Contenido Tablet'), findsOneWidget);
    });

    testWidgets('En Movil (<720dp) muestra NavigationBar inferior y AppBar con Drawer', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: TabletScaffold(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            body: const Center(child: Text('Contenido Movil')),
          ),
        ),
      );

      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('MasterDetailLayout en Tablet muestra paneles paralelos y en Movil selector segmentado', (tester) async {
      // 1. Vista Tablet (>=840dp)
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: Text('Master List'),
              detail: Text('Detail View'),
            ),
          ),
        ),
      );

      expect(find.text('Master List'), findsOneWidget);
      expect(find.text('Detail View'), findsOneWidget);
      expect(find.byType(SegmentedButton<int>), findsNothing);

      // 2. Vista Movil (<840dp)
      tester.view.physicalSize = const Size(400, 800);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: Text('Master List'),
              detail: Text('Detail View'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SegmentedButton<int>), findsOneWidget);
      expect(find.text('Master List'), findsOneWidget);
      expect(find.text('Detail View'), findsNothing);

      // Conmutar a Detalle
      await tester.tap(find.text('Detalle'));
      await tester.pumpAndSettle();

      expect(find.text('Detail View'), findsOneWidget);
      expect(find.text('Master List'), findsNothing);

      tester.view.resetPhysicalSize();
    });
  });

  group('Fase 7 - Modo Oscuro Dinamico', () {
    testWidgets('themeModeProvider reacciona a cambios de tema', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);

      container.read(themeModeProvider.notifier).state = ThemeMode.dark;
      expect(container.read(themeModeProvider), ThemeMode.dark);

      container.read(themeModeProvider.notifier).state = ThemeMode.light;
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });
}
