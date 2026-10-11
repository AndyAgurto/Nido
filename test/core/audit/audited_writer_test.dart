import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/audit/audit_entry.dart';
import 'package:nido/core/audit/audit_service.dart';

void main() {
  late AppDatabase db;
  late AuditedWriter writer;
  late AuditService auditService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    writer = AuditedWriter(db);
    auditService = AuditService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AuditedWriter y AuditService - Transaccionalidad y Trazabilidad', () {
    test('write ejecuta mutación e inserta registro de auditoría con JSON correctamente', () async {
      final cuentaId = await writer.write<int>(
        action: () => db.into(db.cuentas).insert(
              CuentasCompanion.insert(
                nombre: 'Billetera Principal',
                tipo: 'efectivo',
                saldoInicialCent: const Value(50000), // S/ 500.00
              ),
            ),
        auditBuilder: (id) => AuditEntry(
          entidad: 'Cuenta',
          entidadId: id,
          accion: 'crear',
          valorNuevo: {'nombre': 'Billetera Principal', 'saldoInicialCent': 50000},
          resumen: 'Creación de cuenta Billetera Principal',
        ),
      );

      expect(cuentaId, isPositive);

      final cuenta = await (db.select(db.cuentas)..where((t) => t.id.equals(cuentaId))).getSingle();
      expect(cuenta.nombre, 'Billetera Principal');
      expect(cuenta.saldoInicialCent, 50000);

      final auditLogs = await auditService.getAuditoria(entidad: 'Cuenta', entidadId: cuentaId);
      expect(auditLogs.length, 1);
      final log = auditLogs.first;
      expect(log.accion, 'crear');
      expect(log.resumen, 'Creación de cuenta Billetera Principal');

      final jsonNuevo = jsonDecode(log.valorNuevoJson!);
      expect(jsonNuevo['nombre'], 'Billetera Principal');
      expect(jsonNuevo['saldoInicialCent'], 50000);
      expect(log.valorAnteriorJson, isNull);
    });

    test('Rollback atómico: si la acción falla, no se guarda el dato ni la auditoría', () async {
      final conteoInicialCuentas = (await db.select(db.cuentas).get()).length;
      final conteoInicialAuditoria = (await db.select(db.auditoria).get()).length;

      expect(
        () async => await writer.write<int>(
          action: () async {
            await db.into(db.cuentas).insert(
                  CuentasCompanion.insert(
                    nombre: 'Cuenta Fantasma',
                    tipo: 'efectivo',
                  ),
                );
            throw Exception('Error simulado forzado para provocar rollback');
          },
          auditBuilder: (id) => AuditEntry(
            entidad: 'Cuenta',
            entidadId: id,
            accion: 'crear',
            resumen: 'No debe persistir',
          ),
        ),
        throwsException,
      );

      final conteoFinalCuentas = (await db.select(db.cuentas).get()).length;
      final conteoFinalAuditoria = (await db.select(db.auditoria).get()).length;

      expect(conteoFinalCuentas, conteoInicialCuentas);
      expect(conteoFinalAuditoria, conteoInicialAuditoria);
    });
  });
}