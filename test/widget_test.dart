import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nido/app/app.dart';
import 'package:nido/app/constants/app_constants.dart';
import 'package:nido/core/widgets/master_detail_layout.dart';

void main() {
  group('Fase 0 - Verificación de Base Arquitectónica y Tablet UI', () {
    testWidgets('NidoApp renderiza correctamente con NavigationRail para tablet', (
      WidgetTester tester,
    ) async {
      // Configuramos resolución típica de Tablet horizontal (1280x800)
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: NidoApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verificamos presencia de marca y slogan
      expect(find.text(AppConstants.appName), findsWidgets);
      expect(find.text('Modo 100% Local'), findsOneWidget);

      // Verificamos presencia de NavigationRail
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Cuentas'), findsOneWidget);
      expect(find.text('Movimientos'), findsOneWidget);
      expect(find.text('Gastos Fijos'), findsOneWidget);
      expect(find.text('Presupuesto'), findsOneWidget);
      expect(find.text('Proyectos'), findsOneWidget);
      expect(find.text('Reportes'), findsOneWidget);
      expect(find.text('Auditoría'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);

      // Verificamos interacción táctil al cambiar de sección
      await tester.tap(find.text('Cuentas'));
      await tester.pumpAndSettle();
      expect(find.text('Cuentas y Bolsillos'), findsOneWidget);
    });

    testWidgets('MasterDetailLayout divide en dos paneles en ancho >= 840dp', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterDetailLayout(
              master: Text('Panel Maestro'),
              detail: Text('Panel Detalle'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Panel Maestro'), findsOneWidget);
      expect(find.text('Panel Detalle'), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);
    });
  });
}
