import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/cuentas_table.dart';
import 'tables/categorias_table.dart';
import 'tables/movimientos_table.dart';
import 'tables/gastos_fijos_table.dart';
import 'tables/ingresos_fijos_table.dart';
import 'tables/presupuestos_table.dart';
import 'tables/proyectos_table.dart';
import 'tables/auditoria_table.dart';
import 'tables/ajustes_table.dart';

import 'daos/cuentas_dao.dart';
import 'daos/movimientos_dao.dart';
import 'daos/categorias_dao.dart';
import 'daos/ajustes_dao.dart';
import 'daos/gastos_fijos_dao.dart';
import 'daos/presupuestos_dao.dart';
import 'daos/proyectos_dao.dart';

part 'app_database.g.dart';

/// Base de datos SQLite principal de Nido (100% local).
@DriftDatabase(
  tables: [
    Cuentas,
    Categorias,
    Movimientos,
    GastosFijos,
    GastosFijosPagos,
    IngresosFijos,
    IngresosFijosCobros,
    PresupuestosMensuales,
    Proyectos,
    PartidasProyecto,
    Cotizaciones,
    Auditoria,
    Ajustes,
  ],
  daos: [
    CuentasDao,
    MovimientosDao,
    CategoriasDao,
    AjustesDao,
    GastosFijosDao,
    PresupuestosDao,
    ProyectosDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'nido_db',
      native: const DriftNativeOptions(
        shareAcrossIsolates: true,
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // ------------------------------------------------------------------
          // Creación de Índices Requeridos para Alto Rendimiento
          // ------------------------------------------------------------------
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_movimientos_fecha ON movimientos (fecha);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_movimientos_cuenta_origen ON movimientos (cuenta_origen_id);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_movimientos_categoria ON movimientos (categoria_id);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_gastos_fijos_pagos_periodo ON gastos_fijos_pagos (periodo);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_auditoria_fecha_hora ON auditoria (fecha_hora);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_auditoria_entidad ON auditoria (entidad, entidad_id);',
          );

          // Inserción de Semillas Iniciales
          await _insertInitialSeeds();
        },
        beforeOpen: (details) async {
          // Habilitar claves foráneas estrictas en SQLite
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  /// Inserta las categorías predeterminadas del hogar y ajustes base del sistema.
  Future<void> _insertInitialSeeds() async {
    final now = DateTime.now();

    // 1. Semillas de Categorías de Ingreso
    final categoriasIngreso = [
      ('Sueldo', 'payments', '#15803D'),
      ('Ingreso extra', 'add_card', '#16A34A'),
      ('Otros ingresos', 'attach_money', '#22C55E'),
    ];
    for (final cat in categoriasIngreso) {
      await into(categorias).insert(
        CategoriasCompanion.insert(
          nombre: cat.$1,
          tipo: 'ingreso',
          icono: Value(cat.$2),
          color: Value(cat.$3),
          esSistema: const Value(true),
          activa: const Value(true),
          creadoEn: Value(now),
          actualizadoEn: Value(now),
        ),
      );
    }

    // 2. Semillas de Categorías de Gasto Fijo
    final categoriasGastoFijo = [
      ('Alquiler/Cuota vivienda', 'home', '#B91C1C'),
      ('Luz', 'bolt', '#D97706'),
      ('Agua', 'water_drop', '#0284C7'),
      ('Gas', 'local_fire_department', '#EA580C'),
      ('Internet y cable', 'wifi', '#4F46E5'),
      ('Telefonía', 'phone_android', '#7C3AED'),
      ('Suscripciones', 'subscriptions', '#9333EA'),
      ('Seguros', 'health_and_safety', '#0D9488'),
      ('Educación', 'school', '#0891B2'),
      ('Transporte', 'directions_bus', '#6366F1'),
    ];
    for (final cat in categoriasGastoFijo) {
      await into(categorias).insert(
        CategoriasCompanion.insert(
          nombre: cat.$1,
          tipo: 'gastoFijo',
          icono: Value(cat.$2),
          color: Value(cat.$3),
          esSistema: const Value(true),
          activa: const Value(true),
          creadoEn: Value(now),
          actualizadoEn: Value(now),
        ),
      );
    }

    // 3. Semillas de Categorías de Gasto Variable
    final categoriasGastoVariable = [
      ('Alimentación', 'restaurant', '#C2410C'),
      ('Salud', 'medical_services', '#DC2626'),
      ('Ocio', 'movie', '#A855F7'),
      ('Ropa', 'checkroom', '#EC4899'),
      ('Decorativos', 'weekend', '#14B8A6'),
      ('Mascotas', 'pets', '#F59E0B'),
      ('Regalos', 'card_giftcard', '#F43F5E'),
      ('Imprevistos', 'warning', '#EF4444'),
    ];
    for (final cat in categoriasGastoVariable) {
      await into(categorias).insert(
        CategoriasCompanion.insert(
          nombre: cat.$1,
          tipo: 'gastoVariable',
          icono: Value(cat.$2),
          color: Value(cat.$3),
          esSistema: const Value(true),
          activa: const Value(true),
          creadoEn: Value(now),
          actualizadoEn: Value(now),
        ),
      );
    }

    // 4. Semillas de Categorías de Proyecto
    final categoriasProyecto = [
      ('Decoración', 'format_paint', '#8B5CF6'),
      ('Construcción', 'construction', '#78716C'),
      ('Arreglos', 'handyman', '#64748B'),
      ('Mobiliario', 'chair', '#D97706'),
    ];
    for (final cat in categoriasProyecto) {
      await into(categorias).insert(
        CategoriasCompanion.insert(
          nombre: cat.$1,
          tipo: 'proyecto',
          icono: Value(cat.$2),
          color: Value(cat.$3),
          esSistema: const Value(true),
          activa: const Value(true),
          creadoEn: Value(now),
          actualizadoEn: Value(now),
        ),
      );
    }

    // 5. Ajustes por defecto
    await into(ajustes).insert(
      AjustesCompanion.insert(
        clave: 'moneda',
        valor: 'PEN',
        actualizadoEn: Value(now),
      ),
    );
    await into(ajustes).insert(
      AjustesCompanion.insert(
        clave: 'bloqueoActivo',
        valor: 'false',
        actualizadoEn: Value(now),
      ),
    );
    await into(ajustes).insert(
      AjustesCompanion.insert(
        clave: 'onboardingCompletado',
        valor: 'false',
        actualizadoEn: Value(now),
      ),
    );

    // Registro de auditoría de la inicialización del sistema
    await into(auditoria).insert(
      AuditoriaCompanion.insert(
        entidad: 'Sistema',
        entidadId: 0,
        accion: 'crear',
        resumen: 'Inicialización de esquema v1 y semillas de categorías predeterminadas',
        fechaHora: Value(now),
        creadoEn: Value(now),
      ),
    );
  }
}