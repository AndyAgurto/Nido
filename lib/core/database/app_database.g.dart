// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CuentasTable extends Cuentas with TableInfo<$CuentasTable, Cuenta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoInicialCentMeta = const VerificationMeta(
    'saldoInicialCent',
  );
  @override
  late final GeneratedColumn<int> saldoInicialCent = GeneratedColumn<int>(
    'saldo_inicial_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activaMeta = const VerificationMeta('activa');
  @override
  late final GeneratedColumn<bool> activa = GeneratedColumn<bool>(
    'activa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#0D5D38'),
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('account_balance_wallet'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipo,
    saldoInicialCent,
    activa,
    color,
    icono,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuentas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cuenta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('saldo_inicial_cent')) {
      context.handle(
        _saldoInicialCentMeta,
        saldoInicialCent.isAcceptableOrUnknown(
          data['saldo_inicial_cent']!,
          _saldoInicialCentMeta,
        ),
      );
    }
    if (data.containsKey('activa')) {
      context.handle(
        _activaMeta,
        activa.isAcceptableOrUnknown(data['activa']!, _activaMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cuenta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cuenta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      saldoInicialCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_inicial_cent'],
      )!,
      activa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activa'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $CuentasTable createAlias(String alias) {
    return $CuentasTable(attachedDatabase, alias);
  }
}

class Cuenta extends DataClass implements Insertable<Cuenta> {
  final int id;
  final String nombre;
  final String tipo;
  final int saldoInicialCent;
  final bool activa;
  final String color;
  final String icono;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const Cuenta({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.saldoInicialCent,
    required this.activa,
    required this.color,
    required this.icono,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    map['saldo_inicial_cent'] = Variable<int>(saldoInicialCent);
    map['activa'] = Variable<bool>(activa);
    map['color'] = Variable<String>(color);
    map['icono'] = Variable<String>(icono);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  CuentasCompanion toCompanion(bool nullToAbsent) {
    return CuentasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipo: Value(tipo),
      saldoInicialCent: Value(saldoInicialCent),
      activa: Value(activa),
      color: Value(color),
      icono: Value(icono),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Cuenta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cuenta(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      saldoInicialCent: serializer.fromJson<int>(json['saldoInicialCent']),
      activa: serializer.fromJson<bool>(json['activa']),
      color: serializer.fromJson<String>(json['color']),
      icono: serializer.fromJson<String>(json['icono']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'saldoInicialCent': serializer.toJson<int>(saldoInicialCent),
      'activa': serializer.toJson<bool>(activa),
      'color': serializer.toJson<String>(color),
      'icono': serializer.toJson<String>(icono),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Cuenta copyWith({
    int? id,
    String? nombre,
    String? tipo,
    int? saldoInicialCent,
    bool? activa,
    String? color,
    String? icono,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Cuenta(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    saldoInicialCent: saldoInicialCent ?? this.saldoInicialCent,
    activa: activa ?? this.activa,
    color: color ?? this.color,
    icono: icono ?? this.icono,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Cuenta copyWithCompanion(CuentasCompanion data) {
    return Cuenta(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      saldoInicialCent: data.saldoInicialCent.present
          ? data.saldoInicialCent.value
          : this.saldoInicialCent,
      activa: data.activa.present ? data.activa.value : this.activa,
      color: data.color.present ? data.color.value : this.color,
      icono: data.icono.present ? data.icono.value : this.icono,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cuenta(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('saldoInicialCent: $saldoInicialCent, ')
          ..write('activa: $activa, ')
          ..write('color: $color, ')
          ..write('icono: $icono, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    tipo,
    saldoInicialCent,
    activa,
    color,
    icono,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cuenta &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.saldoInicialCent == this.saldoInicialCent &&
          other.activa == this.activa &&
          other.color == this.color &&
          other.icono == this.icono &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class CuentasCompanion extends UpdateCompanion<Cuenta> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<int> saldoInicialCent;
  final Value<bool> activa;
  final Value<String> color;
  final Value<String> icono;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const CuentasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.saldoInicialCent = const Value.absent(),
    this.activa = const Value.absent(),
    this.color = const Value.absent(),
    this.icono = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  CuentasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String tipo,
    this.saldoInicialCent = const Value.absent(),
    this.activa = const Value.absent(),
    this.color = const Value.absent(),
    this.icono = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo);
  static Insertable<Cuenta> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<int>? saldoInicialCent,
    Expression<bool>? activa,
    Expression<String>? color,
    Expression<String>? icono,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (saldoInicialCent != null) 'saldo_inicial_cent': saldoInicialCent,
      if (activa != null) 'activa': activa,
      if (color != null) 'color': color,
      if (icono != null) 'icono': icono,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  CuentasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<int>? saldoInicialCent,
    Value<bool>? activa,
    Value<String>? color,
    Value<String>? icono,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return CuentasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      saldoInicialCent: saldoInicialCent ?? this.saldoInicialCent,
      activa: activa ?? this.activa,
      color: color ?? this.color,
      icono: icono ?? this.icono,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (saldoInicialCent.present) {
      map['saldo_inicial_cent'] = Variable<int>(saldoInicialCent.value);
    }
    if (activa.present) {
      map['activa'] = Variable<bool>(activa.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('saldoInicialCent: $saldoInicialCent, ')
          ..write('activa: $activa, ')
          ..write('color: $color, ')
          ..write('icono: $icono, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('category'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#4B6454'),
  );
  static const VerificationMeta _esSistemaMeta = const VerificationMeta(
    'esSistema',
  );
  @override
  late final GeneratedColumn<bool> esSistema = GeneratedColumn<bool>(
    'es_sistema',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_sistema" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activaMeta = const VerificationMeta('activa');
  @override
  late final GeneratedColumn<bool> activa = GeneratedColumn<bool>(
    'activa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipo,
    icono,
    color,
    esSistema,
    activa,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('es_sistema')) {
      context.handle(
        _esSistemaMeta,
        esSistema.isAcceptableOrUnknown(data['es_sistema']!, _esSistemaMeta),
      );
    }
    if (data.containsKey('activa')) {
      context.handle(
        _activaMeta,
        activa.isAcceptableOrUnknown(data['activa']!, _activaMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      esSistema: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_sistema'],
      )!,
      activa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activa'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final String tipo;
  final String icono;
  final String color;
  final bool esSistema;
  final bool activa;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const Categoria({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.icono,
    required this.color,
    required this.esSistema,
    required this.activa,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    map['icono'] = Variable<String>(icono);
    map['color'] = Variable<String>(color);
    map['es_sistema'] = Variable<bool>(esSistema);
    map['activa'] = Variable<bool>(activa);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipo: Value(tipo),
      icono: Value(icono),
      color: Value(color),
      esSistema: Value(esSistema),
      activa: Value(activa),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      icono: serializer.fromJson<String>(json['icono']),
      color: serializer.fromJson<String>(json['color']),
      esSistema: serializer.fromJson<bool>(json['esSistema']),
      activa: serializer.fromJson<bool>(json['activa']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'icono': serializer.toJson<String>(icono),
      'color': serializer.toJson<String>(color),
      'esSistema': serializer.toJson<bool>(esSistema),
      'activa': serializer.toJson<bool>(activa),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? tipo,
    String? icono,
    String? color,
    bool? esSistema,
    bool? activa,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Categoria(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    icono: icono ?? this.icono,
    color: color ?? this.color,
    esSistema: esSistema ?? this.esSistema,
    activa: activa ?? this.activa,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      icono: data.icono.present ? data.icono.value : this.icono,
      color: data.color.present ? data.color.value : this.color,
      esSistema: data.esSistema.present ? data.esSistema.value : this.esSistema,
      activa: data.activa.present ? data.activa.value : this.activa,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('icono: $icono, ')
          ..write('color: $color, ')
          ..write('esSistema: $esSistema, ')
          ..write('activa: $activa, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    tipo,
    icono,
    color,
    esSistema,
    activa,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.icono == this.icono &&
          other.color == this.color &&
          other.esSistema == this.esSistema &&
          other.activa == this.activa &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<String> icono;
  final Value<String> color;
  final Value<bool> esSistema;
  final Value<bool> activa;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.icono = const Value.absent(),
    this.color = const Value.absent(),
    this.esSistema = const Value.absent(),
    this.activa = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String tipo,
    this.icono = const Value.absent(),
    this.color = const Value.absent(),
    this.esSistema = const Value.absent(),
    this.activa = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<String>? icono,
    Expression<String>? color,
    Expression<bool>? esSistema,
    Expression<bool>? activa,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (icono != null) 'icono': icono,
      if (color != null) 'color': color,
      if (esSistema != null) 'es_sistema': esSistema,
      if (activa != null) 'activa': activa,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<String>? icono,
    Value<String>? color,
    Value<bool>? esSistema,
    Value<bool>? activa,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      icono: icono ?? this.icono,
      color: color ?? this.color,
      esSistema: esSistema ?? this.esSistema,
      activa: activa ?? this.activa,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (esSistema.present) {
      map['es_sistema'] = Variable<bool>(esSistema.value);
    }
    if (activa.present) {
      map['activa'] = Variable<bool>(activa.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('icono: $icono, ')
          ..write('color: $color, ')
          ..write('esSistema: $esSistema, ')
          ..write('activa: $activa, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, Movimiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoCentMeta = const VerificationMeta(
    'montoCent',
  );
  @override
  late final GeneratedColumn<int> montoCent = GeneratedColumn<int>(
    'monto_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cuentaOrigenIdMeta = const VerificationMeta(
    'cuentaOrigenId',
  );
  @override
  late final GeneratedColumn<int> cuentaOrigenId = GeneratedColumn<int>(
    'cuenta_origen_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id)',
    ),
  );
  static const VerificationMeta _cuentaDestinoIdMeta = const VerificationMeta(
    'cuentaDestinoId',
  );
  @override
  late final GeneratedColumn<int> cuentaDestinoId = GeneratedColumn<int>(
    'cuenta_destino_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id)',
    ),
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gastoFijoPagoIdMeta = const VerificationMeta(
    'gastoFijoPagoId',
  );
  @override
  late final GeneratedColumn<int> gastoFijoPagoId = GeneratedColumn<int>(
    'gasto_fijo_pago_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partidaIdMeta = const VerificationMeta(
    'partidaId',
  );
  @override
  late final GeneratedColumn<int> partidaId = GeneratedColumn<int>(
    'partida_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anuladoMeta = const VerificationMeta(
    'anulado',
  );
  @override
  late final GeneratedColumn<bool> anulado = GeneratedColumn<bool>(
    'anulado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("anulado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _anuladoEnMeta = const VerificationMeta(
    'anuladoEn',
  );
  @override
  late final GeneratedColumn<DateTime> anuladoEn = GeneratedColumn<DateTime>(
    'anulado_en',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motivoAnulacionMeta = const VerificationMeta(
    'motivoAnulacion',
  );
  @override
  late final GeneratedColumn<String> motivoAnulacion = GeneratedColumn<String>(
    'motivo_anulacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fecha,
    tipo,
    montoCent,
    cuentaOrigenId,
    cuentaDestinoId,
    categoriaId,
    descripcion,
    notas,
    gastoFijoPagoId,
    partidaId,
    anulado,
    anuladoEn,
    motivoAnulacion,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movimiento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('monto_cent')) {
      context.handle(
        _montoCentMeta,
        montoCent.isAcceptableOrUnknown(data['monto_cent']!, _montoCentMeta),
      );
    } else if (isInserting) {
      context.missing(_montoCentMeta);
    }
    if (data.containsKey('cuenta_origen_id')) {
      context.handle(
        _cuentaOrigenIdMeta,
        cuentaOrigenId.isAcceptableOrUnknown(
          data['cuenta_origen_id']!,
          _cuentaOrigenIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cuentaOrigenIdMeta);
    }
    if (data.containsKey('cuenta_destino_id')) {
      context.handle(
        _cuentaDestinoIdMeta,
        cuentaDestinoId.isAcceptableOrUnknown(
          data['cuenta_destino_id']!,
          _cuentaDestinoIdMeta,
        ),
      );
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('gasto_fijo_pago_id')) {
      context.handle(
        _gastoFijoPagoIdMeta,
        gastoFijoPagoId.isAcceptableOrUnknown(
          data['gasto_fijo_pago_id']!,
          _gastoFijoPagoIdMeta,
        ),
      );
    }
    if (data.containsKey('partida_id')) {
      context.handle(
        _partidaIdMeta,
        partidaId.isAcceptableOrUnknown(data['partida_id']!, _partidaIdMeta),
      );
    }
    if (data.containsKey('anulado')) {
      context.handle(
        _anuladoMeta,
        anulado.isAcceptableOrUnknown(data['anulado']!, _anuladoMeta),
      );
    }
    if (data.containsKey('anulado_en')) {
      context.handle(
        _anuladoEnMeta,
        anuladoEn.isAcceptableOrUnknown(data['anulado_en']!, _anuladoEnMeta),
      );
    }
    if (data.containsKey('motivo_anulacion')) {
      context.handle(
        _motivoAnulacionMeta,
        motivoAnulacion.isAcceptableOrUnknown(
          data['motivo_anulacion']!,
          _motivoAnulacionMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movimiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movimiento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      montoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_cent'],
      )!,
      cuentaOrigenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_origen_id'],
      )!,
      cuentaDestinoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_destino_id'],
      ),
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      gastoFijoPagoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gasto_fijo_pago_id'],
      ),
      partidaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partida_id'],
      ),
      anulado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}anulado'],
      )!,
      anuladoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}anulado_en'],
      ),
      motivoAnulacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo_anulacion'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }
}

class Movimiento extends DataClass implements Insertable<Movimiento> {
  final int id;
  final DateTime fecha;
  final String tipo;
  final int montoCent;
  final int cuentaOrigenId;
  final int? cuentaDestinoId;
  final int? categoriaId;
  final String descripcion;
  final String? notas;
  final int? gastoFijoPagoId;
  final int? partidaId;
  final bool anulado;
  final DateTime? anuladoEn;
  final String? motivoAnulacion;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const Movimiento({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.montoCent,
    required this.cuentaOrigenId,
    this.cuentaDestinoId,
    this.categoriaId,
    required this.descripcion,
    this.notas,
    this.gastoFijoPagoId,
    this.partidaId,
    required this.anulado,
    this.anuladoEn,
    this.motivoAnulacion,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<DateTime>(fecha);
    map['tipo'] = Variable<String>(tipo);
    map['monto_cent'] = Variable<int>(montoCent);
    map['cuenta_origen_id'] = Variable<int>(cuentaOrigenId);
    if (!nullToAbsent || cuentaDestinoId != null) {
      map['cuenta_destino_id'] = Variable<int>(cuentaDestinoId);
    }
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['descripcion'] = Variable<String>(descripcion);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || gastoFijoPagoId != null) {
      map['gasto_fijo_pago_id'] = Variable<int>(gastoFijoPagoId);
    }
    if (!nullToAbsent || partidaId != null) {
      map['partida_id'] = Variable<int>(partidaId);
    }
    map['anulado'] = Variable<bool>(anulado);
    if (!nullToAbsent || anuladoEn != null) {
      map['anulado_en'] = Variable<DateTime>(anuladoEn);
    }
    if (!nullToAbsent || motivoAnulacion != null) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      fecha: Value(fecha),
      tipo: Value(tipo),
      montoCent: Value(montoCent),
      cuentaOrigenId: Value(cuentaOrigenId),
      cuentaDestinoId: cuentaDestinoId == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaDestinoId),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      descripcion: Value(descripcion),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      gastoFijoPagoId: gastoFijoPagoId == null && nullToAbsent
          ? const Value.absent()
          : Value(gastoFijoPagoId),
      partidaId: partidaId == null && nullToAbsent
          ? const Value.absent()
          : Value(partidaId),
      anulado: Value(anulado),
      anuladoEn: anuladoEn == null && nullToAbsent
          ? const Value.absent()
          : Value(anuladoEn),
      motivoAnulacion: motivoAnulacion == null && nullToAbsent
          ? const Value.absent()
          : Value(motivoAnulacion),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Movimiento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movimiento(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      montoCent: serializer.fromJson<int>(json['montoCent']),
      cuentaOrigenId: serializer.fromJson<int>(json['cuentaOrigenId']),
      cuentaDestinoId: serializer.fromJson<int?>(json['cuentaDestinoId']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      notas: serializer.fromJson<String?>(json['notas']),
      gastoFijoPagoId: serializer.fromJson<int?>(json['gastoFijoPagoId']),
      partidaId: serializer.fromJson<int?>(json['partidaId']),
      anulado: serializer.fromJson<bool>(json['anulado']),
      anuladoEn: serializer.fromJson<DateTime?>(json['anuladoEn']),
      motivoAnulacion: serializer.fromJson<String?>(json['motivoAnulacion']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<String>(tipo),
      'montoCent': serializer.toJson<int>(montoCent),
      'cuentaOrigenId': serializer.toJson<int>(cuentaOrigenId),
      'cuentaDestinoId': serializer.toJson<int?>(cuentaDestinoId),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'descripcion': serializer.toJson<String>(descripcion),
      'notas': serializer.toJson<String?>(notas),
      'gastoFijoPagoId': serializer.toJson<int?>(gastoFijoPagoId),
      'partidaId': serializer.toJson<int?>(partidaId),
      'anulado': serializer.toJson<bool>(anulado),
      'anuladoEn': serializer.toJson<DateTime?>(anuladoEn),
      'motivoAnulacion': serializer.toJson<String?>(motivoAnulacion),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Movimiento copyWith({
    int? id,
    DateTime? fecha,
    String? tipo,
    int? montoCent,
    int? cuentaOrigenId,
    Value<int?> cuentaDestinoId = const Value.absent(),
    Value<int?> categoriaId = const Value.absent(),
    String? descripcion,
    Value<String?> notas = const Value.absent(),
    Value<int?> gastoFijoPagoId = const Value.absent(),
    Value<int?> partidaId = const Value.absent(),
    bool? anulado,
    Value<DateTime?> anuladoEn = const Value.absent(),
    Value<String?> motivoAnulacion = const Value.absent(),
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Movimiento(
    id: id ?? this.id,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    montoCent: montoCent ?? this.montoCent,
    cuentaOrigenId: cuentaOrigenId ?? this.cuentaOrigenId,
    cuentaDestinoId: cuentaDestinoId.present
        ? cuentaDestinoId.value
        : this.cuentaDestinoId,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    descripcion: descripcion ?? this.descripcion,
    notas: notas.present ? notas.value : this.notas,
    gastoFijoPagoId: gastoFijoPagoId.present
        ? gastoFijoPagoId.value
        : this.gastoFijoPagoId,
    partidaId: partidaId.present ? partidaId.value : this.partidaId,
    anulado: anulado ?? this.anulado,
    anuladoEn: anuladoEn.present ? anuladoEn.value : this.anuladoEn,
    motivoAnulacion: motivoAnulacion.present
        ? motivoAnulacion.value
        : this.motivoAnulacion,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Movimiento copyWithCompanion(MovimientosCompanion data) {
    return Movimiento(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCent: data.montoCent.present ? data.montoCent.value : this.montoCent,
      cuentaOrigenId: data.cuentaOrigenId.present
          ? data.cuentaOrigenId.value
          : this.cuentaOrigenId,
      cuentaDestinoId: data.cuentaDestinoId.present
          ? data.cuentaDestinoId.value
          : this.cuentaDestinoId,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      notas: data.notas.present ? data.notas.value : this.notas,
      gastoFijoPagoId: data.gastoFijoPagoId.present
          ? data.gastoFijoPagoId.value
          : this.gastoFijoPagoId,
      partidaId: data.partidaId.present ? data.partidaId.value : this.partidaId,
      anulado: data.anulado.present ? data.anulado.value : this.anulado,
      anuladoEn: data.anuladoEn.present ? data.anuladoEn.value : this.anuladoEn,
      motivoAnulacion: data.motivoAnulacion.present
          ? data.motivoAnulacion.value
          : this.motivoAnulacion,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movimiento(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('montoCent: $montoCent, ')
          ..write('cuentaOrigenId: $cuentaOrigenId, ')
          ..write('cuentaDestinoId: $cuentaDestinoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('descripcion: $descripcion, ')
          ..write('notas: $notas, ')
          ..write('gastoFijoPagoId: $gastoFijoPagoId, ')
          ..write('partidaId: $partidaId, ')
          ..write('anulado: $anulado, ')
          ..write('anuladoEn: $anuladoEn, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fecha,
    tipo,
    montoCent,
    cuentaOrigenId,
    cuentaDestinoId,
    categoriaId,
    descripcion,
    notas,
    gastoFijoPagoId,
    partidaId,
    anulado,
    anuladoEn,
    motivoAnulacion,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movimiento &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.montoCent == this.montoCent &&
          other.cuentaOrigenId == this.cuentaOrigenId &&
          other.cuentaDestinoId == this.cuentaDestinoId &&
          other.categoriaId == this.categoriaId &&
          other.descripcion == this.descripcion &&
          other.notas == this.notas &&
          other.gastoFijoPagoId == this.gastoFijoPagoId &&
          other.partidaId == this.partidaId &&
          other.anulado == this.anulado &&
          other.anuladoEn == this.anuladoEn &&
          other.motivoAnulacion == this.motivoAnulacion &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class MovimientosCompanion extends UpdateCompanion<Movimiento> {
  final Value<int> id;
  final Value<DateTime> fecha;
  final Value<String> tipo;
  final Value<int> montoCent;
  final Value<int> cuentaOrigenId;
  final Value<int?> cuentaDestinoId;
  final Value<int?> categoriaId;
  final Value<String> descripcion;
  final Value<String?> notas;
  final Value<int?> gastoFijoPagoId;
  final Value<int?> partidaId;
  final Value<bool> anulado;
  final Value<DateTime?> anuladoEn;
  final Value<String?> motivoAnulacion;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCent = const Value.absent(),
    this.cuentaOrigenId = const Value.absent(),
    this.cuentaDestinoId = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.notas = const Value.absent(),
    this.gastoFijoPagoId = const Value.absent(),
    this.partidaId = const Value.absent(),
    this.anulado = const Value.absent(),
    this.anuladoEn = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  MovimientosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fecha,
    required String tipo,
    required int montoCent,
    required int cuentaOrigenId,
    this.cuentaDestinoId = const Value.absent(),
    this.categoriaId = const Value.absent(),
    required String descripcion,
    this.notas = const Value.absent(),
    this.gastoFijoPagoId = const Value.absent(),
    this.partidaId = const Value.absent(),
    this.anulado = const Value.absent(),
    this.anuladoEn = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : fecha = Value(fecha),
       tipo = Value(tipo),
       montoCent = Value(montoCent),
       cuentaOrigenId = Value(cuentaOrigenId),
       descripcion = Value(descripcion);
  static Insertable<Movimiento> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha,
    Expression<String>? tipo,
    Expression<int>? montoCent,
    Expression<int>? cuentaOrigenId,
    Expression<int>? cuentaDestinoId,
    Expression<int>? categoriaId,
    Expression<String>? descripcion,
    Expression<String>? notas,
    Expression<int>? gastoFijoPagoId,
    Expression<int>? partidaId,
    Expression<bool>? anulado,
    Expression<DateTime>? anuladoEn,
    Expression<String>? motivoAnulacion,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (montoCent != null) 'monto_cent': montoCent,
      if (cuentaOrigenId != null) 'cuenta_origen_id': cuentaOrigenId,
      if (cuentaDestinoId != null) 'cuenta_destino_id': cuentaDestinoId,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (descripcion != null) 'descripcion': descripcion,
      if (notas != null) 'notas': notas,
      if (gastoFijoPagoId != null) 'gasto_fijo_pago_id': gastoFijoPagoId,
      if (partidaId != null) 'partida_id': partidaId,
      if (anulado != null) 'anulado': anulado,
      if (anuladoEn != null) 'anulado_en': anuladoEn,
      if (motivoAnulacion != null) 'motivo_anulacion': motivoAnulacion,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  MovimientosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fecha,
    Value<String>? tipo,
    Value<int>? montoCent,
    Value<int>? cuentaOrigenId,
    Value<int?>? cuentaDestinoId,
    Value<int?>? categoriaId,
    Value<String>? descripcion,
    Value<String?>? notas,
    Value<int?>? gastoFijoPagoId,
    Value<int?>? partidaId,
    Value<bool>? anulado,
    Value<DateTime?>? anuladoEn,
    Value<String?>? motivoAnulacion,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      montoCent: montoCent ?? this.montoCent,
      cuentaOrigenId: cuentaOrigenId ?? this.cuentaOrigenId,
      cuentaDestinoId: cuentaDestinoId ?? this.cuentaDestinoId,
      categoriaId: categoriaId ?? this.categoriaId,
      descripcion: descripcion ?? this.descripcion,
      notas: notas ?? this.notas,
      gastoFijoPagoId: gastoFijoPagoId ?? this.gastoFijoPagoId,
      partidaId: partidaId ?? this.partidaId,
      anulado: anulado ?? this.anulado,
      anuladoEn: anuladoEn ?? this.anuladoEn,
      motivoAnulacion: motivoAnulacion ?? this.motivoAnulacion,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (montoCent.present) {
      map['monto_cent'] = Variable<int>(montoCent.value);
    }
    if (cuentaOrigenId.present) {
      map['cuenta_origen_id'] = Variable<int>(cuentaOrigenId.value);
    }
    if (cuentaDestinoId.present) {
      map['cuenta_destino_id'] = Variable<int>(cuentaDestinoId.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (gastoFijoPagoId.present) {
      map['gasto_fijo_pago_id'] = Variable<int>(gastoFijoPagoId.value);
    }
    if (partidaId.present) {
      map['partida_id'] = Variable<int>(partidaId.value);
    }
    if (anulado.present) {
      map['anulado'] = Variable<bool>(anulado.value);
    }
    if (anuladoEn.present) {
      map['anulado_en'] = Variable<DateTime>(anuladoEn.value);
    }
    if (motivoAnulacion.present) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('montoCent: $montoCent, ')
          ..write('cuentaOrigenId: $cuentaOrigenId, ')
          ..write('cuentaDestinoId: $cuentaDestinoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('descripcion: $descripcion, ')
          ..write('notas: $notas, ')
          ..write('gastoFijoPagoId: $gastoFijoPagoId, ')
          ..write('partidaId: $partidaId, ')
          ..write('anulado: $anulado, ')
          ..write('anuladoEn: $anuladoEn, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $GastosFijosTable extends GastosFijos
    with TableInfo<$GastosFijosTable, GastosFijo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastosFijosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoEstimadoCentMeta = const VerificationMeta(
    'montoEstimadoCent',
  );
  @override
  late final GeneratedColumn<int> montoEstimadoCent = GeneratedColumn<int>(
    'monto_estimado_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _cuentaPagoIdMeta = const VerificationMeta(
    'cuentaPagoId',
  );
  @override
  late final GeneratedColumn<int> cuentaPagoId = GeneratedColumn<int>(
    'cuenta_pago_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id)',
    ),
  );
  static const VerificationMeta _diaVencimientoMeta = const VerificationMeta(
    'diaVencimiento',
  );
  @override
  late final GeneratedColumn<int> diaVencimiento = GeneratedColumn<int>(
    'dia_vencimiento',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frecuenciaMeta = const VerificationMeta(
    'frecuencia',
  );
  @override
  late final GeneratedColumn<String> frecuencia = GeneratedColumn<String>(
    'frecuencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mensual'),
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
    'fecha_fin',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    montoEstimadoCent,
    categoriaId,
    cuentaPagoId,
    diaVencimiento,
    frecuencia,
    fechaInicio,
    fechaFin,
    activo,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gastos_fijos';
  @override
  VerificationContext validateIntegrity(
    Insertable<GastosFijo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('monto_estimado_cent')) {
      context.handle(
        _montoEstimadoCentMeta,
        montoEstimadoCent.isAcceptableOrUnknown(
          data['monto_estimado_cent']!,
          _montoEstimadoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoEstimadoCentMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('cuenta_pago_id')) {
      context.handle(
        _cuentaPagoIdMeta,
        cuentaPagoId.isAcceptableOrUnknown(
          data['cuenta_pago_id']!,
          _cuentaPagoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cuentaPagoIdMeta);
    }
    if (data.containsKey('dia_vencimiento')) {
      context.handle(
        _diaVencimientoMeta,
        diaVencimiento.isAcceptableOrUnknown(
          data['dia_vencimiento']!,
          _diaVencimientoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diaVencimientoMeta);
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
        _frecuenciaMeta,
        frecuencia.isAcceptableOrUnknown(data['frecuencia']!, _frecuenciaMeta),
      );
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GastosFijo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GastosFijo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      montoEstimadoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_estimado_cent'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      cuentaPagoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_pago_id'],
      )!,
      diaVencimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_vencimiento'],
      )!,
      frecuencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frecuencia'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $GastosFijosTable createAlias(String alias) {
    return $GastosFijosTable(attachedDatabase, alias);
  }
}

class GastosFijo extends DataClass implements Insertable<GastosFijo> {
  final int id;
  final String nombre;
  final int montoEstimadoCent;
  final int categoriaId;
  final int cuentaPagoId;
  final int diaVencimiento;
  final String frecuencia;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const GastosFijo({
    required this.id,
    required this.nombre,
    required this.montoEstimadoCent,
    required this.categoriaId,
    required this.cuentaPagoId,
    required this.diaVencimiento,
    required this.frecuencia,
    required this.fechaInicio,
    this.fechaFin,
    required this.activo,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['monto_estimado_cent'] = Variable<int>(montoEstimadoCent);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['cuenta_pago_id'] = Variable<int>(cuentaPagoId);
    map['dia_vencimiento'] = Variable<int>(diaVencimiento);
    map['frecuencia'] = Variable<String>(frecuencia);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  GastosFijosCompanion toCompanion(bool nullToAbsent) {
    return GastosFijosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      montoEstimadoCent: Value(montoEstimadoCent),
      categoriaId: Value(categoriaId),
      cuentaPagoId: Value(cuentaPagoId),
      diaVencimiento: Value(diaVencimiento),
      frecuencia: Value(frecuencia),
      fechaInicio: Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory GastosFijo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GastosFijo(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      montoEstimadoCent: serializer.fromJson<int>(json['montoEstimadoCent']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      cuentaPagoId: serializer.fromJson<int>(json['cuentaPagoId']),
      diaVencimiento: serializer.fromJson<int>(json['diaVencimiento']),
      frecuencia: serializer.fromJson<String>(json['frecuencia']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'montoEstimadoCent': serializer.toJson<int>(montoEstimadoCent),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'cuentaPagoId': serializer.toJson<int>(cuentaPagoId),
      'diaVencimiento': serializer.toJson<int>(diaVencimiento),
      'frecuencia': serializer.toJson<String>(frecuencia),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  GastosFijo copyWith({
    int? id,
    String? nombre,
    int? montoEstimadoCent,
    int? categoriaId,
    int? cuentaPagoId,
    int? diaVencimiento,
    String? frecuencia,
    DateTime? fechaInicio,
    Value<DateTime?> fechaFin = const Value.absent(),
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => GastosFijo(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    montoEstimadoCent: montoEstimadoCent ?? this.montoEstimadoCent,
    categoriaId: categoriaId ?? this.categoriaId,
    cuentaPagoId: cuentaPagoId ?? this.cuentaPagoId,
    diaVencimiento: diaVencimiento ?? this.diaVencimiento,
    frecuencia: frecuencia ?? this.frecuencia,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  GastosFijo copyWithCompanion(GastosFijosCompanion data) {
    return GastosFijo(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      montoEstimadoCent: data.montoEstimadoCent.present
          ? data.montoEstimadoCent.value
          : this.montoEstimadoCent,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      cuentaPagoId: data.cuentaPagoId.present
          ? data.cuentaPagoId.value
          : this.cuentaPagoId,
      diaVencimiento: data.diaVencimiento.present
          ? data.diaVencimiento.value
          : this.diaVencimiento,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GastosFijo(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('montoEstimadoCent: $montoEstimadoCent, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('cuentaPagoId: $cuentaPagoId, ')
          ..write('diaVencimiento: $diaVencimiento, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    montoEstimadoCent,
    categoriaId,
    cuentaPagoId,
    diaVencimiento,
    frecuencia,
    fechaInicio,
    fechaFin,
    activo,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GastosFijo &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.montoEstimadoCent == this.montoEstimadoCent &&
          other.categoriaId == this.categoriaId &&
          other.cuentaPagoId == this.cuentaPagoId &&
          other.diaVencimiento == this.diaVencimiento &&
          other.frecuencia == this.frecuencia &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class GastosFijosCompanion extends UpdateCompanion<GastosFijo> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> montoEstimadoCent;
  final Value<int> categoriaId;
  final Value<int> cuentaPagoId;
  final Value<int> diaVencimiento;
  final Value<String> frecuencia;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const GastosFijosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.montoEstimadoCent = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.cuentaPagoId = const Value.absent(),
    this.diaVencimiento = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  GastosFijosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int montoEstimadoCent,
    required int categoriaId,
    required int cuentaPagoId,
    required int diaVencimiento,
    this.frecuencia = const Value.absent(),
    required DateTime fechaInicio,
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       montoEstimadoCent = Value(montoEstimadoCent),
       categoriaId = Value(categoriaId),
       cuentaPagoId = Value(cuentaPagoId),
       diaVencimiento = Value(diaVencimiento),
       fechaInicio = Value(fechaInicio);
  static Insertable<GastosFijo> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? montoEstimadoCent,
    Expression<int>? categoriaId,
    Expression<int>? cuentaPagoId,
    Expression<int>? diaVencimiento,
    Expression<String>? frecuencia,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (montoEstimadoCent != null) 'monto_estimado_cent': montoEstimadoCent,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (cuentaPagoId != null) 'cuenta_pago_id': cuentaPagoId,
      if (diaVencimiento != null) 'dia_vencimiento': diaVencimiento,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  GastosFijosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? montoEstimadoCent,
    Value<int>? categoriaId,
    Value<int>? cuentaPagoId,
    Value<int>? diaVencimiento,
    Value<String>? frecuencia,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return GastosFijosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      montoEstimadoCent: montoEstimadoCent ?? this.montoEstimadoCent,
      categoriaId: categoriaId ?? this.categoriaId,
      cuentaPagoId: cuentaPagoId ?? this.cuentaPagoId,
      diaVencimiento: diaVencimiento ?? this.diaVencimiento,
      frecuencia: frecuencia ?? this.frecuencia,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (montoEstimadoCent.present) {
      map['monto_estimado_cent'] = Variable<int>(montoEstimadoCent.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (cuentaPagoId.present) {
      map['cuenta_pago_id'] = Variable<int>(cuentaPagoId.value);
    }
    if (diaVencimiento.present) {
      map['dia_vencimiento'] = Variable<int>(diaVencimiento.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<String>(frecuencia.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastosFijosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('montoEstimadoCent: $montoEstimadoCent, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('cuentaPagoId: $cuentaPagoId, ')
          ..write('diaVencimiento: $diaVencimiento, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $GastosFijosPagosTable extends GastosFijosPagos
    with TableInfo<$GastosFijosPagosTable, GastosFijosPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastosFijosPagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gastoFijoIdMeta = const VerificationMeta(
    'gastoFijoId',
  );
  @override
  late final GeneratedColumn<int> gastoFijoId = GeneratedColumn<int>(
    'gasto_fijo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gastos_fijos (id)',
    ),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoEsperadoCentMeta = const VerificationMeta(
    'montoEsperadoCent',
  );
  @override
  late final GeneratedColumn<int> montoEsperadoCent = GeneratedColumn<int>(
    'monto_esperado_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _movimientoIdMeta = const VerificationMeta(
    'movimientoId',
  );
  @override
  late final GeneratedColumn<int> movimientoId = GeneratedColumn<int>(
    'movimiento_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movimientos (id)',
    ),
  );
  static const VerificationMeta _fechaVencimientoMeta = const VerificationMeta(
    'fechaVencimiento',
  );
  @override
  late final GeneratedColumn<DateTime> fechaVencimiento =
      GeneratedColumn<DateTime>(
        'fecha_vencimiento',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gastoFijoId,
    periodo,
    montoEsperadoCent,
    estado,
    movimientoId,
    fechaVencimiento,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gastos_fijos_pagos';
  @override
  VerificationContext validateIntegrity(
    Insertable<GastosFijosPago> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('gasto_fijo_id')) {
      context.handle(
        _gastoFijoIdMeta,
        gastoFijoId.isAcceptableOrUnknown(
          data['gasto_fijo_id']!,
          _gastoFijoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gastoFijoIdMeta);
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('monto_esperado_cent')) {
      context.handle(
        _montoEsperadoCentMeta,
        montoEsperadoCent.isAcceptableOrUnknown(
          data['monto_esperado_cent']!,
          _montoEsperadoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoEsperadoCentMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('movimiento_id')) {
      context.handle(
        _movimientoIdMeta,
        movimientoId.isAcceptableOrUnknown(
          data['movimiento_id']!,
          _movimientoIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_vencimiento')) {
      context.handle(
        _fechaVencimientoMeta,
        fechaVencimiento.isAcceptableOrUnknown(
          data['fecha_vencimiento']!,
          _fechaVencimientoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaVencimientoMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GastosFijosPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GastosFijosPago(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gastoFijoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gasto_fijo_id'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      montoEsperadoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_esperado_cent'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      movimientoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movimiento_id'],
      ),
      fechaVencimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_vencimiento'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $GastosFijosPagosTable createAlias(String alias) {
    return $GastosFijosPagosTable(attachedDatabase, alias);
  }
}

class GastosFijosPago extends DataClass implements Insertable<GastosFijosPago> {
  final int id;
  final int gastoFijoId;
  final String periodo;
  final int montoEsperadoCent;
  final String estado;
  final int? movimientoId;
  final DateTime fechaVencimiento;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const GastosFijosPago({
    required this.id,
    required this.gastoFijoId,
    required this.periodo,
    required this.montoEsperadoCent,
    required this.estado,
    this.movimientoId,
    required this.fechaVencimiento,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['gasto_fijo_id'] = Variable<int>(gastoFijoId);
    map['periodo'] = Variable<String>(periodo);
    map['monto_esperado_cent'] = Variable<int>(montoEsperadoCent);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || movimientoId != null) {
      map['movimiento_id'] = Variable<int>(movimientoId);
    }
    map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  GastosFijosPagosCompanion toCompanion(bool nullToAbsent) {
    return GastosFijosPagosCompanion(
      id: Value(id),
      gastoFijoId: Value(gastoFijoId),
      periodo: Value(periodo),
      montoEsperadoCent: Value(montoEsperadoCent),
      estado: Value(estado),
      movimientoId: movimientoId == null && nullToAbsent
          ? const Value.absent()
          : Value(movimientoId),
      fechaVencimiento: Value(fechaVencimiento),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory GastosFijosPago.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GastosFijosPago(
      id: serializer.fromJson<int>(json['id']),
      gastoFijoId: serializer.fromJson<int>(json['gastoFijoId']),
      periodo: serializer.fromJson<String>(json['periodo']),
      montoEsperadoCent: serializer.fromJson<int>(json['montoEsperadoCent']),
      estado: serializer.fromJson<String>(json['estado']),
      movimientoId: serializer.fromJson<int?>(json['movimientoId']),
      fechaVencimiento: serializer.fromJson<DateTime>(json['fechaVencimiento']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gastoFijoId': serializer.toJson<int>(gastoFijoId),
      'periodo': serializer.toJson<String>(periodo),
      'montoEsperadoCent': serializer.toJson<int>(montoEsperadoCent),
      'estado': serializer.toJson<String>(estado),
      'movimientoId': serializer.toJson<int?>(movimientoId),
      'fechaVencimiento': serializer.toJson<DateTime>(fechaVencimiento),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  GastosFijosPago copyWith({
    int? id,
    int? gastoFijoId,
    String? periodo,
    int? montoEsperadoCent,
    String? estado,
    Value<int?> movimientoId = const Value.absent(),
    DateTime? fechaVencimiento,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => GastosFijosPago(
    id: id ?? this.id,
    gastoFijoId: gastoFijoId ?? this.gastoFijoId,
    periodo: periodo ?? this.periodo,
    montoEsperadoCent: montoEsperadoCent ?? this.montoEsperadoCent,
    estado: estado ?? this.estado,
    movimientoId: movimientoId.present ? movimientoId.value : this.movimientoId,
    fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  GastosFijosPago copyWithCompanion(GastosFijosPagosCompanion data) {
    return GastosFijosPago(
      id: data.id.present ? data.id.value : this.id,
      gastoFijoId: data.gastoFijoId.present
          ? data.gastoFijoId.value
          : this.gastoFijoId,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      montoEsperadoCent: data.montoEsperadoCent.present
          ? data.montoEsperadoCent.value
          : this.montoEsperadoCent,
      estado: data.estado.present ? data.estado.value : this.estado,
      movimientoId: data.movimientoId.present
          ? data.movimientoId.value
          : this.movimientoId,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GastosFijosPago(')
          ..write('id: $id, ')
          ..write('gastoFijoId: $gastoFijoId, ')
          ..write('periodo: $periodo, ')
          ..write('montoEsperadoCent: $montoEsperadoCent, ')
          ..write('estado: $estado, ')
          ..write('movimientoId: $movimientoId, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gastoFijoId,
    periodo,
    montoEsperadoCent,
    estado,
    movimientoId,
    fechaVencimiento,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GastosFijosPago &&
          other.id == this.id &&
          other.gastoFijoId == this.gastoFijoId &&
          other.periodo == this.periodo &&
          other.montoEsperadoCent == this.montoEsperadoCent &&
          other.estado == this.estado &&
          other.movimientoId == this.movimientoId &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class GastosFijosPagosCompanion extends UpdateCompanion<GastosFijosPago> {
  final Value<int> id;
  final Value<int> gastoFijoId;
  final Value<String> periodo;
  final Value<int> montoEsperadoCent;
  final Value<String> estado;
  final Value<int?> movimientoId;
  final Value<DateTime> fechaVencimiento;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const GastosFijosPagosCompanion({
    this.id = const Value.absent(),
    this.gastoFijoId = const Value.absent(),
    this.periodo = const Value.absent(),
    this.montoEsperadoCent = const Value.absent(),
    this.estado = const Value.absent(),
    this.movimientoId = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  GastosFijosPagosCompanion.insert({
    this.id = const Value.absent(),
    required int gastoFijoId,
    required String periodo,
    required int montoEsperadoCent,
    this.estado = const Value.absent(),
    this.movimientoId = const Value.absent(),
    required DateTime fechaVencimiento,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : gastoFijoId = Value(gastoFijoId),
       periodo = Value(periodo),
       montoEsperadoCent = Value(montoEsperadoCent),
       fechaVencimiento = Value(fechaVencimiento);
  static Insertable<GastosFijosPago> custom({
    Expression<int>? id,
    Expression<int>? gastoFijoId,
    Expression<String>? periodo,
    Expression<int>? montoEsperadoCent,
    Expression<String>? estado,
    Expression<int>? movimientoId,
    Expression<DateTime>? fechaVencimiento,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gastoFijoId != null) 'gasto_fijo_id': gastoFijoId,
      if (periodo != null) 'periodo': periodo,
      if (montoEsperadoCent != null) 'monto_esperado_cent': montoEsperadoCent,
      if (estado != null) 'estado': estado,
      if (movimientoId != null) 'movimiento_id': movimientoId,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  GastosFijosPagosCompanion copyWith({
    Value<int>? id,
    Value<int>? gastoFijoId,
    Value<String>? periodo,
    Value<int>? montoEsperadoCent,
    Value<String>? estado,
    Value<int?>? movimientoId,
    Value<DateTime>? fechaVencimiento,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return GastosFijosPagosCompanion(
      id: id ?? this.id,
      gastoFijoId: gastoFijoId ?? this.gastoFijoId,
      periodo: periodo ?? this.periodo,
      montoEsperadoCent: montoEsperadoCent ?? this.montoEsperadoCent,
      estado: estado ?? this.estado,
      movimientoId: movimientoId ?? this.movimientoId,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gastoFijoId.present) {
      map['gasto_fijo_id'] = Variable<int>(gastoFijoId.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (montoEsperadoCent.present) {
      map['monto_esperado_cent'] = Variable<int>(montoEsperadoCent.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (movimientoId.present) {
      map['movimiento_id'] = Variable<int>(movimientoId.value);
    }
    if (fechaVencimiento.present) {
      map['fecha_vencimiento'] = Variable<DateTime>(fechaVencimiento.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastosFijosPagosCompanion(')
          ..write('id: $id, ')
          ..write('gastoFijoId: $gastoFijoId, ')
          ..write('periodo: $periodo, ')
          ..write('montoEsperadoCent: $montoEsperadoCent, ')
          ..write('estado: $estado, ')
          ..write('movimientoId: $movimientoId, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $IngresosFijosTable extends IngresosFijos
    with TableInfo<$IngresosFijosTable, IngresosFijo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngresosFijosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoEstimadoCentMeta = const VerificationMeta(
    'montoEstimadoCent',
  );
  @override
  late final GeneratedColumn<int> montoEstimadoCent = GeneratedColumn<int>(
    'monto_estimado_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cuentaIdMeta = const VerificationMeta(
    'cuentaId',
  );
  @override
  late final GeneratedColumn<int> cuentaId = GeneratedColumn<int>(
    'cuenta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cuentas (id)',
    ),
  );
  static const VerificationMeta _diaCobroMeta = const VerificationMeta(
    'diaCobro',
  );
  @override
  late final GeneratedColumn<int> diaCobro = GeneratedColumn<int>(
    'dia_cobro',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frecuenciaMeta = const VerificationMeta(
    'frecuencia',
  );
  @override
  late final GeneratedColumn<String> frecuencia = GeneratedColumn<String>(
    'frecuencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mensual'),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    montoEstimadoCent,
    cuentaId,
    diaCobro,
    frecuencia,
    activo,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingresos_fijos';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngresosFijo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('monto_estimado_cent')) {
      context.handle(
        _montoEstimadoCentMeta,
        montoEstimadoCent.isAcceptableOrUnknown(
          data['monto_estimado_cent']!,
          _montoEstimadoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoEstimadoCentMeta);
    }
    if (data.containsKey('cuenta_id')) {
      context.handle(
        _cuentaIdMeta,
        cuentaId.isAcceptableOrUnknown(data['cuenta_id']!, _cuentaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cuentaIdMeta);
    }
    if (data.containsKey('dia_cobro')) {
      context.handle(
        _diaCobroMeta,
        diaCobro.isAcceptableOrUnknown(data['dia_cobro']!, _diaCobroMeta),
      );
    } else if (isInserting) {
      context.missing(_diaCobroMeta);
    }
    if (data.containsKey('frecuencia')) {
      context.handle(
        _frecuenciaMeta,
        frecuencia.isAcceptableOrUnknown(data['frecuencia']!, _frecuenciaMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngresosFijo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngresosFijo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      montoEstimadoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_estimado_cent'],
      )!,
      cuentaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cuenta_id'],
      )!,
      diaCobro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia_cobro'],
      )!,
      frecuencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frecuencia'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $IngresosFijosTable createAlias(String alias) {
    return $IngresosFijosTable(attachedDatabase, alias);
  }
}

class IngresosFijo extends DataClass implements Insertable<IngresosFijo> {
  final int id;
  final String nombre;
  final int montoEstimadoCent;
  final int cuentaId;
  final int diaCobro;
  final String frecuencia;
  final bool activo;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const IngresosFijo({
    required this.id,
    required this.nombre,
    required this.montoEstimadoCent,
    required this.cuentaId,
    required this.diaCobro,
    required this.frecuencia,
    required this.activo,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['monto_estimado_cent'] = Variable<int>(montoEstimadoCent);
    map['cuenta_id'] = Variable<int>(cuentaId);
    map['dia_cobro'] = Variable<int>(diaCobro);
    map['frecuencia'] = Variable<String>(frecuencia);
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  IngresosFijosCompanion toCompanion(bool nullToAbsent) {
    return IngresosFijosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      montoEstimadoCent: Value(montoEstimadoCent),
      cuentaId: Value(cuentaId),
      diaCobro: Value(diaCobro),
      frecuencia: Value(frecuencia),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory IngresosFijo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngresosFijo(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      montoEstimadoCent: serializer.fromJson<int>(json['montoEstimadoCent']),
      cuentaId: serializer.fromJson<int>(json['cuentaId']),
      diaCobro: serializer.fromJson<int>(json['diaCobro']),
      frecuencia: serializer.fromJson<String>(json['frecuencia']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'montoEstimadoCent': serializer.toJson<int>(montoEstimadoCent),
      'cuentaId': serializer.toJson<int>(cuentaId),
      'diaCobro': serializer.toJson<int>(diaCobro),
      'frecuencia': serializer.toJson<String>(frecuencia),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  IngresosFijo copyWith({
    int? id,
    String? nombre,
    int? montoEstimadoCent,
    int? cuentaId,
    int? diaCobro,
    String? frecuencia,
    bool? activo,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => IngresosFijo(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    montoEstimadoCent: montoEstimadoCent ?? this.montoEstimadoCent,
    cuentaId: cuentaId ?? this.cuentaId,
    diaCobro: diaCobro ?? this.diaCobro,
    frecuencia: frecuencia ?? this.frecuencia,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  IngresosFijo copyWithCompanion(IngresosFijosCompanion data) {
    return IngresosFijo(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      montoEstimadoCent: data.montoEstimadoCent.present
          ? data.montoEstimadoCent.value
          : this.montoEstimadoCent,
      cuentaId: data.cuentaId.present ? data.cuentaId.value : this.cuentaId,
      diaCobro: data.diaCobro.present ? data.diaCobro.value : this.diaCobro,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngresosFijo(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('montoEstimadoCent: $montoEstimadoCent, ')
          ..write('cuentaId: $cuentaId, ')
          ..write('diaCobro: $diaCobro, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    montoEstimadoCent,
    cuentaId,
    diaCobro,
    frecuencia,
    activo,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngresosFijo &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.montoEstimadoCent == this.montoEstimadoCent &&
          other.cuentaId == this.cuentaId &&
          other.diaCobro == this.diaCobro &&
          other.frecuencia == this.frecuencia &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class IngresosFijosCompanion extends UpdateCompanion<IngresosFijo> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> montoEstimadoCent;
  final Value<int> cuentaId;
  final Value<int> diaCobro;
  final Value<String> frecuencia;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const IngresosFijosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.montoEstimadoCent = const Value.absent(),
    this.cuentaId = const Value.absent(),
    this.diaCobro = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  IngresosFijosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int montoEstimadoCent,
    required int cuentaId,
    required int diaCobro,
    this.frecuencia = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       montoEstimadoCent = Value(montoEstimadoCent),
       cuentaId = Value(cuentaId),
       diaCobro = Value(diaCobro);
  static Insertable<IngresosFijo> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? montoEstimadoCent,
    Expression<int>? cuentaId,
    Expression<int>? diaCobro,
    Expression<String>? frecuencia,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (montoEstimadoCent != null) 'monto_estimado_cent': montoEstimadoCent,
      if (cuentaId != null) 'cuenta_id': cuentaId,
      if (diaCobro != null) 'dia_cobro': diaCobro,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  IngresosFijosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? montoEstimadoCent,
    Value<int>? cuentaId,
    Value<int>? diaCobro,
    Value<String>? frecuencia,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return IngresosFijosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      montoEstimadoCent: montoEstimadoCent ?? this.montoEstimadoCent,
      cuentaId: cuentaId ?? this.cuentaId,
      diaCobro: diaCobro ?? this.diaCobro,
      frecuencia: frecuencia ?? this.frecuencia,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (montoEstimadoCent.present) {
      map['monto_estimado_cent'] = Variable<int>(montoEstimadoCent.value);
    }
    if (cuentaId.present) {
      map['cuenta_id'] = Variable<int>(cuentaId.value);
    }
    if (diaCobro.present) {
      map['dia_cobro'] = Variable<int>(diaCobro.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<String>(frecuencia.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngresosFijosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('montoEstimadoCent: $montoEstimadoCent, ')
          ..write('cuentaId: $cuentaId, ')
          ..write('diaCobro: $diaCobro, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $IngresosFijosCobrosTable extends IngresosFijosCobros
    with TableInfo<$IngresosFijosCobrosTable, IngresosFijosCobro> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngresosFijosCobrosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ingresoFijoIdMeta = const VerificationMeta(
    'ingresoFijoId',
  );
  @override
  late final GeneratedColumn<int> ingresoFijoId = GeneratedColumn<int>(
    'ingreso_fijo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingresos_fijos (id)',
    ),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoEsperadoCentMeta = const VerificationMeta(
    'montoEsperadoCent',
  );
  @override
  late final GeneratedColumn<int> montoEsperadoCent = GeneratedColumn<int>(
    'monto_esperado_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _movimientoIdMeta = const VerificationMeta(
    'movimientoId',
  );
  @override
  late final GeneratedColumn<int> movimientoId = GeneratedColumn<int>(
    'movimiento_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movimientos (id)',
    ),
  );
  static const VerificationMeta _fechaCobroEsperadaMeta =
      const VerificationMeta('fechaCobroEsperada');
  @override
  late final GeneratedColumn<DateTime> fechaCobroEsperada =
      GeneratedColumn<DateTime>(
        'fecha_cobro_esperada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingresoFijoId,
    periodo,
    montoEsperadoCent,
    estado,
    movimientoId,
    fechaCobroEsperada,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingresos_fijos_cobros';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngresosFijosCobro> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ingreso_fijo_id')) {
      context.handle(
        _ingresoFijoIdMeta,
        ingresoFijoId.isAcceptableOrUnknown(
          data['ingreso_fijo_id']!,
          _ingresoFijoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingresoFijoIdMeta);
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('monto_esperado_cent')) {
      context.handle(
        _montoEsperadoCentMeta,
        montoEsperadoCent.isAcceptableOrUnknown(
          data['monto_esperado_cent']!,
          _montoEsperadoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoEsperadoCentMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('movimiento_id')) {
      context.handle(
        _movimientoIdMeta,
        movimientoId.isAcceptableOrUnknown(
          data['movimiento_id']!,
          _movimientoIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_cobro_esperada')) {
      context.handle(
        _fechaCobroEsperadaMeta,
        fechaCobroEsperada.isAcceptableOrUnknown(
          data['fecha_cobro_esperada']!,
          _fechaCobroEsperadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCobroEsperadaMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngresosFijosCobro map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngresosFijosCobro(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ingresoFijoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingreso_fijo_id'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      montoEsperadoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_esperado_cent'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      movimientoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movimiento_id'],
      ),
      fechaCobroEsperada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cobro_esperada'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $IngresosFijosCobrosTable createAlias(String alias) {
    return $IngresosFijosCobrosTable(attachedDatabase, alias);
  }
}

class IngresosFijosCobro extends DataClass
    implements Insertable<IngresosFijosCobro> {
  final int id;
  final int ingresoFijoId;
  final String periodo;
  final int montoEsperadoCent;
  final String estado;
  final int? movimientoId;
  final DateTime fechaCobroEsperada;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const IngresosFijosCobro({
    required this.id,
    required this.ingresoFijoId,
    required this.periodo,
    required this.montoEsperadoCent,
    required this.estado,
    this.movimientoId,
    required this.fechaCobroEsperada,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ingreso_fijo_id'] = Variable<int>(ingresoFijoId);
    map['periodo'] = Variable<String>(periodo);
    map['monto_esperado_cent'] = Variable<int>(montoEsperadoCent);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || movimientoId != null) {
      map['movimiento_id'] = Variable<int>(movimientoId);
    }
    map['fecha_cobro_esperada'] = Variable<DateTime>(fechaCobroEsperada);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  IngresosFijosCobrosCompanion toCompanion(bool nullToAbsent) {
    return IngresosFijosCobrosCompanion(
      id: Value(id),
      ingresoFijoId: Value(ingresoFijoId),
      periodo: Value(periodo),
      montoEsperadoCent: Value(montoEsperadoCent),
      estado: Value(estado),
      movimientoId: movimientoId == null && nullToAbsent
          ? const Value.absent()
          : Value(movimientoId),
      fechaCobroEsperada: Value(fechaCobroEsperada),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory IngresosFijosCobro.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngresosFijosCobro(
      id: serializer.fromJson<int>(json['id']),
      ingresoFijoId: serializer.fromJson<int>(json['ingresoFijoId']),
      periodo: serializer.fromJson<String>(json['periodo']),
      montoEsperadoCent: serializer.fromJson<int>(json['montoEsperadoCent']),
      estado: serializer.fromJson<String>(json['estado']),
      movimientoId: serializer.fromJson<int?>(json['movimientoId']),
      fechaCobroEsperada: serializer.fromJson<DateTime>(
        json['fechaCobroEsperada'],
      ),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ingresoFijoId': serializer.toJson<int>(ingresoFijoId),
      'periodo': serializer.toJson<String>(periodo),
      'montoEsperadoCent': serializer.toJson<int>(montoEsperadoCent),
      'estado': serializer.toJson<String>(estado),
      'movimientoId': serializer.toJson<int?>(movimientoId),
      'fechaCobroEsperada': serializer.toJson<DateTime>(fechaCobroEsperada),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  IngresosFijosCobro copyWith({
    int? id,
    int? ingresoFijoId,
    String? periodo,
    int? montoEsperadoCent,
    String? estado,
    Value<int?> movimientoId = const Value.absent(),
    DateTime? fechaCobroEsperada,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => IngresosFijosCobro(
    id: id ?? this.id,
    ingresoFijoId: ingresoFijoId ?? this.ingresoFijoId,
    periodo: periodo ?? this.periodo,
    montoEsperadoCent: montoEsperadoCent ?? this.montoEsperadoCent,
    estado: estado ?? this.estado,
    movimientoId: movimientoId.present ? movimientoId.value : this.movimientoId,
    fechaCobroEsperada: fechaCobroEsperada ?? this.fechaCobroEsperada,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  IngresosFijosCobro copyWithCompanion(IngresosFijosCobrosCompanion data) {
    return IngresosFijosCobro(
      id: data.id.present ? data.id.value : this.id,
      ingresoFijoId: data.ingresoFijoId.present
          ? data.ingresoFijoId.value
          : this.ingresoFijoId,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      montoEsperadoCent: data.montoEsperadoCent.present
          ? data.montoEsperadoCent.value
          : this.montoEsperadoCent,
      estado: data.estado.present ? data.estado.value : this.estado,
      movimientoId: data.movimientoId.present
          ? data.movimientoId.value
          : this.movimientoId,
      fechaCobroEsperada: data.fechaCobroEsperada.present
          ? data.fechaCobroEsperada.value
          : this.fechaCobroEsperada,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngresosFijosCobro(')
          ..write('id: $id, ')
          ..write('ingresoFijoId: $ingresoFijoId, ')
          ..write('periodo: $periodo, ')
          ..write('montoEsperadoCent: $montoEsperadoCent, ')
          ..write('estado: $estado, ')
          ..write('movimientoId: $movimientoId, ')
          ..write('fechaCobroEsperada: $fechaCobroEsperada, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingresoFijoId,
    periodo,
    montoEsperadoCent,
    estado,
    movimientoId,
    fechaCobroEsperada,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngresosFijosCobro &&
          other.id == this.id &&
          other.ingresoFijoId == this.ingresoFijoId &&
          other.periodo == this.periodo &&
          other.montoEsperadoCent == this.montoEsperadoCent &&
          other.estado == this.estado &&
          other.movimientoId == this.movimientoId &&
          other.fechaCobroEsperada == this.fechaCobroEsperada &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class IngresosFijosCobrosCompanion extends UpdateCompanion<IngresosFijosCobro> {
  final Value<int> id;
  final Value<int> ingresoFijoId;
  final Value<String> periodo;
  final Value<int> montoEsperadoCent;
  final Value<String> estado;
  final Value<int?> movimientoId;
  final Value<DateTime> fechaCobroEsperada;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const IngresosFijosCobrosCompanion({
    this.id = const Value.absent(),
    this.ingresoFijoId = const Value.absent(),
    this.periodo = const Value.absent(),
    this.montoEsperadoCent = const Value.absent(),
    this.estado = const Value.absent(),
    this.movimientoId = const Value.absent(),
    this.fechaCobroEsperada = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  IngresosFijosCobrosCompanion.insert({
    this.id = const Value.absent(),
    required int ingresoFijoId,
    required String periodo,
    required int montoEsperadoCent,
    this.estado = const Value.absent(),
    this.movimientoId = const Value.absent(),
    required DateTime fechaCobroEsperada,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : ingresoFijoId = Value(ingresoFijoId),
       periodo = Value(periodo),
       montoEsperadoCent = Value(montoEsperadoCent),
       fechaCobroEsperada = Value(fechaCobroEsperada);
  static Insertable<IngresosFijosCobro> custom({
    Expression<int>? id,
    Expression<int>? ingresoFijoId,
    Expression<String>? periodo,
    Expression<int>? montoEsperadoCent,
    Expression<String>? estado,
    Expression<int>? movimientoId,
    Expression<DateTime>? fechaCobroEsperada,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingresoFijoId != null) 'ingreso_fijo_id': ingresoFijoId,
      if (periodo != null) 'periodo': periodo,
      if (montoEsperadoCent != null) 'monto_esperado_cent': montoEsperadoCent,
      if (estado != null) 'estado': estado,
      if (movimientoId != null) 'movimiento_id': movimientoId,
      if (fechaCobroEsperada != null)
        'fecha_cobro_esperada': fechaCobroEsperada,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  IngresosFijosCobrosCompanion copyWith({
    Value<int>? id,
    Value<int>? ingresoFijoId,
    Value<String>? periodo,
    Value<int>? montoEsperadoCent,
    Value<String>? estado,
    Value<int?>? movimientoId,
    Value<DateTime>? fechaCobroEsperada,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return IngresosFijosCobrosCompanion(
      id: id ?? this.id,
      ingresoFijoId: ingresoFijoId ?? this.ingresoFijoId,
      periodo: periodo ?? this.periodo,
      montoEsperadoCent: montoEsperadoCent ?? this.montoEsperadoCent,
      estado: estado ?? this.estado,
      movimientoId: movimientoId ?? this.movimientoId,
      fechaCobroEsperada: fechaCobroEsperada ?? this.fechaCobroEsperada,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ingresoFijoId.present) {
      map['ingreso_fijo_id'] = Variable<int>(ingresoFijoId.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (montoEsperadoCent.present) {
      map['monto_esperado_cent'] = Variable<int>(montoEsperadoCent.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (movimientoId.present) {
      map['movimiento_id'] = Variable<int>(movimientoId.value);
    }
    if (fechaCobroEsperada.present) {
      map['fecha_cobro_esperada'] = Variable<DateTime>(
        fechaCobroEsperada.value,
      );
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngresosFijosCobrosCompanion(')
          ..write('id: $id, ')
          ..write('ingresoFijoId: $ingresoFijoId, ')
          ..write('periodo: $periodo, ')
          ..write('montoEsperadoCent: $montoEsperadoCent, ')
          ..write('estado: $estado, ')
          ..write('movimientoId: $movimientoId, ')
          ..write('fechaCobroEsperada: $fechaCobroEsperada, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $PresupuestosMensualesTable extends PresupuestosMensuales
    with TableInfo<$PresupuestosMensualesTable, PresupuestosMensuale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestosMensualesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _montoCentMeta = const VerificationMeta(
    'montoCent',
  );
  @override
  late final GeneratedColumn<int> montoCent = GeneratedColumn<int>(
    'monto_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    periodo,
    categoriaId,
    montoCent,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuestos_mensuales';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresupuestosMensuale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('monto_cent')) {
      context.handle(
        _montoCentMeta,
        montoCent.isAcceptableOrUnknown(data['monto_cent']!, _montoCentMeta),
      );
    } else if (isInserting) {
      context.missing(_montoCentMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {periodo, categoriaId},
  ];
  @override
  PresupuestosMensuale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresupuestosMensuale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      montoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_cent'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $PresupuestosMensualesTable createAlias(String alias) {
    return $PresupuestosMensualesTable(attachedDatabase, alias);
  }
}

class PresupuestosMensuale extends DataClass
    implements Insertable<PresupuestosMensuale> {
  final int id;
  final String periodo;
  final int categoriaId;
  final int montoCent;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const PresupuestosMensuale({
    required this.id,
    required this.periodo,
    required this.categoriaId,
    required this.montoCent,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['periodo'] = Variable<String>(periodo);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['monto_cent'] = Variable<int>(montoCent);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  PresupuestosMensualesCompanion toCompanion(bool nullToAbsent) {
    return PresupuestosMensualesCompanion(
      id: Value(id),
      periodo: Value(periodo),
      categoriaId: Value(categoriaId),
      montoCent: Value(montoCent),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory PresupuestosMensuale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresupuestosMensuale(
      id: serializer.fromJson<int>(json['id']),
      periodo: serializer.fromJson<String>(json['periodo']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      montoCent: serializer.fromJson<int>(json['montoCent']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodo': serializer.toJson<String>(periodo),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'montoCent': serializer.toJson<int>(montoCent),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  PresupuestosMensuale copyWith({
    int? id,
    String? periodo,
    int? categoriaId,
    int? montoCent,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => PresupuestosMensuale(
    id: id ?? this.id,
    periodo: periodo ?? this.periodo,
    categoriaId: categoriaId ?? this.categoriaId,
    montoCent: montoCent ?? this.montoCent,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  PresupuestosMensuale copyWithCompanion(PresupuestosMensualesCompanion data) {
    return PresupuestosMensuale(
      id: data.id.present ? data.id.value : this.id,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      montoCent: data.montoCent.present ? data.montoCent.value : this.montoCent,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosMensuale(')
          ..write('id: $id, ')
          ..write('periodo: $periodo, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCent: $montoCent, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, periodo, categoriaId, montoCent, creadoEn, actualizadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresupuestosMensuale &&
          other.id == this.id &&
          other.periodo == this.periodo &&
          other.categoriaId == this.categoriaId &&
          other.montoCent == this.montoCent &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class PresupuestosMensualesCompanion
    extends UpdateCompanion<PresupuestosMensuale> {
  final Value<int> id;
  final Value<String> periodo;
  final Value<int> categoriaId;
  final Value<int> montoCent;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const PresupuestosMensualesCompanion({
    this.id = const Value.absent(),
    this.periodo = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.montoCent = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  PresupuestosMensualesCompanion.insert({
    this.id = const Value.absent(),
    required String periodo,
    required int categoriaId,
    required int montoCent,
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : periodo = Value(periodo),
       categoriaId = Value(categoriaId),
       montoCent = Value(montoCent);
  static Insertable<PresupuestosMensuale> custom({
    Expression<int>? id,
    Expression<String>? periodo,
    Expression<int>? categoriaId,
    Expression<int>? montoCent,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodo != null) 'periodo': periodo,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (montoCent != null) 'monto_cent': montoCent,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  PresupuestosMensualesCompanion copyWith({
    Value<int>? id,
    Value<String>? periodo,
    Value<int>? categoriaId,
    Value<int>? montoCent,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return PresupuestosMensualesCompanion(
      id: id ?? this.id,
      periodo: periodo ?? this.periodo,
      categoriaId: categoriaId ?? this.categoriaId,
      montoCent: montoCent ?? this.montoCent,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (montoCent.present) {
      map['monto_cent'] = Variable<int>(montoCent.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosMensualesCompanion(')
          ..write('id: $id, ')
          ..write('periodo: $periodo, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCent: $montoCent, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $ProyectosTable extends Proyectos
    with TableInfo<$ProyectosTable, Proyecto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProyectosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idea'),
  );
  static const VerificationMeta _presupuestoObjetivoCentMeta =
      const VerificationMeta('presupuestoObjetivoCent');
  @override
  late final GeneratedColumn<int> presupuestoObjetivoCent =
      GeneratedColumn<int>(
        'presupuesto_objetivo_cent',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fechaInicioEstimadaMeta =
      const VerificationMeta('fechaInicioEstimada');
  @override
  late final GeneratedColumn<DateTime> fechaInicioEstimada =
      GeneratedColumn<DateTime>(
        'fecha_inicio_estimada',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaFinEstimadaMeta = const VerificationMeta(
    'fechaFinEstimada',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFinEstimada =
      GeneratedColumn<DateTime>(
        'fecha_fin_estimada',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _prioridadMeta = const VerificationMeta(
    'prioridad',
  );
  @override
  late final GeneratedColumn<String> prioridad = GeneratedColumn<String>(
    'prioridad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('media'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    tipo,
    estado,
    presupuestoObjetivoCent,
    fechaInicioEstimada,
    fechaFinEstimada,
    prioridad,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proyectos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proyecto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('presupuesto_objetivo_cent')) {
      context.handle(
        _presupuestoObjetivoCentMeta,
        presupuestoObjetivoCent.isAcceptableOrUnknown(
          data['presupuesto_objetivo_cent']!,
          _presupuestoObjetivoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_presupuestoObjetivoCentMeta);
    }
    if (data.containsKey('fecha_inicio_estimada')) {
      context.handle(
        _fechaInicioEstimadaMeta,
        fechaInicioEstimada.isAcceptableOrUnknown(
          data['fecha_inicio_estimada']!,
          _fechaInicioEstimadaMeta,
        ),
      );
    }
    if (data.containsKey('fecha_fin_estimada')) {
      context.handle(
        _fechaFinEstimadaMeta,
        fechaFinEstimada.isAcceptableOrUnknown(
          data['fecha_fin_estimada']!,
          _fechaFinEstimadaMeta,
        ),
      );
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Proyecto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proyecto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      presupuestoObjetivoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}presupuesto_objetivo_cent'],
      )!,
      fechaInicioEstimada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio_estimada'],
      ),
      fechaFinEstimada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin_estimada'],
      ),
      prioridad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prioridad'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $ProyectosTable createAlias(String alias) {
    return $ProyectosTable(attachedDatabase, alias);
  }
}

class Proyecto extends DataClass implements Insertable<Proyecto> {
  final int id;
  final String nombre;
  final String? descripcion;
  final String tipo;
  final String estado;
  final int presupuestoObjetivoCent;
  final DateTime? fechaInicioEstimada;
  final DateTime? fechaFinEstimada;
  final String prioridad;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const Proyecto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.tipo,
    required this.estado,
    required this.presupuestoObjetivoCent,
    this.fechaInicioEstimada,
    this.fechaFinEstimada,
    required this.prioridad,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['tipo'] = Variable<String>(tipo);
    map['estado'] = Variable<String>(estado);
    map['presupuesto_objetivo_cent'] = Variable<int>(presupuestoObjetivoCent);
    if (!nullToAbsent || fechaInicioEstimada != null) {
      map['fecha_inicio_estimada'] = Variable<DateTime>(fechaInicioEstimada);
    }
    if (!nullToAbsent || fechaFinEstimada != null) {
      map['fecha_fin_estimada'] = Variable<DateTime>(fechaFinEstimada);
    }
    map['prioridad'] = Variable<String>(prioridad);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  ProyectosCompanion toCompanion(bool nullToAbsent) {
    return ProyectosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      tipo: Value(tipo),
      estado: Value(estado),
      presupuestoObjetivoCent: Value(presupuestoObjetivoCent),
      fechaInicioEstimada: fechaInicioEstimada == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInicioEstimada),
      fechaFinEstimada: fechaFinEstimada == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFinEstimada),
      prioridad: Value(prioridad),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Proyecto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proyecto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      tipo: serializer.fromJson<String>(json['tipo']),
      estado: serializer.fromJson<String>(json['estado']),
      presupuestoObjetivoCent: serializer.fromJson<int>(
        json['presupuestoObjetivoCent'],
      ),
      fechaInicioEstimada: serializer.fromJson<DateTime?>(
        json['fechaInicioEstimada'],
      ),
      fechaFinEstimada: serializer.fromJson<DateTime?>(
        json['fechaFinEstimada'],
      ),
      prioridad: serializer.fromJson<String>(json['prioridad']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'tipo': serializer.toJson<String>(tipo),
      'estado': serializer.toJson<String>(estado),
      'presupuestoObjetivoCent': serializer.toJson<int>(
        presupuestoObjetivoCent,
      ),
      'fechaInicioEstimada': serializer.toJson<DateTime?>(fechaInicioEstimada),
      'fechaFinEstimada': serializer.toJson<DateTime?>(fechaFinEstimada),
      'prioridad': serializer.toJson<String>(prioridad),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Proyecto copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    String? tipo,
    String? estado,
    int? presupuestoObjetivoCent,
    Value<DateTime?> fechaInicioEstimada = const Value.absent(),
    Value<DateTime?> fechaFinEstimada = const Value.absent(),
    String? prioridad,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Proyecto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    tipo: tipo ?? this.tipo,
    estado: estado ?? this.estado,
    presupuestoObjetivoCent:
        presupuestoObjetivoCent ?? this.presupuestoObjetivoCent,
    fechaInicioEstimada: fechaInicioEstimada.present
        ? fechaInicioEstimada.value
        : this.fechaInicioEstimada,
    fechaFinEstimada: fechaFinEstimada.present
        ? fechaFinEstimada.value
        : this.fechaFinEstimada,
    prioridad: prioridad ?? this.prioridad,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Proyecto copyWithCompanion(ProyectosCompanion data) {
    return Proyecto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      estado: data.estado.present ? data.estado.value : this.estado,
      presupuestoObjetivoCent: data.presupuestoObjetivoCent.present
          ? data.presupuestoObjetivoCent.value
          : this.presupuestoObjetivoCent,
      fechaInicioEstimada: data.fechaInicioEstimada.present
          ? data.fechaInicioEstimada.value
          : this.fechaInicioEstimada,
      fechaFinEstimada: data.fechaFinEstimada.present
          ? data.fechaFinEstimada.value
          : this.fechaFinEstimada,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proyecto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('estado: $estado, ')
          ..write('presupuestoObjetivoCent: $presupuestoObjetivoCent, ')
          ..write('fechaInicioEstimada: $fechaInicioEstimada, ')
          ..write('fechaFinEstimada: $fechaFinEstimada, ')
          ..write('prioridad: $prioridad, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    descripcion,
    tipo,
    estado,
    presupuestoObjetivoCent,
    fechaInicioEstimada,
    fechaFinEstimada,
    prioridad,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proyecto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.tipo == this.tipo &&
          other.estado == this.estado &&
          other.presupuestoObjetivoCent == this.presupuestoObjetivoCent &&
          other.fechaInicioEstimada == this.fechaInicioEstimada &&
          other.fechaFinEstimada == this.fechaFinEstimada &&
          other.prioridad == this.prioridad &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class ProyectosCompanion extends UpdateCompanion<Proyecto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String> tipo;
  final Value<String> estado;
  final Value<int> presupuestoObjetivoCent;
  final Value<DateTime?> fechaInicioEstimada;
  final Value<DateTime?> fechaFinEstimada;
  final Value<String> prioridad;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const ProyectosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.estado = const Value.absent(),
    this.presupuestoObjetivoCent = const Value.absent(),
    this.fechaInicioEstimada = const Value.absent(),
    this.fechaFinEstimada = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  ProyectosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required String tipo,
    this.estado = const Value.absent(),
    required int presupuestoObjetivoCent,
    this.fechaInicioEstimada = const Value.absent(),
    this.fechaFinEstimada = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo),
       presupuestoObjetivoCent = Value(presupuestoObjetivoCent);
  static Insertable<Proyecto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? tipo,
    Expression<String>? estado,
    Expression<int>? presupuestoObjetivoCent,
    Expression<DateTime>? fechaInicioEstimada,
    Expression<DateTime>? fechaFinEstimada,
    Expression<String>? prioridad,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipo != null) 'tipo': tipo,
      if (estado != null) 'estado': estado,
      if (presupuestoObjetivoCent != null)
        'presupuesto_objetivo_cent': presupuestoObjetivoCent,
      if (fechaInicioEstimada != null)
        'fecha_inicio_estimada': fechaInicioEstimada,
      if (fechaFinEstimada != null) 'fecha_fin_estimada': fechaFinEstimada,
      if (prioridad != null) 'prioridad': prioridad,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  ProyectosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String>? tipo,
    Value<String>? estado,
    Value<int>? presupuestoObjetivoCent,
    Value<DateTime?>? fechaInicioEstimada,
    Value<DateTime?>? fechaFinEstimada,
    Value<String>? prioridad,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return ProyectosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      presupuestoObjetivoCent:
          presupuestoObjetivoCent ?? this.presupuestoObjetivoCent,
      fechaInicioEstimada: fechaInicioEstimada ?? this.fechaInicioEstimada,
      fechaFinEstimada: fechaFinEstimada ?? this.fechaFinEstimada,
      prioridad: prioridad ?? this.prioridad,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (presupuestoObjetivoCent.present) {
      map['presupuesto_objetivo_cent'] = Variable<int>(
        presupuestoObjetivoCent.value,
      );
    }
    if (fechaInicioEstimada.present) {
      map['fecha_inicio_estimada'] = Variable<DateTime>(
        fechaInicioEstimada.value,
      );
    }
    if (fechaFinEstimada.present) {
      map['fecha_fin_estimada'] = Variable<DateTime>(fechaFinEstimada.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<String>(prioridad.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProyectosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('estado: $estado, ')
          ..write('presupuestoObjetivoCent: $presupuestoObjetivoCent, ')
          ..write('fechaInicioEstimada: $fechaInicioEstimada, ')
          ..write('fechaFinEstimada: $fechaFinEstimada, ')
          ..write('prioridad: $prioridad, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $PartidasProyectoTable extends PartidasProyecto
    with TableInfo<$PartidasProyectoTable, PartidasProyectoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartidasProyectoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proyectos (id)',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presupuestoCentMeta = const VerificationMeta(
    'presupuestoCent',
  );
  @override
  late final GeneratedColumn<int> presupuestoCent = GeneratedColumn<int>(
    'presupuesto_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cotizacionElegidaIdMeta =
      const VerificationMeta('cotizacionElegidaId');
  @override
  late final GeneratedColumn<int> cotizacionElegidaId = GeneratedColumn<int>(
    'cotizacion_elegida_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    proyectoId,
    nombre,
    descripcion,
    presupuestoCent,
    cotizacionElegidaId,
    estado,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partidas_proyecto';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartidasProyectoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_proyectoIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('presupuesto_cent')) {
      context.handle(
        _presupuestoCentMeta,
        presupuestoCent.isAcceptableOrUnknown(
          data['presupuesto_cent']!,
          _presupuestoCentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_presupuestoCentMeta);
    }
    if (data.containsKey('cotizacion_elegida_id')) {
      context.handle(
        _cotizacionElegidaIdMeta,
        cotizacionElegidaId.isAcceptableOrUnknown(
          data['cotizacion_elegida_id']!,
          _cotizacionElegidaIdMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartidasProyectoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartidasProyectoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      presupuestoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}presupuesto_cent'],
      )!,
      cotizacionElegidaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cotizacion_elegida_id'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $PartidasProyectoTable createAlias(String alias) {
    return $PartidasProyectoTable(attachedDatabase, alias);
  }
}

class PartidasProyectoData extends DataClass
    implements Insertable<PartidasProyectoData> {
  final int id;
  final int proyectoId;
  final String nombre;
  final String? descripcion;
  final int presupuestoCent;
  final int? cotizacionElegidaId;
  final String estado;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const PartidasProyectoData({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    this.descripcion,
    required this.presupuestoCent,
    this.cotizacionElegidaId,
    required this.estado,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['proyecto_id'] = Variable<int>(proyectoId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['presupuesto_cent'] = Variable<int>(presupuestoCent);
    if (!nullToAbsent || cotizacionElegidaId != null) {
      map['cotizacion_elegida_id'] = Variable<int>(cotizacionElegidaId);
    }
    map['estado'] = Variable<String>(estado);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  PartidasProyectoCompanion toCompanion(bool nullToAbsent) {
    return PartidasProyectoCompanion(
      id: Value(id),
      proyectoId: Value(proyectoId),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      presupuestoCent: Value(presupuestoCent),
      cotizacionElegidaId: cotizacionElegidaId == null && nullToAbsent
          ? const Value.absent()
          : Value(cotizacionElegidaId),
      estado: Value(estado),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory PartidasProyectoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartidasProyectoData(
      id: serializer.fromJson<int>(json['id']),
      proyectoId: serializer.fromJson<int>(json['proyectoId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      presupuestoCent: serializer.fromJson<int>(json['presupuestoCent']),
      cotizacionElegidaId: serializer.fromJson<int?>(
        json['cotizacionElegidaId'],
      ),
      estado: serializer.fromJson<String>(json['estado']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'proyectoId': serializer.toJson<int>(proyectoId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'presupuestoCent': serializer.toJson<int>(presupuestoCent),
      'cotizacionElegidaId': serializer.toJson<int?>(cotizacionElegidaId),
      'estado': serializer.toJson<String>(estado),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  PartidasProyectoData copyWith({
    int? id,
    int? proyectoId,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    int? presupuestoCent,
    Value<int?> cotizacionElegidaId = const Value.absent(),
    String? estado,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => PartidasProyectoData(
    id: id ?? this.id,
    proyectoId: proyectoId ?? this.proyectoId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    presupuestoCent: presupuestoCent ?? this.presupuestoCent,
    cotizacionElegidaId: cotizacionElegidaId.present
        ? cotizacionElegidaId.value
        : this.cotizacionElegidaId,
    estado: estado ?? this.estado,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  PartidasProyectoData copyWithCompanion(PartidasProyectoCompanion data) {
    return PartidasProyectoData(
      id: data.id.present ? data.id.value : this.id,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      presupuestoCent: data.presupuestoCent.present
          ? data.presupuestoCent.value
          : this.presupuestoCent,
      cotizacionElegidaId: data.cotizacionElegidaId.present
          ? data.cotizacionElegidaId.value
          : this.cotizacionElegidaId,
      estado: data.estado.present ? data.estado.value : this.estado,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartidasProyectoData(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('presupuestoCent: $presupuestoCent, ')
          ..write('cotizacionElegidaId: $cotizacionElegidaId, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    proyectoId,
    nombre,
    descripcion,
    presupuestoCent,
    cotizacionElegidaId,
    estado,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartidasProyectoData &&
          other.id == this.id &&
          other.proyectoId == this.proyectoId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.presupuestoCent == this.presupuestoCent &&
          other.cotizacionElegidaId == this.cotizacionElegidaId &&
          other.estado == this.estado &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class PartidasProyectoCompanion extends UpdateCompanion<PartidasProyectoData> {
  final Value<int> id;
  final Value<int> proyectoId;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<int> presupuestoCent;
  final Value<int?> cotizacionElegidaId;
  final Value<String> estado;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const PartidasProyectoCompanion({
    this.id = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.presupuestoCent = const Value.absent(),
    this.cotizacionElegidaId = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  PartidasProyectoCompanion.insert({
    this.id = const Value.absent(),
    required int proyectoId,
    required String nombre,
    this.descripcion = const Value.absent(),
    required int presupuestoCent,
    this.cotizacionElegidaId = const Value.absent(),
    this.estado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : proyectoId = Value(proyectoId),
       nombre = Value(nombre),
       presupuestoCent = Value(presupuestoCent);
  static Insertable<PartidasProyectoData> custom({
    Expression<int>? id,
    Expression<int>? proyectoId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<int>? presupuestoCent,
    Expression<int>? cotizacionElegidaId,
    Expression<String>? estado,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (presupuestoCent != null) 'presupuesto_cent': presupuestoCent,
      if (cotizacionElegidaId != null)
        'cotizacion_elegida_id': cotizacionElegidaId,
      if (estado != null) 'estado': estado,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  PartidasProyectoCompanion copyWith({
    Value<int>? id,
    Value<int>? proyectoId,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<int>? presupuestoCent,
    Value<int?>? cotizacionElegidaId,
    Value<String>? estado,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return PartidasProyectoCompanion(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      presupuestoCent: presupuestoCent ?? this.presupuestoCent,
      cotizacionElegidaId: cotizacionElegidaId ?? this.cotizacionElegidaId,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (presupuestoCent.present) {
      map['presupuesto_cent'] = Variable<int>(presupuestoCent.value);
    }
    if (cotizacionElegidaId.present) {
      map['cotizacion_elegida_id'] = Variable<int>(cotizacionElegidaId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartidasProyectoCompanion(')
          ..write('id: $id, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('presupuestoCent: $presupuestoCent, ')
          ..write('cotizacionElegidaId: $cotizacionElegidaId, ')
          ..write('estado: $estado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $CotizacionesTable extends Cotizaciones
    with TableInfo<$CotizacionesTable, Cotizacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CotizacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _partidaIdMeta = const VerificationMeta(
    'partidaId',
  );
  @override
  late final GeneratedColumn<int> partidaId = GeneratedColumn<int>(
    'partida_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partidas_proyecto (id)',
    ),
  );
  static const VerificationMeta _proveedorMeta = const VerificationMeta(
    'proveedor',
  );
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
    'proveedor',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactoMeta = const VerificationMeta(
    'contacto',
  );
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
    'contacto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _montoCentMeta = const VerificationMeta(
    'montoCent',
  );
  @override
  late final GeneratedColumn<int> montoCent = GeneratedColumn<int>(
    'monto_cent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vigenteHastaMeta = const VerificationMeta(
    'vigenteHasta',
  );
  @override
  late final GeneratedColumn<DateTime> vigenteHasta = GeneratedColumn<DateTime>(
    'vigente_hasta',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fotoRutaRelativaMeta = const VerificationMeta(
    'fotoRutaRelativa',
  );
  @override
  late final GeneratedColumn<String> fotoRutaRelativa = GeneratedColumn<String>(
    'foto_ruta_relativa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elegidaMeta = const VerificationMeta(
    'elegida',
  );
  @override
  late final GeneratedColumn<bool> elegida = GeneratedColumn<bool>(
    'elegida',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("elegida" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partidaId,
    proveedor,
    contacto,
    montoCent,
    fecha,
    vigenteHasta,
    notas,
    fotoRutaRelativa,
    elegida,
    creadoEn,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cotizaciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cotizacione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('partida_id')) {
      context.handle(
        _partidaIdMeta,
        partidaId.isAcceptableOrUnknown(data['partida_id']!, _partidaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partidaIdMeta);
    }
    if (data.containsKey('proveedor')) {
      context.handle(
        _proveedorMeta,
        proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta),
      );
    } else if (isInserting) {
      context.missing(_proveedorMeta);
    }
    if (data.containsKey('contacto')) {
      context.handle(
        _contactoMeta,
        contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta),
      );
    }
    if (data.containsKey('monto_cent')) {
      context.handle(
        _montoCentMeta,
        montoCent.isAcceptableOrUnknown(data['monto_cent']!, _montoCentMeta),
      );
    } else if (isInserting) {
      context.missing(_montoCentMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('vigente_hasta')) {
      context.handle(
        _vigenteHastaMeta,
        vigenteHasta.isAcceptableOrUnknown(
          data['vigente_hasta']!,
          _vigenteHastaMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('foto_ruta_relativa')) {
      context.handle(
        _fotoRutaRelativaMeta,
        fotoRutaRelativa.isAcceptableOrUnknown(
          data['foto_ruta_relativa']!,
          _fotoRutaRelativaMeta,
        ),
      );
    }
    if (data.containsKey('elegida')) {
      context.handle(
        _elegidaMeta,
        elegida.isAcceptableOrUnknown(data['elegida']!, _elegidaMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cotizacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cotizacione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partidaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partida_id'],
      )!,
      proveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor'],
      )!,
      contacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contacto'],
      ),
      montoCent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_cent'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      vigenteHasta: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}vigente_hasta'],
      ),
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      fotoRutaRelativa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_ruta_relativa'],
      ),
      elegida: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}elegida'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $CotizacionesTable createAlias(String alias) {
    return $CotizacionesTable(attachedDatabase, alias);
  }
}

class Cotizacione extends DataClass implements Insertable<Cotizacione> {
  final int id;
  final int partidaId;
  final String proveedor;
  final String? contacto;
  final int montoCent;
  final DateTime fecha;
  final DateTime? vigenteHasta;
  final String? notas;
  final String? fotoRutaRelativa;
  final bool elegida;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  const Cotizacione({
    required this.id,
    required this.partidaId,
    required this.proveedor,
    this.contacto,
    required this.montoCent,
    required this.fecha,
    this.vigenteHasta,
    this.notas,
    this.fotoRutaRelativa,
    required this.elegida,
    required this.creadoEn,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['partida_id'] = Variable<int>(partidaId);
    map['proveedor'] = Variable<String>(proveedor);
    if (!nullToAbsent || contacto != null) {
      map['contacto'] = Variable<String>(contacto);
    }
    map['monto_cent'] = Variable<int>(montoCent);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || vigenteHasta != null) {
      map['vigente_hasta'] = Variable<DateTime>(vigenteHasta);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || fotoRutaRelativa != null) {
      map['foto_ruta_relativa'] = Variable<String>(fotoRutaRelativa);
    }
    map['elegida'] = Variable<bool>(elegida);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  CotizacionesCompanion toCompanion(bool nullToAbsent) {
    return CotizacionesCompanion(
      id: Value(id),
      partidaId: Value(partidaId),
      proveedor: Value(proveedor),
      contacto: contacto == null && nullToAbsent
          ? const Value.absent()
          : Value(contacto),
      montoCent: Value(montoCent),
      fecha: Value(fecha),
      vigenteHasta: vigenteHasta == null && nullToAbsent
          ? const Value.absent()
          : Value(vigenteHasta),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      fotoRutaRelativa: fotoRutaRelativa == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoRutaRelativa),
      elegida: Value(elegida),
      creadoEn: Value(creadoEn),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Cotizacione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cotizacione(
      id: serializer.fromJson<int>(json['id']),
      partidaId: serializer.fromJson<int>(json['partidaId']),
      proveedor: serializer.fromJson<String>(json['proveedor']),
      contacto: serializer.fromJson<String?>(json['contacto']),
      montoCent: serializer.fromJson<int>(json['montoCent']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      vigenteHasta: serializer.fromJson<DateTime?>(json['vigenteHasta']),
      notas: serializer.fromJson<String?>(json['notas']),
      fotoRutaRelativa: serializer.fromJson<String?>(json['fotoRutaRelativa']),
      elegida: serializer.fromJson<bool>(json['elegida']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partidaId': serializer.toJson<int>(partidaId),
      'proveedor': serializer.toJson<String>(proveedor),
      'contacto': serializer.toJson<String?>(contacto),
      'montoCent': serializer.toJson<int>(montoCent),
      'fecha': serializer.toJson<DateTime>(fecha),
      'vigenteHasta': serializer.toJson<DateTime?>(vigenteHasta),
      'notas': serializer.toJson<String?>(notas),
      'fotoRutaRelativa': serializer.toJson<String?>(fotoRutaRelativa),
      'elegida': serializer.toJson<bool>(elegida),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Cotizacione copyWith({
    int? id,
    int? partidaId,
    String? proveedor,
    Value<String?> contacto = const Value.absent(),
    int? montoCent,
    DateTime? fecha,
    Value<DateTime?> vigenteHasta = const Value.absent(),
    Value<String?> notas = const Value.absent(),
    Value<String?> fotoRutaRelativa = const Value.absent(),
    bool? elegida,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) => Cotizacione(
    id: id ?? this.id,
    partidaId: partidaId ?? this.partidaId,
    proveedor: proveedor ?? this.proveedor,
    contacto: contacto.present ? contacto.value : this.contacto,
    montoCent: montoCent ?? this.montoCent,
    fecha: fecha ?? this.fecha,
    vigenteHasta: vigenteHasta.present ? vigenteHasta.value : this.vigenteHasta,
    notas: notas.present ? notas.value : this.notas,
    fotoRutaRelativa: fotoRutaRelativa.present
        ? fotoRutaRelativa.value
        : this.fotoRutaRelativa,
    elegida: elegida ?? this.elegida,
    creadoEn: creadoEn ?? this.creadoEn,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  Cotizacione copyWithCompanion(CotizacionesCompanion data) {
    return Cotizacione(
      id: data.id.present ? data.id.value : this.id,
      partidaId: data.partidaId.present ? data.partidaId.value : this.partidaId,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
      montoCent: data.montoCent.present ? data.montoCent.value : this.montoCent,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      vigenteHasta: data.vigenteHasta.present
          ? data.vigenteHasta.value
          : this.vigenteHasta,
      notas: data.notas.present ? data.notas.value : this.notas,
      fotoRutaRelativa: data.fotoRutaRelativa.present
          ? data.fotoRutaRelativa.value
          : this.fotoRutaRelativa,
      elegida: data.elegida.present ? data.elegida.value : this.elegida,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cotizacione(')
          ..write('id: $id, ')
          ..write('partidaId: $partidaId, ')
          ..write('proveedor: $proveedor, ')
          ..write('contacto: $contacto, ')
          ..write('montoCent: $montoCent, ')
          ..write('fecha: $fecha, ')
          ..write('vigenteHasta: $vigenteHasta, ')
          ..write('notas: $notas, ')
          ..write('fotoRutaRelativa: $fotoRutaRelativa, ')
          ..write('elegida: $elegida, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partidaId,
    proveedor,
    contacto,
    montoCent,
    fecha,
    vigenteHasta,
    notas,
    fotoRutaRelativa,
    elegida,
    creadoEn,
    actualizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cotizacione &&
          other.id == this.id &&
          other.partidaId == this.partidaId &&
          other.proveedor == this.proveedor &&
          other.contacto == this.contacto &&
          other.montoCent == this.montoCent &&
          other.fecha == this.fecha &&
          other.vigenteHasta == this.vigenteHasta &&
          other.notas == this.notas &&
          other.fotoRutaRelativa == this.fotoRutaRelativa &&
          other.elegida == this.elegida &&
          other.creadoEn == this.creadoEn &&
          other.actualizadoEn == this.actualizadoEn);
}

class CotizacionesCompanion extends UpdateCompanion<Cotizacione> {
  final Value<int> id;
  final Value<int> partidaId;
  final Value<String> proveedor;
  final Value<String?> contacto;
  final Value<int> montoCent;
  final Value<DateTime> fecha;
  final Value<DateTime?> vigenteHasta;
  final Value<String?> notas;
  final Value<String?> fotoRutaRelativa;
  final Value<bool> elegida;
  final Value<DateTime> creadoEn;
  final Value<DateTime> actualizadoEn;
  const CotizacionesCompanion({
    this.id = const Value.absent(),
    this.partidaId = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.contacto = const Value.absent(),
    this.montoCent = const Value.absent(),
    this.fecha = const Value.absent(),
    this.vigenteHasta = const Value.absent(),
    this.notas = const Value.absent(),
    this.fotoRutaRelativa = const Value.absent(),
    this.elegida = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  CotizacionesCompanion.insert({
    this.id = const Value.absent(),
    required int partidaId,
    required String proveedor,
    this.contacto = const Value.absent(),
    required int montoCent,
    required DateTime fecha,
    this.vigenteHasta = const Value.absent(),
    this.notas = const Value.absent(),
    this.fotoRutaRelativa = const Value.absent(),
    this.elegida = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  }) : partidaId = Value(partidaId),
       proveedor = Value(proveedor),
       montoCent = Value(montoCent),
       fecha = Value(fecha);
  static Insertable<Cotizacione> custom({
    Expression<int>? id,
    Expression<int>? partidaId,
    Expression<String>? proveedor,
    Expression<String>? contacto,
    Expression<int>? montoCent,
    Expression<DateTime>? fecha,
    Expression<DateTime>? vigenteHasta,
    Expression<String>? notas,
    Expression<String>? fotoRutaRelativa,
    Expression<bool>? elegida,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partidaId != null) 'partida_id': partidaId,
      if (proveedor != null) 'proveedor': proveedor,
      if (contacto != null) 'contacto': contacto,
      if (montoCent != null) 'monto_cent': montoCent,
      if (fecha != null) 'fecha': fecha,
      if (vigenteHasta != null) 'vigente_hasta': vigenteHasta,
      if (notas != null) 'notas': notas,
      if (fotoRutaRelativa != null) 'foto_ruta_relativa': fotoRutaRelativa,
      if (elegida != null) 'elegida': elegida,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  CotizacionesCompanion copyWith({
    Value<int>? id,
    Value<int>? partidaId,
    Value<String>? proveedor,
    Value<String?>? contacto,
    Value<int>? montoCent,
    Value<DateTime>? fecha,
    Value<DateTime?>? vigenteHasta,
    Value<String?>? notas,
    Value<String?>? fotoRutaRelativa,
    Value<bool>? elegida,
    Value<DateTime>? creadoEn,
    Value<DateTime>? actualizadoEn,
  }) {
    return CotizacionesCompanion(
      id: id ?? this.id,
      partidaId: partidaId ?? this.partidaId,
      proveedor: proveedor ?? this.proveedor,
      contacto: contacto ?? this.contacto,
      montoCent: montoCent ?? this.montoCent,
      fecha: fecha ?? this.fecha,
      vigenteHasta: vigenteHasta ?? this.vigenteHasta,
      notas: notas ?? this.notas,
      fotoRutaRelativa: fotoRutaRelativa ?? this.fotoRutaRelativa,
      elegida: elegida ?? this.elegida,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partidaId.present) {
      map['partida_id'] = Variable<int>(partidaId.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    if (montoCent.present) {
      map['monto_cent'] = Variable<int>(montoCent.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (vigenteHasta.present) {
      map['vigente_hasta'] = Variable<DateTime>(vigenteHasta.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (fotoRutaRelativa.present) {
      map['foto_ruta_relativa'] = Variable<String>(fotoRutaRelativa.value);
    }
    if (elegida.present) {
      map['elegida'] = Variable<bool>(elegida.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CotizacionesCompanion(')
          ..write('id: $id, ')
          ..write('partidaId: $partidaId, ')
          ..write('proveedor: $proveedor, ')
          ..write('contacto: $contacto, ')
          ..write('montoCent: $montoCent, ')
          ..write('fecha: $fecha, ')
          ..write('vigenteHasta: $vigenteHasta, ')
          ..write('notas: $notas, ')
          ..write('fotoRutaRelativa: $fotoRutaRelativa, ')
          ..write('elegida: $elegida, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class $AuditoriaTable extends Auditoria
    with TableInfo<$AuditoriaTable, AuditoriaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditoriaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fechaHoraMeta = const VerificationMeta(
    'fechaHora',
  );
  @override
  late final GeneratedColumn<DateTime> fechaHora = GeneratedColumn<DateTime>(
    'fecha_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _entidadMeta = const VerificationMeta(
    'entidad',
  );
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
    'entidad',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entidadIdMeta = const VerificationMeta(
    'entidadId',
  );
  @override
  late final GeneratedColumn<int> entidadId = GeneratedColumn<int>(
    'entidad_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accionMeta = const VerificationMeta('accion');
  @override
  late final GeneratedColumn<String> accion = GeneratedColumn<String>(
    'accion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorAnteriorJsonMeta = const VerificationMeta(
    'valorAnteriorJson',
  );
  @override
  late final GeneratedColumn<String> valorAnteriorJson =
      GeneratedColumn<String>(
        'valor_anterior_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _valorNuevoJsonMeta = const VerificationMeta(
    'valorNuevoJson',
  );
  @override
  late final GeneratedColumn<String> valorNuevoJson = GeneratedColumn<String>(
    'valor_nuevo_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resumenMeta = const VerificationMeta(
    'resumen',
  );
  @override
  late final GeneratedColumn<String> resumen = GeneratedColumn<String>(
    'resumen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fechaHora,
    entidad,
    entidadId,
    accion,
    valorAnteriorJson,
    valorNuevoJson,
    resumen,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auditoria';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditoriaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_hora')) {
      context.handle(
        _fechaHoraMeta,
        fechaHora.isAcceptableOrUnknown(data['fecha_hora']!, _fechaHoraMeta),
      );
    }
    if (data.containsKey('entidad')) {
      context.handle(
        _entidadMeta,
        entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta),
      );
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    if (data.containsKey('entidad_id')) {
      context.handle(
        _entidadIdMeta,
        entidadId.isAcceptableOrUnknown(data['entidad_id']!, _entidadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entidadIdMeta);
    }
    if (data.containsKey('accion')) {
      context.handle(
        _accionMeta,
        accion.isAcceptableOrUnknown(data['accion']!, _accionMeta),
      );
    } else if (isInserting) {
      context.missing(_accionMeta);
    }
    if (data.containsKey('valor_anterior_json')) {
      context.handle(
        _valorAnteriorJsonMeta,
        valorAnteriorJson.isAcceptableOrUnknown(
          data['valor_anterior_json']!,
          _valorAnteriorJsonMeta,
        ),
      );
    }
    if (data.containsKey('valor_nuevo_json')) {
      context.handle(
        _valorNuevoJsonMeta,
        valorNuevoJson.isAcceptableOrUnknown(
          data['valor_nuevo_json']!,
          _valorNuevoJsonMeta,
        ),
      );
    }
    if (data.containsKey('resumen')) {
      context.handle(
        _resumenMeta,
        resumen.isAcceptableOrUnknown(data['resumen']!, _resumenMeta),
      );
    } else if (isInserting) {
      context.missing(_resumenMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditoriaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditoriaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fechaHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_hora'],
      )!,
      entidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entidad'],
      )!,
      entidadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entidad_id'],
      )!,
      accion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accion'],
      )!,
      valorAnteriorJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor_anterior_json'],
      ),
      valorNuevoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor_nuevo_json'],
      ),
      resumen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resumen'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $AuditoriaTable createAlias(String alias) {
    return $AuditoriaTable(attachedDatabase, alias);
  }
}

class AuditoriaData extends DataClass implements Insertable<AuditoriaData> {
  final int id;
  final DateTime fechaHora;
  final String entidad;
  final int entidadId;
  final String accion;
  final String? valorAnteriorJson;
  final String? valorNuevoJson;
  final String resumen;
  final DateTime creadoEn;
  const AuditoriaData({
    required this.id,
    required this.fechaHora,
    required this.entidad,
    required this.entidadId,
    required this.accion,
    this.valorAnteriorJson,
    this.valorNuevoJson,
    required this.resumen,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_hora'] = Variable<DateTime>(fechaHora);
    map['entidad'] = Variable<String>(entidad);
    map['entidad_id'] = Variable<int>(entidadId);
    map['accion'] = Variable<String>(accion);
    if (!nullToAbsent || valorAnteriorJson != null) {
      map['valor_anterior_json'] = Variable<String>(valorAnteriorJson);
    }
    if (!nullToAbsent || valorNuevoJson != null) {
      map['valor_nuevo_json'] = Variable<String>(valorNuevoJson);
    }
    map['resumen'] = Variable<String>(resumen);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  AuditoriaCompanion toCompanion(bool nullToAbsent) {
    return AuditoriaCompanion(
      id: Value(id),
      fechaHora: Value(fechaHora),
      entidad: Value(entidad),
      entidadId: Value(entidadId),
      accion: Value(accion),
      valorAnteriorJson: valorAnteriorJson == null && nullToAbsent
          ? const Value.absent()
          : Value(valorAnteriorJson),
      valorNuevoJson: valorNuevoJson == null && nullToAbsent
          ? const Value.absent()
          : Value(valorNuevoJson),
      resumen: Value(resumen),
      creadoEn: Value(creadoEn),
    );
  }

  factory AuditoriaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditoriaData(
      id: serializer.fromJson<int>(json['id']),
      fechaHora: serializer.fromJson<DateTime>(json['fechaHora']),
      entidad: serializer.fromJson<String>(json['entidad']),
      entidadId: serializer.fromJson<int>(json['entidadId']),
      accion: serializer.fromJson<String>(json['accion']),
      valorAnteriorJson: serializer.fromJson<String?>(
        json['valorAnteriorJson'],
      ),
      valorNuevoJson: serializer.fromJson<String?>(json['valorNuevoJson']),
      resumen: serializer.fromJson<String>(json['resumen']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fechaHora': serializer.toJson<DateTime>(fechaHora),
      'entidad': serializer.toJson<String>(entidad),
      'entidadId': serializer.toJson<int>(entidadId),
      'accion': serializer.toJson<String>(accion),
      'valorAnteriorJson': serializer.toJson<String?>(valorAnteriorJson),
      'valorNuevoJson': serializer.toJson<String?>(valorNuevoJson),
      'resumen': serializer.toJson<String>(resumen),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  AuditoriaData copyWith({
    int? id,
    DateTime? fechaHora,
    String? entidad,
    int? entidadId,
    String? accion,
    Value<String?> valorAnteriorJson = const Value.absent(),
    Value<String?> valorNuevoJson = const Value.absent(),
    String? resumen,
    DateTime? creadoEn,
  }) => AuditoriaData(
    id: id ?? this.id,
    fechaHora: fechaHora ?? this.fechaHora,
    entidad: entidad ?? this.entidad,
    entidadId: entidadId ?? this.entidadId,
    accion: accion ?? this.accion,
    valorAnteriorJson: valorAnteriorJson.present
        ? valorAnteriorJson.value
        : this.valorAnteriorJson,
    valorNuevoJson: valorNuevoJson.present
        ? valorNuevoJson.value
        : this.valorNuevoJson,
    resumen: resumen ?? this.resumen,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  AuditoriaData copyWithCompanion(AuditoriaCompanion data) {
    return AuditoriaData(
      id: data.id.present ? data.id.value : this.id,
      fechaHora: data.fechaHora.present ? data.fechaHora.value : this.fechaHora,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
      entidadId: data.entidadId.present ? data.entidadId.value : this.entidadId,
      accion: data.accion.present ? data.accion.value : this.accion,
      valorAnteriorJson: data.valorAnteriorJson.present
          ? data.valorAnteriorJson.value
          : this.valorAnteriorJson,
      valorNuevoJson: data.valorNuevoJson.present
          ? data.valorNuevoJson.value
          : this.valorNuevoJson,
      resumen: data.resumen.present ? data.resumen.value : this.resumen,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriaData(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('accion: $accion, ')
          ..write('valorAnteriorJson: $valorAnteriorJson, ')
          ..write('valorNuevoJson: $valorNuevoJson, ')
          ..write('resumen: $resumen, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fechaHora,
    entidad,
    entidadId,
    accion,
    valorAnteriorJson,
    valorNuevoJson,
    resumen,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditoriaData &&
          other.id == this.id &&
          other.fechaHora == this.fechaHora &&
          other.entidad == this.entidad &&
          other.entidadId == this.entidadId &&
          other.accion == this.accion &&
          other.valorAnteriorJson == this.valorAnteriorJson &&
          other.valorNuevoJson == this.valorNuevoJson &&
          other.resumen == this.resumen &&
          other.creadoEn == this.creadoEn);
}

class AuditoriaCompanion extends UpdateCompanion<AuditoriaData> {
  final Value<int> id;
  final Value<DateTime> fechaHora;
  final Value<String> entidad;
  final Value<int> entidadId;
  final Value<String> accion;
  final Value<String?> valorAnteriorJson;
  final Value<String?> valorNuevoJson;
  final Value<String> resumen;
  final Value<DateTime> creadoEn;
  const AuditoriaCompanion({
    this.id = const Value.absent(),
    this.fechaHora = const Value.absent(),
    this.entidad = const Value.absent(),
    this.entidadId = const Value.absent(),
    this.accion = const Value.absent(),
    this.valorAnteriorJson = const Value.absent(),
    this.valorNuevoJson = const Value.absent(),
    this.resumen = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  AuditoriaCompanion.insert({
    this.id = const Value.absent(),
    this.fechaHora = const Value.absent(),
    required String entidad,
    required int entidadId,
    required String accion,
    this.valorAnteriorJson = const Value.absent(),
    this.valorNuevoJson = const Value.absent(),
    required String resumen,
    this.creadoEn = const Value.absent(),
  }) : entidad = Value(entidad),
       entidadId = Value(entidadId),
       accion = Value(accion),
       resumen = Value(resumen);
  static Insertable<AuditoriaData> custom({
    Expression<int>? id,
    Expression<DateTime>? fechaHora,
    Expression<String>? entidad,
    Expression<int>? entidadId,
    Expression<String>? accion,
    Expression<String>? valorAnteriorJson,
    Expression<String>? valorNuevoJson,
    Expression<String>? resumen,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaHora != null) 'fecha_hora': fechaHora,
      if (entidad != null) 'entidad': entidad,
      if (entidadId != null) 'entidad_id': entidadId,
      if (accion != null) 'accion': accion,
      if (valorAnteriorJson != null) 'valor_anterior_json': valorAnteriorJson,
      if (valorNuevoJson != null) 'valor_nuevo_json': valorNuevoJson,
      if (resumen != null) 'resumen': resumen,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  AuditoriaCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fechaHora,
    Value<String>? entidad,
    Value<int>? entidadId,
    Value<String>? accion,
    Value<String?>? valorAnteriorJson,
    Value<String?>? valorNuevoJson,
    Value<String>? resumen,
    Value<DateTime>? creadoEn,
  }) {
    return AuditoriaCompanion(
      id: id ?? this.id,
      fechaHora: fechaHora ?? this.fechaHora,
      entidad: entidad ?? this.entidad,
      entidadId: entidadId ?? this.entidadId,
      accion: accion ?? this.accion,
      valorAnteriorJson: valorAnteriorJson ?? this.valorAnteriorJson,
      valorNuevoJson: valorNuevoJson ?? this.valorNuevoJson,
      resumen: resumen ?? this.resumen,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fechaHora.present) {
      map['fecha_hora'] = Variable<DateTime>(fechaHora.value);
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    if (entidadId.present) {
      map['entidad_id'] = Variable<int>(entidadId.value);
    }
    if (accion.present) {
      map['accion'] = Variable<String>(accion.value);
    }
    if (valorAnteriorJson.present) {
      map['valor_anterior_json'] = Variable<String>(valorAnteriorJson.value);
    }
    if (valorNuevoJson.present) {
      map['valor_nuevo_json'] = Variable<String>(valorNuevoJson.value);
    }
    if (resumen.present) {
      map['resumen'] = Variable<String>(resumen.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriaCompanion(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('accion: $accion, ')
          ..write('valorAnteriorJson: $valorAnteriorJson, ')
          ..write('valorNuevoJson: $valorNuevoJson, ')
          ..write('resumen: $resumen, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $AjustesTable extends Ajustes with TableInfo<$AjustesTable, Ajuste> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AjustesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String> clave = GeneratedColumn<String>(
    'clave',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [clave, valor, actualizadoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ajustes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ajuste> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('clave')) {
      context.handle(
        _claveMeta,
        clave.isAcceptableOrUnknown(data['clave']!, _claveMeta),
      );
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clave};
  @override
  Ajuste map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ajuste(
      clave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  $AjustesTable createAlias(String alias) {
    return $AjustesTable(attachedDatabase, alias);
  }
}

class Ajuste extends DataClass implements Insertable<Ajuste> {
  final String clave;
  final String valor;
  final DateTime actualizadoEn;
  const Ajuste({
    required this.clave,
    required this.valor,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['clave'] = Variable<String>(clave);
    map['valor'] = Variable<String>(valor);
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    return map;
  }

  AjustesCompanion toCompanion(bool nullToAbsent) {
    return AjustesCompanion(
      clave: Value(clave),
      valor: Value(valor),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory Ajuste.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ajuste(
      clave: serializer.fromJson<String>(json['clave']),
      valor: serializer.fromJson<String>(json['valor']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clave': serializer.toJson<String>(clave),
      'valor': serializer.toJson<String>(valor),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
    };
  }

  Ajuste copyWith({String? clave, String? valor, DateTime? actualizadoEn}) =>
      Ajuste(
        clave: clave ?? this.clave,
        valor: valor ?? this.valor,
        actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      );
  Ajuste copyWithCompanion(AjustesCompanion data) {
    return Ajuste(
      clave: data.clave.present ? data.clave.value : this.clave,
      valor: data.valor.present ? data.valor.value : this.valor,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ajuste(')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clave, valor, actualizadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ajuste &&
          other.clave == this.clave &&
          other.valor == this.valor &&
          other.actualizadoEn == this.actualizadoEn);
}

class AjustesCompanion extends UpdateCompanion<Ajuste> {
  final Value<String> clave;
  final Value<String> valor;
  final Value<DateTime> actualizadoEn;
  final Value<int> rowid;
  const AjustesCompanion({
    this.clave = const Value.absent(),
    this.valor = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AjustesCompanion.insert({
    required String clave,
    required String valor,
    this.actualizadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clave = Value(clave),
       valor = Value(valor);
  static Insertable<Ajuste> custom({
    Expression<String>? clave,
    Expression<String>? valor,
    Expression<DateTime>? actualizadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clave != null) 'clave': clave,
      if (valor != null) 'valor': valor,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AjustesCompanion copyWith({
    Value<String>? clave,
    Value<String>? valor,
    Value<DateTime>? actualizadoEn,
    Value<int>? rowid,
  }) {
    return AjustesCompanion(
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AjustesCompanion(')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CuentasTable cuentas = $CuentasTable(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $GastosFijosTable gastosFijos = $GastosFijosTable(this);
  late final $GastosFijosPagosTable gastosFijosPagos = $GastosFijosPagosTable(
    this,
  );
  late final $IngresosFijosTable ingresosFijos = $IngresosFijosTable(this);
  late final $IngresosFijosCobrosTable ingresosFijosCobros =
      $IngresosFijosCobrosTable(this);
  late final $PresupuestosMensualesTable presupuestosMensuales =
      $PresupuestosMensualesTable(this);
  late final $ProyectosTable proyectos = $ProyectosTable(this);
  late final $PartidasProyectoTable partidasProyecto = $PartidasProyectoTable(
    this,
  );
  late final $CotizacionesTable cotizaciones = $CotizacionesTable(this);
  late final $AuditoriaTable auditoria = $AuditoriaTable(this);
  late final $AjustesTable ajustes = $AjustesTable(this);
  late final CuentasDao cuentasDao = CuentasDao(this as AppDatabase);
  late final MovimientosDao movimientosDao = MovimientosDao(
    this as AppDatabase,
  );
  late final CategoriasDao categoriasDao = CategoriasDao(this as AppDatabase);
  late final AjustesDao ajustesDao = AjustesDao(this as AppDatabase);
  late final GastosFijosDao gastosFijosDao = GastosFijosDao(
    this as AppDatabase,
  );
  late final PresupuestosDao presupuestosDao = PresupuestosDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cuentas,
    categorias,
    movimientos,
    gastosFijos,
    gastosFijosPagos,
    ingresosFijos,
    ingresosFijosCobros,
    presupuestosMensuales,
    proyectos,
    partidasProyecto,
    cotizaciones,
    auditoria,
    ajustes,
  ];
}

typedef $$CuentasTableCreateCompanionBuilder =
    CuentasCompanion Function({
      Value<int> id,
      required String nombre,
      required String tipo,
      Value<int> saldoInicialCent,
      Value<bool> activa,
      Value<String> color,
      Value<String> icono,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$CuentasTableUpdateCompanionBuilder =
    CuentasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> tipo,
      Value<int> saldoInicialCent,
      Value<bool> activa,
      Value<String> color,
      Value<String> icono,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$CuentasTableReferences
    extends BaseReferences<_$AppDatabase, $CuentasTable, Cuenta> {
  $$CuentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GastosFijosTable, List<GastosFijo>>
  _gastosFijosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gastosFijos,
    aliasName: 'cuentas__id__gastos_fijos__cuenta_pago_id',
  );

  $$GastosFijosTableProcessedTableManager get gastosFijosRefs {
    final manager = $$GastosFijosTableTableManager(
      $_db,
      $_db.gastosFijos,
    ).filter((f) => f.cuentaPagoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gastosFijosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IngresosFijosTable, List<IngresosFijo>>
  _ingresosFijosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingresosFijos,
    aliasName: 'cuentas__id__ingresos_fijos__cuenta_id',
  );

  $$IngresosFijosTableProcessedTableManager get ingresosFijosRefs {
    final manager = $$IngresosFijosTableTableManager(
      $_db,
      $_db.ingresosFijos,
    ).filter((f) => f.cuentaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingresosFijosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CuentasTableFilterComposer
    extends Composer<_$AppDatabase, $CuentasTable> {
  $$CuentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoInicialCent => $composableBuilder(
    column: $table.saldoInicialCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gastosFijosRefs(
    Expression<bool> Function($$GastosFijosTableFilterComposer f) f,
  ) {
    final $$GastosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.cuentaPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingresosFijosRefs(
    Expression<bool> Function($$IngresosFijosTableFilterComposer f) f,
  ) {
    final $$IngresosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingresosFijos,
      getReferencedColumn: (t) => t.cuentaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosTableFilterComposer(
            $db: $db,
            $table: $db.ingresosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuentasTableOrderingComposer
    extends Composer<_$AppDatabase, $CuentasTable> {
  $$CuentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoInicialCent => $composableBuilder(
    column: $table.saldoInicialCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CuentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CuentasTable> {
  $$CuentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get saldoInicialCent => $composableBuilder(
    column: $table.saldoInicialCent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activa =>
      $composableBuilder(column: $table.activa, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  Expression<T> gastosFijosRefs<T extends Object>(
    Expression<T> Function($$GastosFijosTableAnnotationComposer a) f,
  ) {
    final $$GastosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.cuentaPagoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ingresosFijosRefs<T extends Object>(
    Expression<T> Function($$IngresosFijosTableAnnotationComposer a) f,
  ) {
    final $$IngresosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingresosFijos,
      getReferencedColumn: (t) => t.cuentaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.ingresosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CuentasTable,
          Cuenta,
          $$CuentasTableFilterComposer,
          $$CuentasTableOrderingComposer,
          $$CuentasTableAnnotationComposer,
          $$CuentasTableCreateCompanionBuilder,
          $$CuentasTableUpdateCompanionBuilder,
          (Cuenta, $$CuentasTableReferences),
          Cuenta,
          PrefetchHooks Function({bool gastosFijosRefs, bool ingresosFijosRefs})
        > {
  $$CuentasTableTableManager(_$AppDatabase db, $CuentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> saldoInicialCent = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CuentasCompanion(
                id: id,
                nombre: nombre,
                tipo: tipo,
                saldoInicialCent: saldoInicialCent,
                activa: activa,
                color: color,
                icono: icono,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String tipo,
                Value<int> saldoInicialCent = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CuentasCompanion.insert(
                id: id,
                nombre: nombre,
                tipo: tipo,
                saldoInicialCent: saldoInicialCent,
                activa: activa,
                color: color,
                icono: icono,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CuentasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gastosFijosRefs = false, ingresosFijosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gastosFijosRefs) db.gastosFijos,
                    if (ingresosFijosRefs) db.ingresosFijos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gastosFijosRefs)
                        await $_getPrefetchedData<
                          Cuenta,
                          $CuentasTable,
                          GastosFijo
                        >(
                          currentTable: table,
                          referencedTable: $$CuentasTableReferences
                              ._gastosFijosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CuentasTableReferences(
                                db,
                                table,
                                p0,
                              ).gastosFijosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cuentaPagoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingresosFijosRefs)
                        await $_getPrefetchedData<
                          Cuenta,
                          $CuentasTable,
                          IngresosFijo
                        >(
                          currentTable: table,
                          referencedTable: $$CuentasTableReferences
                              ._ingresosFijosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CuentasTableReferences(
                                db,
                                table,
                                p0,
                              ).ingresosFijosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cuentaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CuentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CuentasTable,
      Cuenta,
      $$CuentasTableFilterComposer,
      $$CuentasTableOrderingComposer,
      $$CuentasTableAnnotationComposer,
      $$CuentasTableCreateCompanionBuilder,
      $$CuentasTableUpdateCompanionBuilder,
      (Cuenta, $$CuentasTableReferences),
      Cuenta,
      PrefetchHooks Function({bool gastosFijosRefs, bool ingresosFijosRefs})
    >;
typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      required String nombre,
      required String tipo,
      Value<String> icono,
      Value<String> color,
      Value<bool> esSistema,
      Value<bool> activa,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> tipo,
      Value<String> icono,
      Value<String> color,
      Value<bool> esSistema,
      Value<bool> activa,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovimientosTable, List<Movimiento>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: 'categorias__id__movimientos__categoria_id',
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GastosFijosTable, List<GastosFijo>>
  _gastosFijosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gastosFijos,
    aliasName: 'categorias__id__gastos_fijos__categoria_id',
  );

  $$GastosFijosTableProcessedTableManager get gastosFijosRefs {
    final manager = $$GastosFijosTableTableManager(
      $_db,
      $_db.gastosFijos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gastosFijosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PresupuestosMensualesTable,
    List<PresupuestosMensuale>
  >
  _presupuestosMensualesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.presupuestosMensuales,
        aliasName: 'categorias__id__presupuestos_mensuales__categoria_id',
      );

  $$PresupuestosMensualesTableProcessedTableManager
  get presupuestosMensualesRefs {
    final manager = $$PresupuestosMensualesTableTableManager(
      $_db,
      $_db.presupuestosMensuales,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _presupuestosMensualesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esSistema => $composableBuilder(
    column: $table.esSistema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gastosFijosRefs(
    Expression<bool> Function($$GastosFijosTableFilterComposer f) f,
  ) {
    final $$GastosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> presupuestosMensualesRefs(
    Expression<bool> Function($$PresupuestosMensualesTableFilterComposer f) f,
  ) {
    final $$PresupuestosMensualesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.presupuestosMensuales,
          getReferencedColumn: (t) => t.categoriaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PresupuestosMensualesTableFilterComposer(
                $db: $db,
                $table: $db.presupuestosMensuales,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esSistema => $composableBuilder(
    column: $table.esSistema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activa => $composableBuilder(
    column: $table.activa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get esSistema =>
      $composableBuilder(column: $table.esSistema, builder: (column) => column);

  GeneratedColumn<bool> get activa =>
      $composableBuilder(column: $table.activa, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gastosFijosRefs<T extends Object>(
    Expression<T> Function($$GastosFijosTableAnnotationComposer a) f,
  ) {
    final $$GastosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> presupuestosMensualesRefs<T extends Object>(
    Expression<T> Function($$PresupuestosMensualesTableAnnotationComposer a) f,
  ) {
    final $$PresupuestosMensualesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.presupuestosMensuales,
          getReferencedColumn: (t) => t.categoriaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PresupuestosMensualesTableAnnotationComposer(
                $db: $db,
                $table: $db.presupuestosMensuales,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({
            bool movimientosRefs,
            bool gastosFijosRefs,
            bool presupuestosMensualesRefs,
          })
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esSistema = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                tipo: tipo,
                icono: icono,
                color: color,
                esSistema: esSistema,
                activa: activa,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String tipo,
                Value<String> icono = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<bool> esSistema = const Value.absent(),
                Value<bool> activa = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                tipo: tipo,
                icono: icono,
                color: color,
                esSistema: esSistema,
                activa: activa,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                movimientosRefs = false,
                gastosFijosRefs = false,
                presupuestosMensualesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
                    if (gastosFijosRefs) db.gastosFijos,
                    if (presupuestosMensualesRefs) db.presupuestosMensuales,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          Movimiento
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gastosFijosRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          GastosFijo
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._gastosFijosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).gastosFijosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (presupuestosMensualesRefs)
                        await $_getPrefetchedData<
                          Categoria,
                          $CategoriasTable,
                          PresupuestosMensuale
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._presupuestosMensualesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestosMensualesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoriaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({
        bool movimientosRefs,
        bool gastosFijosRefs,
        bool presupuestosMensualesRefs,
      })
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      required DateTime fecha,
      required String tipo,
      required int montoCent,
      required int cuentaOrigenId,
      Value<int?> cuentaDestinoId,
      Value<int?> categoriaId,
      required String descripcion,
      Value<String?> notas,
      Value<int?> gastoFijoPagoId,
      Value<int?> partidaId,
      Value<bool> anulado,
      Value<DateTime?> anuladoEn,
      Value<String?> motivoAnulacion,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      Value<DateTime> fecha,
      Value<String> tipo,
      Value<int> montoCent,
      Value<int> cuentaOrigenId,
      Value<int?> cuentaDestinoId,
      Value<int?> categoriaId,
      Value<String> descripcion,
      Value<String?> notas,
      Value<int?> gastoFijoPagoId,
      Value<int?> partidaId,
      Value<bool> anulado,
      Value<DateTime?> anuladoEn,
      Value<String?> motivoAnulacion,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MovimientosTable, Movimiento> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CuentasTable _cuentaOrigenIdTable(_$AppDatabase db) =>
      db.cuentas.createAlias('movimientos__cuenta_origen_id__cuentas__id');

  $$CuentasTableProcessedTableManager get cuentaOrigenId {
    final $_column = $_itemColumn<int>('cuenta_origen_id')!;

    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaOrigenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuentasTable _cuentaDestinoIdTable(_$AppDatabase db) =>
      db.cuentas.createAlias('movimientos__cuenta_destino_id__cuentas__id');

  $$CuentasTableProcessedTableManager? get cuentaDestinoId {
    final $_column = $_itemColumn<int>('cuenta_destino_id');
    if ($_column == null) return null;
    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaDestinoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('movimientos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GastosFijosPagosTable, List<GastosFijosPago>>
  _gastosFijosPagosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gastosFijosPagos,
    aliasName: 'movimientos__id__gastos_fijos_pagos__movimiento_id',
  );

  $$GastosFijosPagosTableProcessedTableManager get gastosFijosPagosRefs {
    final manager = $$GastosFijosPagosTableTableManager(
      $_db,
      $_db.gastosFijosPagos,
    ).filter((f) => f.movimientoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gastosFijosPagosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IngresosFijosCobrosTable,
    List<IngresosFijosCobro>
  >
  _ingresosFijosCobrosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingresosFijosCobros,
        aliasName: 'movimientos__id__ingresos_fijos_cobros__movimiento_id',
      );

  $$IngresosFijosCobrosTableProcessedTableManager get ingresosFijosCobrosRefs {
    final manager = $$IngresosFijosCobrosTableTableManager(
      $_db,
      $_db.ingresosFijosCobros,
    ).filter((f) => f.movimientoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingresosFijosCobrosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gastoFijoPagoId => $composableBuilder(
    column: $table.gastoFijoPagoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get partidaId => $composableBuilder(
    column: $table.partidaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get anulado => $composableBuilder(
    column: $table.anulado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get anuladoEn => $composableBuilder(
    column: $table.anuladoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CuentasTableFilterComposer get cuentaOrigenId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableFilterComposer get cuentaDestinoId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gastosFijosPagosRefs(
    Expression<bool> Function($$GastosFijosPagosTableFilterComposer f) f,
  ) {
    final $$GastosFijosPagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijosPagos,
      getReferencedColumn: (t) => t.movimientoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosPagosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijosPagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingresosFijosCobrosRefs(
    Expression<bool> Function($$IngresosFijosCobrosTableFilterComposer f) f,
  ) {
    final $$IngresosFijosCobrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingresosFijosCobros,
      getReferencedColumn: (t) => t.movimientoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosCobrosTableFilterComposer(
            $db: $db,
            $table: $db.ingresosFijosCobros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gastoFijoPagoId => $composableBuilder(
    column: $table.gastoFijoPagoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get partidaId => $composableBuilder(
    column: $table.partidaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get anulado => $composableBuilder(
    column: $table.anulado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get anuladoEn => $composableBuilder(
    column: $table.anuladoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CuentasTableOrderingComposer get cuentaOrigenId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableOrderingComposer get cuentaDestinoId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCent =>
      $composableBuilder(column: $table.montoCent, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<int> get gastoFijoPagoId => $composableBuilder(
    column: $table.gastoFijoPagoId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get partidaId =>
      $composableBuilder(column: $table.partidaId, builder: (column) => column);

  GeneratedColumn<bool> get anulado =>
      $composableBuilder(column: $table.anulado, builder: (column) => column);

  GeneratedColumn<DateTime> get anuladoEn =>
      $composableBuilder(column: $table.anuladoEn, builder: (column) => column);

  GeneratedColumn<String> get motivoAnulacion => $composableBuilder(
    column: $table.motivoAnulacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$CuentasTableAnnotationComposer get cuentaOrigenId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaOrigenId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableAnnotationComposer get cuentaDestinoId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaDestinoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gastosFijosPagosRefs<T extends Object>(
    Expression<T> Function($$GastosFijosPagosTableAnnotationComposer a) f,
  ) {
    final $$GastosFijosPagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijosPagos,
      getReferencedColumn: (t) => t.movimientoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosPagosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijosPagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ingresosFijosCobrosRefs<T extends Object>(
    Expression<T> Function($$IngresosFijosCobrosTableAnnotationComposer a) f,
  ) {
    final $$IngresosFijosCobrosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingresosFijosCobros,
          getReferencedColumn: (t) => t.movimientoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngresosFijosCobrosTableAnnotationComposer(
                $db: $db,
                $table: $db.ingresosFijosCobros,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTable,
          Movimiento,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (Movimiento, $$MovimientosTableReferences),
          Movimiento,
          PrefetchHooks Function({
            bool cuentaOrigenId,
            bool cuentaDestinoId,
            bool categoriaId,
            bool gastosFijosPagosRefs,
            bool ingresosFijosCobrosRefs,
          })
        > {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> montoCent = const Value.absent(),
                Value<int> cuentaOrigenId = const Value.absent(),
                Value<int?> cuentaDestinoId = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<int?> gastoFijoPagoId = const Value.absent(),
                Value<int?> partidaId = const Value.absent(),
                Value<bool> anulado = const Value.absent(),
                Value<DateTime?> anuladoEn = const Value.absent(),
                Value<String?> motivoAnulacion = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                fecha: fecha,
                tipo: tipo,
                montoCent: montoCent,
                cuentaOrigenId: cuentaOrigenId,
                cuentaDestinoId: cuentaDestinoId,
                categoriaId: categoriaId,
                descripcion: descripcion,
                notas: notas,
                gastoFijoPagoId: gastoFijoPagoId,
                partidaId: partidaId,
                anulado: anulado,
                anuladoEn: anuladoEn,
                motivoAnulacion: motivoAnulacion,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime fecha,
                required String tipo,
                required int montoCent,
                required int cuentaOrigenId,
                Value<int?> cuentaDestinoId = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                required String descripcion,
                Value<String?> notas = const Value.absent(),
                Value<int?> gastoFijoPagoId = const Value.absent(),
                Value<int?> partidaId = const Value.absent(),
                Value<bool> anulado = const Value.absent(),
                Value<DateTime?> anuladoEn = const Value.absent(),
                Value<String?> motivoAnulacion = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => MovimientosCompanion.insert(
                id: id,
                fecha: fecha,
                tipo: tipo,
                montoCent: montoCent,
                cuentaOrigenId: cuentaOrigenId,
                cuentaDestinoId: cuentaDestinoId,
                categoriaId: categoriaId,
                descripcion: descripcion,
                notas: notas,
                gastoFijoPagoId: gastoFijoPagoId,
                partidaId: partidaId,
                anulado: anulado,
                anuladoEn: anuladoEn,
                motivoAnulacion: motivoAnulacion,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cuentaOrigenId = false,
                cuentaDestinoId = false,
                categoriaId = false,
                gastosFijosPagosRefs = false,
                ingresosFijosCobrosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gastosFijosPagosRefs) db.gastosFijosPagos,
                    if (ingresosFijosCobrosRefs) db.ingresosFijosCobros,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cuentaOrigenId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cuentaOrigenId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._cuentaOrigenIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._cuentaOrigenIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (cuentaDestinoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cuentaDestinoId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._cuentaDestinoIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._cuentaDestinoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$MovimientosTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$MovimientosTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gastosFijosPagosRefs)
                        await $_getPrefetchedData<
                          Movimiento,
                          $MovimientosTable,
                          GastosFijosPago
                        >(
                          currentTable: table,
                          referencedTable: $$MovimientosTableReferences
                              ._gastosFijosPagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MovimientosTableReferences(
                                db,
                                table,
                                p0,
                              ).gastosFijosPagosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movimientoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingresosFijosCobrosRefs)
                        await $_getPrefetchedData<
                          Movimiento,
                          $MovimientosTable,
                          IngresosFijosCobro
                        >(
                          currentTable: table,
                          referencedTable: $$MovimientosTableReferences
                              ._ingresosFijosCobrosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MovimientosTableReferences(
                                db,
                                table,
                                p0,
                              ).ingresosFijosCobrosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movimientoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTable,
      Movimiento,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (Movimiento, $$MovimientosTableReferences),
      Movimiento,
      PrefetchHooks Function({
        bool cuentaOrigenId,
        bool cuentaDestinoId,
        bool categoriaId,
        bool gastosFijosPagosRefs,
        bool ingresosFijosCobrosRefs,
      })
    >;
typedef $$GastosFijosTableCreateCompanionBuilder =
    GastosFijosCompanion Function({
      Value<int> id,
      required String nombre,
      required int montoEstimadoCent,
      required int categoriaId,
      required int cuentaPagoId,
      required int diaVencimiento,
      Value<String> frecuencia,
      required DateTime fechaInicio,
      Value<DateTime?> fechaFin,
      Value<bool> activo,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$GastosFijosTableUpdateCompanionBuilder =
    GastosFijosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> montoEstimadoCent,
      Value<int> categoriaId,
      Value<int> cuentaPagoId,
      Value<int> diaVencimiento,
      Value<String> frecuencia,
      Value<DateTime> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<bool> activo,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$GastosFijosTableReferences
    extends BaseReferences<_$AppDatabase, $GastosFijosTable, GastosFijo> {
  $$GastosFijosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('gastos_fijos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuentasTable _cuentaPagoIdTable(_$AppDatabase db) =>
      db.cuentas.createAlias('gastos_fijos__cuenta_pago_id__cuentas__id');

  $$CuentasTableProcessedTableManager get cuentaPagoId {
    final $_column = $_itemColumn<int>('cuenta_pago_id')!;

    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaPagoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GastosFijosPagosTable, List<GastosFijosPago>>
  _gastosFijosPagosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gastosFijosPagos,
    aliasName: 'gastos_fijos__id__gastos_fijos_pagos__gasto_fijo_id',
  );

  $$GastosFijosPagosTableProcessedTableManager get gastosFijosPagosRefs {
    final manager = $$GastosFijosPagosTableTableManager(
      $_db,
      $_db.gastosFijosPagos,
    ).filter((f) => f.gastoFijoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gastosFijosPagosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GastosFijosTableFilterComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaVencimiento => $composableBuilder(
    column: $table.diaVencimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableFilterComposer get cuentaPagoId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaPagoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gastosFijosPagosRefs(
    Expression<bool> Function($$GastosFijosPagosTableFilterComposer f) f,
  ) {
    final $$GastosFijosPagosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijosPagos,
      getReferencedColumn: (t) => t.gastoFijoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosPagosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijosPagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GastosFijosTableOrderingComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaVencimiento => $composableBuilder(
    column: $table.diaVencimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableOrderingComposer get cuentaPagoId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaPagoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GastosFijosTable> {
  $$GastosFijosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaVencimiento => $composableBuilder(
    column: $table.diaVencimiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuentasTableAnnotationComposer get cuentaPagoId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaPagoId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gastosFijosPagosRefs<T extends Object>(
    Expression<T> Function($$GastosFijosPagosTableAnnotationComposer a) f,
  ) {
    final $$GastosFijosPagosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gastosFijosPagos,
      getReferencedColumn: (t) => t.gastoFijoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosPagosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijosPagos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GastosFijosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GastosFijosTable,
          GastosFijo,
          $$GastosFijosTableFilterComposer,
          $$GastosFijosTableOrderingComposer,
          $$GastosFijosTableAnnotationComposer,
          $$GastosFijosTableCreateCompanionBuilder,
          $$GastosFijosTableUpdateCompanionBuilder,
          (GastosFijo, $$GastosFijosTableReferences),
          GastosFijo,
          PrefetchHooks Function({
            bool categoriaId,
            bool cuentaPagoId,
            bool gastosFijosPagosRefs,
          })
        > {
  $$GastosFijosTableTableManager(_$AppDatabase db, $GastosFijosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastosFijosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastosFijosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastosFijosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> montoEstimadoCent = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<int> cuentaPagoId = const Value.absent(),
                Value<int> diaVencimiento = const Value.absent(),
                Value<String> frecuencia = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => GastosFijosCompanion(
                id: id,
                nombre: nombre,
                montoEstimadoCent: montoEstimadoCent,
                categoriaId: categoriaId,
                cuentaPagoId: cuentaPagoId,
                diaVencimiento: diaVencimiento,
                frecuencia: frecuencia,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required int montoEstimadoCent,
                required int categoriaId,
                required int cuentaPagoId,
                required int diaVencimiento,
                Value<String> frecuencia = const Value.absent(),
                required DateTime fechaInicio,
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => GastosFijosCompanion.insert(
                id: id,
                nombre: nombre,
                montoEstimadoCent: montoEstimadoCent,
                categoriaId: categoriaId,
                cuentaPagoId: cuentaPagoId,
                diaVencimiento: diaVencimiento,
                frecuencia: frecuencia,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GastosFijosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoriaId = false,
                cuentaPagoId = false,
                gastosFijosPagosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gastosFijosPagosRefs) db.gastosFijosPagos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$GastosFijosTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$GastosFijosTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (cuentaPagoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cuentaPagoId,
                                    referencedTable:
                                        $$GastosFijosTableReferences
                                            ._cuentaPagoIdTable(db),
                                    referencedColumn:
                                        $$GastosFijosTableReferences
                                            ._cuentaPagoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gastosFijosPagosRefs)
                        await $_getPrefetchedData<
                          GastosFijo,
                          $GastosFijosTable,
                          GastosFijosPago
                        >(
                          currentTable: table,
                          referencedTable: $$GastosFijosTableReferences
                              ._gastosFijosPagosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GastosFijosTableReferences(
                                db,
                                table,
                                p0,
                              ).gastosFijosPagosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gastoFijoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GastosFijosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GastosFijosTable,
      GastosFijo,
      $$GastosFijosTableFilterComposer,
      $$GastosFijosTableOrderingComposer,
      $$GastosFijosTableAnnotationComposer,
      $$GastosFijosTableCreateCompanionBuilder,
      $$GastosFijosTableUpdateCompanionBuilder,
      (GastosFijo, $$GastosFijosTableReferences),
      GastosFijo,
      PrefetchHooks Function({
        bool categoriaId,
        bool cuentaPagoId,
        bool gastosFijosPagosRefs,
      })
    >;
typedef $$GastosFijosPagosTableCreateCompanionBuilder =
    GastosFijosPagosCompanion Function({
      Value<int> id,
      required int gastoFijoId,
      required String periodo,
      required int montoEsperadoCent,
      Value<String> estado,
      Value<int?> movimientoId,
      required DateTime fechaVencimiento,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$GastosFijosPagosTableUpdateCompanionBuilder =
    GastosFijosPagosCompanion Function({
      Value<int> id,
      Value<int> gastoFijoId,
      Value<String> periodo,
      Value<int> montoEsperadoCent,
      Value<String> estado,
      Value<int?> movimientoId,
      Value<DateTime> fechaVencimiento,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$GastosFijosPagosTableReferences
    extends
        BaseReferences<_$AppDatabase, $GastosFijosPagosTable, GastosFijosPago> {
  $$GastosFijosPagosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GastosFijosTable _gastoFijoIdTable(_$AppDatabase db) => db.gastosFijos
      .createAlias('gastos_fijos_pagos__gasto_fijo_id__gastos_fijos__id');

  $$GastosFijosTableProcessedTableManager get gastoFijoId {
    final $_column = $_itemColumn<int>('gasto_fijo_id')!;

    final manager = $$GastosFijosTableTableManager(
      $_db,
      $_db.gastosFijos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gastoFijoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MovimientosTable _movimientoIdTable(_$AppDatabase db) => db
      .movimientos
      .createAlias('gastos_fijos_pagos__movimiento_id__movimientos__id');

  $$MovimientosTableProcessedTableManager? get movimientoId {
    final $_column = $_itemColumn<int>('movimiento_id');
    if ($_column == null) return null;
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movimientoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GastosFijosPagosTableFilterComposer
    extends Composer<_$AppDatabase, $GastosFijosPagosTable> {
  $$GastosFijosPagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$GastosFijosTableFilterComposer get gastoFijoId {
    final $$GastosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gastoFijoId,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableFilterComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableFilterComposer get movimientoId {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosPagosTableOrderingComposer
    extends Composer<_$AppDatabase, $GastosFijosPagosTable> {
  $$GastosFijosPagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$GastosFijosTableOrderingComposer get gastoFijoId {
    final $$GastosFijosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gastoFijoId,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableOrderingComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableOrderingComposer get movimientoId {
    final $$MovimientosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableOrderingComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosPagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GastosFijosPagosTable> {
  $$GastosFijosPagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaVencimiento => $composableBuilder(
    column: $table.fechaVencimiento,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$GastosFijosTableAnnotationComposer get gastoFijoId {
    final $$GastosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gastoFijoId,
      referencedTable: $db.gastosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GastosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.gastosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableAnnotationComposer get movimientoId {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GastosFijosPagosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GastosFijosPagosTable,
          GastosFijosPago,
          $$GastosFijosPagosTableFilterComposer,
          $$GastosFijosPagosTableOrderingComposer,
          $$GastosFijosPagosTableAnnotationComposer,
          $$GastosFijosPagosTableCreateCompanionBuilder,
          $$GastosFijosPagosTableUpdateCompanionBuilder,
          (GastosFijosPago, $$GastosFijosPagosTableReferences),
          GastosFijosPago,
          PrefetchHooks Function({bool gastoFijoId, bool movimientoId})
        > {
  $$GastosFijosPagosTableTableManager(
    _$AppDatabase db,
    $GastosFijosPagosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastosFijosPagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastosFijosPagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastosFijosPagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gastoFijoId = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<int> montoEsperadoCent = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
                Value<DateTime> fechaVencimiento = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => GastosFijosPagosCompanion(
                id: id,
                gastoFijoId: gastoFijoId,
                periodo: periodo,
                montoEsperadoCent: montoEsperadoCent,
                estado: estado,
                movimientoId: movimientoId,
                fechaVencimiento: fechaVencimiento,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gastoFijoId,
                required String periodo,
                required int montoEsperadoCent,
                Value<String> estado = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
                required DateTime fechaVencimiento,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => GastosFijosPagosCompanion.insert(
                id: id,
                gastoFijoId: gastoFijoId,
                periodo: periodo,
                montoEsperadoCent: montoEsperadoCent,
                estado: estado,
                movimientoId: movimientoId,
                fechaVencimiento: fechaVencimiento,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GastosFijosPagosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gastoFijoId = false, movimientoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gastoFijoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gastoFijoId,
                                referencedTable:
                                    $$GastosFijosPagosTableReferences
                                        ._gastoFijoIdTable(db),
                                referencedColumn:
                                    $$GastosFijosPagosTableReferences
                                        ._gastoFijoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (movimientoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.movimientoId,
                                referencedTable:
                                    $$GastosFijosPagosTableReferences
                                        ._movimientoIdTable(db),
                                referencedColumn:
                                    $$GastosFijosPagosTableReferences
                                        ._movimientoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GastosFijosPagosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GastosFijosPagosTable,
      GastosFijosPago,
      $$GastosFijosPagosTableFilterComposer,
      $$GastosFijosPagosTableOrderingComposer,
      $$GastosFijosPagosTableAnnotationComposer,
      $$GastosFijosPagosTableCreateCompanionBuilder,
      $$GastosFijosPagosTableUpdateCompanionBuilder,
      (GastosFijosPago, $$GastosFijosPagosTableReferences),
      GastosFijosPago,
      PrefetchHooks Function({bool gastoFijoId, bool movimientoId})
    >;
typedef $$IngresosFijosTableCreateCompanionBuilder =
    IngresosFijosCompanion Function({
      Value<int> id,
      required String nombre,
      required int montoEstimadoCent,
      required int cuentaId,
      required int diaCobro,
      Value<String> frecuencia,
      Value<bool> activo,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$IngresosFijosTableUpdateCompanionBuilder =
    IngresosFijosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<int> montoEstimadoCent,
      Value<int> cuentaId,
      Value<int> diaCobro,
      Value<String> frecuencia,
      Value<bool> activo,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$IngresosFijosTableReferences
    extends BaseReferences<_$AppDatabase, $IngresosFijosTable, IngresosFijo> {
  $$IngresosFijosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CuentasTable _cuentaIdTable(_$AppDatabase db) =>
      db.cuentas.createAlias('ingresos_fijos__cuenta_id__cuentas__id');

  $$CuentasTableProcessedTableManager get cuentaId {
    final $_column = $_itemColumn<int>('cuenta_id')!;

    final manager = $$CuentasTableTableManager(
      $_db,
      $_db.cuentas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cuentaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $IngresosFijosCobrosTable,
    List<IngresosFijosCobro>
  >
  _ingresosFijosCobrosRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingresosFijosCobros,
        aliasName: 'ingresos_fijos__id__ingresos_fijos_cobros__ingreso_fijo_id',
      );

  $$IngresosFijosCobrosTableProcessedTableManager get ingresosFijosCobrosRefs {
    final manager = $$IngresosFijosCobrosTableTableManager(
      $_db,
      $_db.ingresosFijosCobros,
    ).filter((f) => f.ingresoFijoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingresosFijosCobrosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngresosFijosTableFilterComposer
    extends Composer<_$AppDatabase, $IngresosFijosTable> {
  $$IngresosFijosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diaCobro => $composableBuilder(
    column: $table.diaCobro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CuentasTableFilterComposer get cuentaId {
    final $$CuentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableFilterComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingresosFijosCobrosRefs(
    Expression<bool> Function($$IngresosFijosCobrosTableFilterComposer f) f,
  ) {
    final $$IngresosFijosCobrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingresosFijosCobros,
      getReferencedColumn: (t) => t.ingresoFijoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosCobrosTableFilterComposer(
            $db: $db,
            $table: $db.ingresosFijosCobros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngresosFijosTableOrderingComposer
    extends Composer<_$AppDatabase, $IngresosFijosTable> {
  $$IngresosFijosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diaCobro => $composableBuilder(
    column: $table.diaCobro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CuentasTableOrderingComposer get cuentaId {
    final $$CuentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableOrderingComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosFijosTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngresosFijosTable> {
  $$IngresosFijosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get montoEstimadoCent => $composableBuilder(
    column: $table.montoEstimadoCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diaCobro =>
      $composableBuilder(column: $table.diaCobro, builder: (column) => column);

  GeneratedColumn<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$CuentasTableAnnotationComposer get cuentaId {
    final $$CuentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cuentaId,
      referencedTable: $db.cuentas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuentasTableAnnotationComposer(
            $db: $db,
            $table: $db.cuentas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ingresosFijosCobrosRefs<T extends Object>(
    Expression<T> Function($$IngresosFijosCobrosTableAnnotationComposer a) f,
  ) {
    final $$IngresosFijosCobrosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingresosFijosCobros,
          getReferencedColumn: (t) => t.ingresoFijoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngresosFijosCobrosTableAnnotationComposer(
                $db: $db,
                $table: $db.ingresosFijosCobros,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IngresosFijosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngresosFijosTable,
          IngresosFijo,
          $$IngresosFijosTableFilterComposer,
          $$IngresosFijosTableOrderingComposer,
          $$IngresosFijosTableAnnotationComposer,
          $$IngresosFijosTableCreateCompanionBuilder,
          $$IngresosFijosTableUpdateCompanionBuilder,
          (IngresosFijo, $$IngresosFijosTableReferences),
          IngresosFijo,
          PrefetchHooks Function({bool cuentaId, bool ingresosFijosCobrosRefs})
        > {
  $$IngresosFijosTableTableManager(_$AppDatabase db, $IngresosFijosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngresosFijosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngresosFijosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngresosFijosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> montoEstimadoCent = const Value.absent(),
                Value<int> cuentaId = const Value.absent(),
                Value<int> diaCobro = const Value.absent(),
                Value<String> frecuencia = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => IngresosFijosCompanion(
                id: id,
                nombre: nombre,
                montoEstimadoCent: montoEstimadoCent,
                cuentaId: cuentaId,
                diaCobro: diaCobro,
                frecuencia: frecuencia,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required int montoEstimadoCent,
                required int cuentaId,
                required int diaCobro,
                Value<String> frecuencia = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => IngresosFijosCompanion.insert(
                id: id,
                nombre: nombre,
                montoEstimadoCent: montoEstimadoCent,
                cuentaId: cuentaId,
                diaCobro: diaCobro,
                frecuencia: frecuencia,
                activo: activo,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngresosFijosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cuentaId = false, ingresosFijosCobrosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingresosFijosCobrosRefs) db.ingresosFijosCobros,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cuentaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cuentaId,
                                    referencedTable:
                                        $$IngresosFijosTableReferences
                                            ._cuentaIdTable(db),
                                    referencedColumn:
                                        $$IngresosFijosTableReferences
                                            ._cuentaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingresosFijosCobrosRefs)
                        await $_getPrefetchedData<
                          IngresosFijo,
                          $IngresosFijosTable,
                          IngresosFijosCobro
                        >(
                          currentTable: table,
                          referencedTable: $$IngresosFijosTableReferences
                              ._ingresosFijosCobrosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngresosFijosTableReferences(
                                db,
                                table,
                                p0,
                              ).ingresosFijosCobrosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingresoFijoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngresosFijosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngresosFijosTable,
      IngresosFijo,
      $$IngresosFijosTableFilterComposer,
      $$IngresosFijosTableOrderingComposer,
      $$IngresosFijosTableAnnotationComposer,
      $$IngresosFijosTableCreateCompanionBuilder,
      $$IngresosFijosTableUpdateCompanionBuilder,
      (IngresosFijo, $$IngresosFijosTableReferences),
      IngresosFijo,
      PrefetchHooks Function({bool cuentaId, bool ingresosFijosCobrosRefs})
    >;
typedef $$IngresosFijosCobrosTableCreateCompanionBuilder =
    IngresosFijosCobrosCompanion Function({
      Value<int> id,
      required int ingresoFijoId,
      required String periodo,
      required int montoEsperadoCent,
      Value<String> estado,
      Value<int?> movimientoId,
      required DateTime fechaCobroEsperada,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$IngresosFijosCobrosTableUpdateCompanionBuilder =
    IngresosFijosCobrosCompanion Function({
      Value<int> id,
      Value<int> ingresoFijoId,
      Value<String> periodo,
      Value<int> montoEsperadoCent,
      Value<String> estado,
      Value<int?> movimientoId,
      Value<DateTime> fechaCobroEsperada,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$IngresosFijosCobrosTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngresosFijosCobrosTable,
          IngresosFijosCobro
        > {
  $$IngresosFijosCobrosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngresosFijosTable _ingresoFijoIdTable(_$AppDatabase db) =>
      db.ingresosFijos.createAlias(
        'ingresos_fijos_cobros__ingreso_fijo_id__ingresos_fijos__id',
      );

  $$IngresosFijosTableProcessedTableManager get ingresoFijoId {
    final $_column = $_itemColumn<int>('ingreso_fijo_id')!;

    final manager = $$IngresosFijosTableTableManager(
      $_db,
      $_db.ingresosFijos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingresoFijoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MovimientosTable _movimientoIdTable(_$AppDatabase db) => db
      .movimientos
      .createAlias('ingresos_fijos_cobros__movimiento_id__movimientos__id');

  $$MovimientosTableProcessedTableManager? get movimientoId {
    final $_column = $_itemColumn<int>('movimiento_id');
    if ($_column == null) return null;
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movimientoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngresosFijosCobrosTableFilterComposer
    extends Composer<_$AppDatabase, $IngresosFijosCobrosTable> {
  $$IngresosFijosCobrosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCobroEsperada => $composableBuilder(
    column: $table.fechaCobroEsperada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$IngresosFijosTableFilterComposer get ingresoFijoId {
    final $$IngresosFijosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingresoFijoId,
      referencedTable: $db.ingresosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosTableFilterComposer(
            $db: $db,
            $table: $db.ingresosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableFilterComposer get movimientoId {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosFijosCobrosTableOrderingComposer
    extends Composer<_$AppDatabase, $IngresosFijosCobrosTable> {
  $$IngresosFijosCobrosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCobroEsperada => $composableBuilder(
    column: $table.fechaCobroEsperada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngresosFijosTableOrderingComposer get ingresoFijoId {
    final $$IngresosFijosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingresoFijoId,
      referencedTable: $db.ingresosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosTableOrderingComposer(
            $db: $db,
            $table: $db.ingresosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableOrderingComposer get movimientoId {
    final $$MovimientosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableOrderingComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosFijosCobrosTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngresosFijosCobrosTable> {
  $$IngresosFijosCobrosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<int> get montoEsperadoCent => $composableBuilder(
    column: $table.montoEsperadoCent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCobroEsperada => $composableBuilder(
    column: $table.fechaCobroEsperada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$IngresosFijosTableAnnotationComposer get ingresoFijoId {
    final $$IngresosFijosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingresoFijoId,
      referencedTable: $db.ingresosFijos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosFijosTableAnnotationComposer(
            $db: $db,
            $table: $db.ingresosFijos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableAnnotationComposer get movimientoId {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosFijosCobrosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngresosFijosCobrosTable,
          IngresosFijosCobro,
          $$IngresosFijosCobrosTableFilterComposer,
          $$IngresosFijosCobrosTableOrderingComposer,
          $$IngresosFijosCobrosTableAnnotationComposer,
          $$IngresosFijosCobrosTableCreateCompanionBuilder,
          $$IngresosFijosCobrosTableUpdateCompanionBuilder,
          (IngresosFijosCobro, $$IngresosFijosCobrosTableReferences),
          IngresosFijosCobro,
          PrefetchHooks Function({bool ingresoFijoId, bool movimientoId})
        > {
  $$IngresosFijosCobrosTableTableManager(
    _$AppDatabase db,
    $IngresosFijosCobrosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngresosFijosCobrosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngresosFijosCobrosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngresosFijosCobrosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ingresoFijoId = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<int> montoEsperadoCent = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
                Value<DateTime> fechaCobroEsperada = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => IngresosFijosCobrosCompanion(
                id: id,
                ingresoFijoId: ingresoFijoId,
                periodo: periodo,
                montoEsperadoCent: montoEsperadoCent,
                estado: estado,
                movimientoId: movimientoId,
                fechaCobroEsperada: fechaCobroEsperada,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ingresoFijoId,
                required String periodo,
                required int montoEsperadoCent,
                Value<String> estado = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
                required DateTime fechaCobroEsperada,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => IngresosFijosCobrosCompanion.insert(
                id: id,
                ingresoFijoId: ingresoFijoId,
                periodo: periodo,
                montoEsperadoCent: montoEsperadoCent,
                estado: estado,
                movimientoId: movimientoId,
                fechaCobroEsperada: fechaCobroEsperada,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngresosFijosCobrosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ingresoFijoId = false, movimientoId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ingresoFijoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingresoFijoId,
                                    referencedTable:
                                        $$IngresosFijosCobrosTableReferences
                                            ._ingresoFijoIdTable(db),
                                    referencedColumn:
                                        $$IngresosFijosCobrosTableReferences
                                            ._ingresoFijoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (movimientoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.movimientoId,
                                    referencedTable:
                                        $$IngresosFijosCobrosTableReferences
                                            ._movimientoIdTable(db),
                                    referencedColumn:
                                        $$IngresosFijosCobrosTableReferences
                                            ._movimientoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$IngresosFijosCobrosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngresosFijosCobrosTable,
      IngresosFijosCobro,
      $$IngresosFijosCobrosTableFilterComposer,
      $$IngresosFijosCobrosTableOrderingComposer,
      $$IngresosFijosCobrosTableAnnotationComposer,
      $$IngresosFijosCobrosTableCreateCompanionBuilder,
      $$IngresosFijosCobrosTableUpdateCompanionBuilder,
      (IngresosFijosCobro, $$IngresosFijosCobrosTableReferences),
      IngresosFijosCobro,
      PrefetchHooks Function({bool ingresoFijoId, bool movimientoId})
    >;
typedef $$PresupuestosMensualesTableCreateCompanionBuilder =
    PresupuestosMensualesCompanion Function({
      Value<int> id,
      required String periodo,
      required int categoriaId,
      required int montoCent,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$PresupuestosMensualesTableUpdateCompanionBuilder =
    PresupuestosMensualesCompanion Function({
      Value<int> id,
      Value<String> periodo,
      Value<int> categoriaId,
      Value<int> montoCent,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$PresupuestosMensualesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PresupuestosMensualesTable,
          PresupuestosMensuale
        > {
  $$PresupuestosMensualesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) => db.categorias
      .createAlias('presupuestos_mensuales__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PresupuestosMensualesTableFilterComposer
    extends Composer<_$AppDatabase, $PresupuestosMensualesTable> {
  $$PresupuestosMensualesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosMensualesTableOrderingComposer
    extends Composer<_$AppDatabase, $PresupuestosMensualesTable> {
  $$PresupuestosMensualesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosMensualesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresupuestosMensualesTable> {
  $$PresupuestosMensualesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<int> get montoCent =>
      $composableBuilder(column: $table.montoCent, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosMensualesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresupuestosMensualesTable,
          PresupuestosMensuale,
          $$PresupuestosMensualesTableFilterComposer,
          $$PresupuestosMensualesTableOrderingComposer,
          $$PresupuestosMensualesTableAnnotationComposer,
          $$PresupuestosMensualesTableCreateCompanionBuilder,
          $$PresupuestosMensualesTableUpdateCompanionBuilder,
          (PresupuestosMensuale, $$PresupuestosMensualesTableReferences),
          PresupuestosMensuale,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$PresupuestosMensualesTableTableManager(
    _$AppDatabase db,
    $PresupuestosMensualesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestosMensualesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PresupuestosMensualesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PresupuestosMensualesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<int> montoCent = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => PresupuestosMensualesCompanion(
                id: id,
                periodo: periodo,
                categoriaId: categoriaId,
                montoCent: montoCent,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String periodo,
                required int categoriaId,
                required int montoCent,
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => PresupuestosMensualesCompanion.insert(
                id: id,
                periodo: periodo,
                categoriaId: categoriaId,
                montoCent: montoCent,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PresupuestosMensualesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable:
                                    $$PresupuestosMensualesTableReferences
                                        ._categoriaIdTable(db),
                                referencedColumn:
                                    $$PresupuestosMensualesTableReferences
                                        ._categoriaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PresupuestosMensualesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresupuestosMensualesTable,
      PresupuestosMensuale,
      $$PresupuestosMensualesTableFilterComposer,
      $$PresupuestosMensualesTableOrderingComposer,
      $$PresupuestosMensualesTableAnnotationComposer,
      $$PresupuestosMensualesTableCreateCompanionBuilder,
      $$PresupuestosMensualesTableUpdateCompanionBuilder,
      (PresupuestosMensuale, $$PresupuestosMensualesTableReferences),
      PresupuestosMensuale,
      PrefetchHooks Function({bool categoriaId})
    >;
typedef $$ProyectosTableCreateCompanionBuilder =
    ProyectosCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> descripcion,
      required String tipo,
      Value<String> estado,
      required int presupuestoObjetivoCent,
      Value<DateTime?> fechaInicioEstimada,
      Value<DateTime?> fechaFinEstimada,
      Value<String> prioridad,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$ProyectosTableUpdateCompanionBuilder =
    ProyectosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String> tipo,
      Value<String> estado,
      Value<int> presupuestoObjetivoCent,
      Value<DateTime?> fechaInicioEstimada,
      Value<DateTime?> fechaFinEstimada,
      Value<String> prioridad,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$ProyectosTableReferences
    extends BaseReferences<_$AppDatabase, $ProyectosTable, Proyecto> {
  $$ProyectosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartidasProyectoTable, List<PartidasProyectoData>>
  _partidasProyectoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partidasProyecto,
    aliasName: 'proyectos__id__partidas_proyecto__proyecto_id',
  );

  $$PartidasProyectoTableProcessedTableManager get partidasProyectoRefs {
    final manager = $$PartidasProyectoTableTableManager(
      $_db,
      $_db.partidasProyecto,
    ).filter((f) => f.proyectoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _partidasProyectoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProyectosTableFilterComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get presupuestoObjetivoCent => $composableBuilder(
    column: $table.presupuestoObjetivoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicioEstimada => $composableBuilder(
    column: $table.fechaInicioEstimada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFinEstimada => $composableBuilder(
    column: $table.fechaFinEstimada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> partidasProyectoRefs(
    Expression<bool> Function($$PartidasProyectoTableFilterComposer f) f,
  ) {
    final $$PartidasProyectoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partidasProyecto,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartidasProyectoTableFilterComposer(
            $db: $db,
            $table: $db.partidasProyecto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get presupuestoObjetivoCent => $composableBuilder(
    column: $table.presupuestoObjetivoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicioEstimada => $composableBuilder(
    column: $table.fechaInicioEstimada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFinEstimada => $composableBuilder(
    column: $table.fechaFinEstimada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProyectosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProyectosTable> {
  $$ProyectosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get presupuestoObjetivoCent => $composableBuilder(
    column: $table.presupuestoObjetivoCent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicioEstimada => $composableBuilder(
    column: $table.fechaInicioEstimada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFinEstimada => $composableBuilder(
    column: $table.fechaFinEstimada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  Expression<T> partidasProyectoRefs<T extends Object>(
    Expression<T> Function($$PartidasProyectoTableAnnotationComposer a) f,
  ) {
    final $$PartidasProyectoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partidasProyecto,
      getReferencedColumn: (t) => t.proyectoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartidasProyectoTableAnnotationComposer(
            $db: $db,
            $table: $db.partidasProyecto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProyectosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProyectosTable,
          Proyecto,
          $$ProyectosTableFilterComposer,
          $$ProyectosTableOrderingComposer,
          $$ProyectosTableAnnotationComposer,
          $$ProyectosTableCreateCompanionBuilder,
          $$ProyectosTableUpdateCompanionBuilder,
          (Proyecto, $$ProyectosTableReferences),
          Proyecto,
          PrefetchHooks Function({bool partidasProyectoRefs})
        > {
  $$ProyectosTableTableManager(_$AppDatabase db, $ProyectosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProyectosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProyectosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProyectosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int> presupuestoObjetivoCent = const Value.absent(),
                Value<DateTime?> fechaInicioEstimada = const Value.absent(),
                Value<DateTime?> fechaFinEstimada = const Value.absent(),
                Value<String> prioridad = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => ProyectosCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                tipo: tipo,
                estado: estado,
                presupuestoObjetivoCent: presupuestoObjetivoCent,
                fechaInicioEstimada: fechaInicioEstimada,
                fechaFinEstimada: fechaFinEstimada,
                prioridad: prioridad,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required String tipo,
                Value<String> estado = const Value.absent(),
                required int presupuestoObjetivoCent,
                Value<DateTime?> fechaInicioEstimada = const Value.absent(),
                Value<DateTime?> fechaFinEstimada = const Value.absent(),
                Value<String> prioridad = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => ProyectosCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                tipo: tipo,
                estado: estado,
                presupuestoObjetivoCent: presupuestoObjetivoCent,
                fechaInicioEstimada: fechaInicioEstimada,
                fechaFinEstimada: fechaFinEstimada,
                prioridad: prioridad,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProyectosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partidasProyectoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (partidasProyectoRefs) db.partidasProyecto,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partidasProyectoRefs)
                    await $_getPrefetchedData<
                      Proyecto,
                      $ProyectosTable,
                      PartidasProyectoData
                    >(
                      currentTable: table,
                      referencedTable: $$ProyectosTableReferences
                          ._partidasProyectoRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProyectosTableReferences(
                            db,
                            table,
                            p0,
                          ).partidasProyectoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.proyectoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProyectosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProyectosTable,
      Proyecto,
      $$ProyectosTableFilterComposer,
      $$ProyectosTableOrderingComposer,
      $$ProyectosTableAnnotationComposer,
      $$ProyectosTableCreateCompanionBuilder,
      $$ProyectosTableUpdateCompanionBuilder,
      (Proyecto, $$ProyectosTableReferences),
      Proyecto,
      PrefetchHooks Function({bool partidasProyectoRefs})
    >;
typedef $$PartidasProyectoTableCreateCompanionBuilder =
    PartidasProyectoCompanion Function({
      Value<int> id,
      required int proyectoId,
      required String nombre,
      Value<String?> descripcion,
      required int presupuestoCent,
      Value<int?> cotizacionElegidaId,
      Value<String> estado,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$PartidasProyectoTableUpdateCompanionBuilder =
    PartidasProyectoCompanion Function({
      Value<int> id,
      Value<int> proyectoId,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<int> presupuestoCent,
      Value<int?> cotizacionElegidaId,
      Value<String> estado,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$PartidasProyectoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PartidasProyectoTable,
          PartidasProyectoData
        > {
  $$PartidasProyectoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProyectosTable _proyectoIdTable(_$AppDatabase db) =>
      db.proyectos.createAlias('partidas_proyecto__proyecto_id__proyectos__id');

  $$ProyectosTableProcessedTableManager get proyectoId {
    final $_column = $_itemColumn<int>('proyecto_id')!;

    final manager = $$ProyectosTableTableManager(
      $_db,
      $_db.proyectos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proyectoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CotizacionesTable, List<Cotizacione>>
  _cotizacionesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cotizaciones,
    aliasName: 'partidas_proyecto__id__cotizaciones__partida_id',
  );

  $$CotizacionesTableProcessedTableManager get cotizacionesRefs {
    final manager = $$CotizacionesTableTableManager(
      $_db,
      $_db.cotizaciones,
    ).filter((f) => f.partidaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cotizacionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartidasProyectoTableFilterComposer
    extends Composer<_$AppDatabase, $PartidasProyectoTable> {
  $$PartidasProyectoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get presupuestoCent => $composableBuilder(
    column: $table.presupuestoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cotizacionElegidaId => $composableBuilder(
    column: $table.cotizacionElegidaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$ProyectosTableFilterComposer get proyectoId {
    final $$ProyectosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableFilterComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cotizacionesRefs(
    Expression<bool> Function($$CotizacionesTableFilterComposer f) f,
  ) {
    final $$CotizacionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.partidaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableFilterComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartidasProyectoTableOrderingComposer
    extends Composer<_$AppDatabase, $PartidasProyectoTable> {
  $$PartidasProyectoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get presupuestoCent => $composableBuilder(
    column: $table.presupuestoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cotizacionElegidaId => $composableBuilder(
    column: $table.cotizacionElegidaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProyectosTableOrderingComposer get proyectoId {
    final $$ProyectosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableOrderingComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartidasProyectoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartidasProyectoTable> {
  $$PartidasProyectoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get presupuestoCent => $composableBuilder(
    column: $table.presupuestoCent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cotizacionElegidaId => $composableBuilder(
    column: $table.cotizacionElegidaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$ProyectosTableAnnotationComposer get proyectoId {
    final $$ProyectosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proyectoId,
      referencedTable: $db.proyectos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProyectosTableAnnotationComposer(
            $db: $db,
            $table: $db.proyectos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cotizacionesRefs<T extends Object>(
    Expression<T> Function($$CotizacionesTableAnnotationComposer a) f,
  ) {
    final $$CotizacionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cotizaciones,
      getReferencedColumn: (t) => t.partidaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CotizacionesTableAnnotationComposer(
            $db: $db,
            $table: $db.cotizaciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartidasProyectoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartidasProyectoTable,
          PartidasProyectoData,
          $$PartidasProyectoTableFilterComposer,
          $$PartidasProyectoTableOrderingComposer,
          $$PartidasProyectoTableAnnotationComposer,
          $$PartidasProyectoTableCreateCompanionBuilder,
          $$PartidasProyectoTableUpdateCompanionBuilder,
          (PartidasProyectoData, $$PartidasProyectoTableReferences),
          PartidasProyectoData,
          PrefetchHooks Function({bool proyectoId, bool cotizacionesRefs})
        > {
  $$PartidasProyectoTableTableManager(
    _$AppDatabase db,
    $PartidasProyectoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartidasProyectoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartidasProyectoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartidasProyectoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> proyectoId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<int> presupuestoCent = const Value.absent(),
                Value<int?> cotizacionElegidaId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => PartidasProyectoCompanion(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                descripcion: descripcion,
                presupuestoCent: presupuestoCent,
                cotizacionElegidaId: cotizacionElegidaId,
                estado: estado,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int proyectoId,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required int presupuestoCent,
                Value<int?> cotizacionElegidaId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => PartidasProyectoCompanion.insert(
                id: id,
                proyectoId: proyectoId,
                nombre: nombre,
                descripcion: descripcion,
                presupuestoCent: presupuestoCent,
                cotizacionElegidaId: cotizacionElegidaId,
                estado: estado,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartidasProyectoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({proyectoId = false, cotizacionesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cotizacionesRefs) db.cotizaciones,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (proyectoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.proyectoId,
                                    referencedTable:
                                        $$PartidasProyectoTableReferences
                                            ._proyectoIdTable(db),
                                    referencedColumn:
                                        $$PartidasProyectoTableReferences
                                            ._proyectoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cotizacionesRefs)
                        await $_getPrefetchedData<
                          PartidasProyectoData,
                          $PartidasProyectoTable,
                          Cotizacione
                        >(
                          currentTable: table,
                          referencedTable: $$PartidasProyectoTableReferences
                              ._cotizacionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartidasProyectoTableReferences(
                                db,
                                table,
                                p0,
                              ).cotizacionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partidaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PartidasProyectoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartidasProyectoTable,
      PartidasProyectoData,
      $$PartidasProyectoTableFilterComposer,
      $$PartidasProyectoTableOrderingComposer,
      $$PartidasProyectoTableAnnotationComposer,
      $$PartidasProyectoTableCreateCompanionBuilder,
      $$PartidasProyectoTableUpdateCompanionBuilder,
      (PartidasProyectoData, $$PartidasProyectoTableReferences),
      PartidasProyectoData,
      PrefetchHooks Function({bool proyectoId, bool cotizacionesRefs})
    >;
typedef $$CotizacionesTableCreateCompanionBuilder =
    CotizacionesCompanion Function({
      Value<int> id,
      required int partidaId,
      required String proveedor,
      Value<String?> contacto,
      required int montoCent,
      required DateTime fecha,
      Value<DateTime?> vigenteHasta,
      Value<String?> notas,
      Value<String?> fotoRutaRelativa,
      Value<bool> elegida,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });
typedef $$CotizacionesTableUpdateCompanionBuilder =
    CotizacionesCompanion Function({
      Value<int> id,
      Value<int> partidaId,
      Value<String> proveedor,
      Value<String?> contacto,
      Value<int> montoCent,
      Value<DateTime> fecha,
      Value<DateTime?> vigenteHasta,
      Value<String?> notas,
      Value<String?> fotoRutaRelativa,
      Value<bool> elegida,
      Value<DateTime> creadoEn,
      Value<DateTime> actualizadoEn,
    });

final class $$CotizacionesTableReferences
    extends BaseReferences<_$AppDatabase, $CotizacionesTable, Cotizacione> {
  $$CotizacionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartidasProyectoTable _partidaIdTable(_$AppDatabase db) => db
      .partidasProyecto
      .createAlias('cotizaciones__partida_id__partidas_proyecto__id');

  $$PartidasProyectoTableProcessedTableManager get partidaId {
    final $_column = $_itemColumn<int>('partida_id')!;

    final manager = $$PartidasProyectoTableTableManager(
      $_db,
      $_db.partidasProyecto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partidaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CotizacionesTableFilterComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get vigenteHasta => $composableBuilder(
    column: $table.vigenteHasta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoRutaRelativa => $composableBuilder(
    column: $table.fotoRutaRelativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get elegida => $composableBuilder(
    column: $table.elegida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$PartidasProyectoTableFilterComposer get partidaId {
    final $$PartidasProyectoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partidaId,
      referencedTable: $db.partidasProyecto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartidasProyectoTableFilterComposer(
            $db: $db,
            $table: $db.partidasProyecto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCent => $composableBuilder(
    column: $table.montoCent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get vigenteHasta => $composableBuilder(
    column: $table.vigenteHasta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoRutaRelativa => $composableBuilder(
    column: $table.fotoRutaRelativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get elegida => $composableBuilder(
    column: $table.elegida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartidasProyectoTableOrderingComposer get partidaId {
    final $$PartidasProyectoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partidaId,
      referencedTable: $db.partidasProyecto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartidasProyectoTableOrderingComposer(
            $db: $db,
            $table: $db.partidasProyecto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CotizacionesTable> {
  $$CotizacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);

  GeneratedColumn<int> get montoCent =>
      $composableBuilder(column: $table.montoCent, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<DateTime> get vigenteHasta => $composableBuilder(
    column: $table.vigenteHasta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get fotoRutaRelativa => $composableBuilder(
    column: $table.fotoRutaRelativa,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get elegida =>
      $composableBuilder(column: $table.elegida, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $$PartidasProyectoTableAnnotationComposer get partidaId {
    final $$PartidasProyectoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partidaId,
      referencedTable: $db.partidasProyecto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartidasProyectoTableAnnotationComposer(
            $db: $db,
            $table: $db.partidasProyecto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CotizacionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CotizacionesTable,
          Cotizacione,
          $$CotizacionesTableFilterComposer,
          $$CotizacionesTableOrderingComposer,
          $$CotizacionesTableAnnotationComposer,
          $$CotizacionesTableCreateCompanionBuilder,
          $$CotizacionesTableUpdateCompanionBuilder,
          (Cotizacione, $$CotizacionesTableReferences),
          Cotizacione,
          PrefetchHooks Function({bool partidaId})
        > {
  $$CotizacionesTableTableManager(_$AppDatabase db, $CotizacionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CotizacionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CotizacionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CotizacionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partidaId = const Value.absent(),
                Value<String> proveedor = const Value.absent(),
                Value<String?> contacto = const Value.absent(),
                Value<int> montoCent = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<DateTime?> vigenteHasta = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String?> fotoRutaRelativa = const Value.absent(),
                Value<bool> elegida = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CotizacionesCompanion(
                id: id,
                partidaId: partidaId,
                proveedor: proveedor,
                contacto: contacto,
                montoCent: montoCent,
                fecha: fecha,
                vigenteHasta: vigenteHasta,
                notas: notas,
                fotoRutaRelativa: fotoRutaRelativa,
                elegida: elegida,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partidaId,
                required String proveedor,
                Value<String?> contacto = const Value.absent(),
                required int montoCent,
                required DateTime fecha,
                Value<DateTime?> vigenteHasta = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<String?> fotoRutaRelativa = const Value.absent(),
                Value<bool> elegida = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
              }) => CotizacionesCompanion.insert(
                id: id,
                partidaId: partidaId,
                proveedor: proveedor,
                contacto: contacto,
                montoCent: montoCent,
                fecha: fecha,
                vigenteHasta: vigenteHasta,
                notas: notas,
                fotoRutaRelativa: fotoRutaRelativa,
                elegida: elegida,
                creadoEn: creadoEn,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CotizacionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partidaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partidaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partidaId,
                                referencedTable: $$CotizacionesTableReferences
                                    ._partidaIdTable(db),
                                referencedColumn: $$CotizacionesTableReferences
                                    ._partidaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CotizacionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CotizacionesTable,
      Cotizacione,
      $$CotizacionesTableFilterComposer,
      $$CotizacionesTableOrderingComposer,
      $$CotizacionesTableAnnotationComposer,
      $$CotizacionesTableCreateCompanionBuilder,
      $$CotizacionesTableUpdateCompanionBuilder,
      (Cotizacione, $$CotizacionesTableReferences),
      Cotizacione,
      PrefetchHooks Function({bool partidaId})
    >;
typedef $$AuditoriaTableCreateCompanionBuilder =
    AuditoriaCompanion Function({
      Value<int> id,
      Value<DateTime> fechaHora,
      required String entidad,
      required int entidadId,
      required String accion,
      Value<String?> valorAnteriorJson,
      Value<String?> valorNuevoJson,
      required String resumen,
      Value<DateTime> creadoEn,
    });
typedef $$AuditoriaTableUpdateCompanionBuilder =
    AuditoriaCompanion Function({
      Value<int> id,
      Value<DateTime> fechaHora,
      Value<String> entidad,
      Value<int> entidadId,
      Value<String> accion,
      Value<String?> valorAnteriorJson,
      Value<String?> valorNuevoJson,
      Value<String> resumen,
      Value<DateTime> creadoEn,
    });

class $$AuditoriaTableFilterComposer
    extends Composer<_$AppDatabase, $AuditoriaTable> {
  $$AuditoriaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entidadId => $composableBuilder(
    column: $table.entidadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valorAnteriorJson => $composableBuilder(
    column: $table.valorAnteriorJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valorNuevoJson => $composableBuilder(
    column: $table.valorNuevoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resumen => $composableBuilder(
    column: $table.resumen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditoriaTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditoriaTable> {
  $$AuditoriaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaHora => $composableBuilder(
    column: $table.fechaHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entidad => $composableBuilder(
    column: $table.entidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entidadId => $composableBuilder(
    column: $table.entidadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accion => $composableBuilder(
    column: $table.accion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valorAnteriorJson => $composableBuilder(
    column: $table.valorAnteriorJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valorNuevoJson => $composableBuilder(
    column: $table.valorNuevoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resumen => $composableBuilder(
    column: $table.resumen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditoriaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditoriaTable> {
  $$AuditoriaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaHora =>
      $composableBuilder(column: $table.fechaHora, builder: (column) => column);

  GeneratedColumn<String> get entidad =>
      $composableBuilder(column: $table.entidad, builder: (column) => column);

  GeneratedColumn<int> get entidadId =>
      $composableBuilder(column: $table.entidadId, builder: (column) => column);

  GeneratedColumn<String> get accion =>
      $composableBuilder(column: $table.accion, builder: (column) => column);

  GeneratedColumn<String> get valorAnteriorJson => $composableBuilder(
    column: $table.valorAnteriorJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valorNuevoJson => $composableBuilder(
    column: $table.valorNuevoJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resumen =>
      $composableBuilder(column: $table.resumen, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$AuditoriaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditoriaTable,
          AuditoriaData,
          $$AuditoriaTableFilterComposer,
          $$AuditoriaTableOrderingComposer,
          $$AuditoriaTableAnnotationComposer,
          $$AuditoriaTableCreateCompanionBuilder,
          $$AuditoriaTableUpdateCompanionBuilder,
          (
            AuditoriaData,
            BaseReferences<_$AppDatabase, $AuditoriaTable, AuditoriaData>,
          ),
          AuditoriaData,
          PrefetchHooks Function()
        > {
  $$AuditoriaTableTableManager(_$AppDatabase db, $AuditoriaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditoriaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditoriaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditoriaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fechaHora = const Value.absent(),
                Value<String> entidad = const Value.absent(),
                Value<int> entidadId = const Value.absent(),
                Value<String> accion = const Value.absent(),
                Value<String?> valorAnteriorJson = const Value.absent(),
                Value<String?> valorNuevoJson = const Value.absent(),
                Value<String> resumen = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => AuditoriaCompanion(
                id: id,
                fechaHora: fechaHora,
                entidad: entidad,
                entidadId: entidadId,
                accion: accion,
                valorAnteriorJson: valorAnteriorJson,
                valorNuevoJson: valorNuevoJson,
                resumen: resumen,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fechaHora = const Value.absent(),
                required String entidad,
                required int entidadId,
                required String accion,
                Value<String?> valorAnteriorJson = const Value.absent(),
                Value<String?> valorNuevoJson = const Value.absent(),
                required String resumen,
                Value<DateTime> creadoEn = const Value.absent(),
              }) => AuditoriaCompanion.insert(
                id: id,
                fechaHora: fechaHora,
                entidad: entidad,
                entidadId: entidadId,
                accion: accion,
                valorAnteriorJson: valorAnteriorJson,
                valorNuevoJson: valorNuevoJson,
                resumen: resumen,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditoriaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditoriaTable,
      AuditoriaData,
      $$AuditoriaTableFilterComposer,
      $$AuditoriaTableOrderingComposer,
      $$AuditoriaTableAnnotationComposer,
      $$AuditoriaTableCreateCompanionBuilder,
      $$AuditoriaTableUpdateCompanionBuilder,
      (
        AuditoriaData,
        BaseReferences<_$AppDatabase, $AuditoriaTable, AuditoriaData>,
      ),
      AuditoriaData,
      PrefetchHooks Function()
    >;
typedef $$AjustesTableCreateCompanionBuilder =
    AjustesCompanion Function({
      required String clave,
      required String valor,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });
typedef $$AjustesTableUpdateCompanionBuilder =
    AjustesCompanion Function({
      Value<String> clave,
      Value<String> valor,
      Value<DateTime> actualizadoEn,
      Value<int> rowid,
    });

class $$AjustesTableFilterComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AjustesTableOrderingComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AjustesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AjustesTable> {
  $$AjustesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clave =>
      $composableBuilder(column: $table.clave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );
}

class $$AjustesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AjustesTable,
          Ajuste,
          $$AjustesTableFilterComposer,
          $$AjustesTableOrderingComposer,
          $$AjustesTableAnnotationComposer,
          $$AjustesTableCreateCompanionBuilder,
          $$AjustesTableUpdateCompanionBuilder,
          (Ajuste, BaseReferences<_$AppDatabase, $AjustesTable, Ajuste>),
          Ajuste,
          PrefetchHooks Function()
        > {
  $$AjustesTableTableManager(_$AppDatabase db, $AjustesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AjustesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AjustesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AjustesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AjustesCompanion(
                clave: clave,
                valor: valor,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clave,
                required String valor,
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AjustesCompanion.insert(
                clave: clave,
                valor: valor,
                actualizadoEn: actualizadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AjustesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AjustesTable,
      Ajuste,
      $$AjustesTableFilterComposer,
      $$AjustesTableOrderingComposer,
      $$AjustesTableAnnotationComposer,
      $$AjustesTableCreateCompanionBuilder,
      $$AjustesTableUpdateCompanionBuilder,
      (Ajuste, BaseReferences<_$AppDatabase, $AjustesTable, Ajuste>),
      Ajuste,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CuentasTableTableManager get cuentas =>
      $$CuentasTableTableManager(_db, _db.cuentas);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$GastosFijosTableTableManager get gastosFijos =>
      $$GastosFijosTableTableManager(_db, _db.gastosFijos);
  $$GastosFijosPagosTableTableManager get gastosFijosPagos =>
      $$GastosFijosPagosTableTableManager(_db, _db.gastosFijosPagos);
  $$IngresosFijosTableTableManager get ingresosFijos =>
      $$IngresosFijosTableTableManager(_db, _db.ingresosFijos);
  $$IngresosFijosCobrosTableTableManager get ingresosFijosCobros =>
      $$IngresosFijosCobrosTableTableManager(_db, _db.ingresosFijosCobros);
  $$PresupuestosMensualesTableTableManager get presupuestosMensuales =>
      $$PresupuestosMensualesTableTableManager(_db, _db.presupuestosMensuales);
  $$ProyectosTableTableManager get proyectos =>
      $$ProyectosTableTableManager(_db, _db.proyectos);
  $$PartidasProyectoTableTableManager get partidasProyecto =>
      $$PartidasProyectoTableTableManager(_db, _db.partidasProyecto);
  $$CotizacionesTableTableManager get cotizaciones =>
      $$CotizacionesTableTableManager(_db, _db.cotizaciones);
  $$AuditoriaTableTableManager get auditoria =>
      $$AuditoriaTableTableManager(_db, _db.auditoria);
  $$AjustesTableTableManager get ajustes =>
      $$AjustesTableTableManager(_db, _db.ajustes);
}
