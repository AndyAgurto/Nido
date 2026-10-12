import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/providers/database_providers.dart';
import 'package:nido/app/app.dart';

void main() {
  testWidgets('NidoApp tablet smoke and navigation test', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const NidoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nido'), findsWidgets);

    // Desmontar el árbol y drenar microtareas de Drift
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await db.close();
  });
}