/// Value Object inmutable que representa una cantidad de dinero en céntimos de Sol (PEN).
///
/// REGLA DE ORO: El dinero NUNCA se almacena como double. Siempre como entero (int)
/// en céntimos para evitar inconsistencias por redondeo de coma flotante.
class Money implements Comparable<Money> {
  const Money.fromCents(this.cents);

  const Money._(this.cents);

  /// Cantidad de dinero en céntimos (ej. S/ 10.50 -> 1050 céntimos).
  final int cents;

  /// Crea una instancia con valor cero.
  static const Money zero = Money._(0);

  /// Convierte una cantidad en Soles (num) a céntimos con redondeo exacto.
  factory Money.fromSoles(num soles) {
    return Money.fromCents((soles * 100).round());
  }

  /// Parsea un texto numérico o formateado (ej. "1250.50", "S/ 1,250.50", "-45.20").
  factory Money.parse(String text) {
    final parsed = tryParse(text);
    if (parsed == null) {
      throw FormatException('Formato de dinero inválido: "$text"');
    }
    return parsed;
  }

  /// Intenta parsear un texto a [Money], retornando null si falla.
  static Money? tryParse(String? text) {
    if (text == null) return null;
    var cleaned = text.trim();
    if (cleaned.isEmpty) return null;

    // Detectar signo negativo antes de limpiar símbolos
    bool isNegative = false;
    if (cleaned.startsWith('-')) {
      isNegative = true;
      cleaned = cleaned.substring(1).trim();
    } else if (cleaned.endsWith('-')) {
      isNegative = true;
      cleaned = cleaned.substring(0, cleaned.length - 1).trim();
    }

    // Remover prefijos comunes de moneda
    cleaned = cleaned.replaceAll('S/.', '').replaceAll('S/', '').replaceAll('PEN', '').trim();

    if (isNegative && !cleaned.startsWith('-')) {
      cleaned = '-$cleaned';
    }

    // Normalizar separadores: si tiene ',' y '.'
    if (cleaned.contains(',') && cleaned.contains('.')) {
      final lastComma = cleaned.lastIndexOf(',');
      final lastDot = cleaned.lastIndexOf('.');
      if (lastDot > lastComma) {
        // Formato estándar peruano/internacional: 1,250.50 -> quitar comas
        cleaned = cleaned.replaceAll(',', '');
      } else {
        // Formato: 1.250,50 -> quitar puntos y cambiar coma por punto
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      }
    } else if (cleaned.contains(',')) {
      final commaIndex = cleaned.lastIndexOf(',');
      final decimals = cleaned.length - 1 - commaIndex;
      if (decimals <= 2) {
        cleaned = cleaned.replaceAll(',', '.');
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    }

    final doubleValue = double.tryParse(cleaned);
    if (doubleValue == null || doubleValue.isNaN || doubleValue.isInfinite) {
      return null;
    }
    return Money.fromSoles(doubleValue);
  }

  /// Valor equivalente en Soles como double (solo para visualización rápida o gráficos).
  double get inSoles => cents / 100.0;

  bool get isZero => cents == 0;
  bool get isPositive => cents > 0;
  bool get isNegative => cents < 0;

  Money abs() => Money.fromCents(cents.abs());

  // Operaciones Aritméticas Seguras
  Money operator +(Money other) => Money.fromCents(cents + other.cents);
  Money operator -(Money other) => Money.fromCents(cents - other.cents);
  Money operator -() => Money.fromCents(-cents);

  Money operator *(num factor) {
    return Money.fromCents((cents * factor).round());
  }

  Money operator /(num divisor) {
    if (divisor == 0) {
      throw ArgumentError('División por cero en operación monetaria');
    }
    return Money.fromCents((cents / divisor).round());
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  bool operator <(Money other) => cents < other.cents;
  bool operator <=(Money other) => cents <= other.cents;
  bool operator >(Money other) => cents > other.cents;
  bool operator >=(Money other) => cents >= other.cents;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && cents == other.cents);

  @override
  int get hashCode => cents.hashCode;

  /// Formatea la cantidad en Soles peruanos con 2 decimales (ej: "S/ 1,250.50").
  String format({
    String symbol = 'S/ ',
    bool includeSymbol = true,
  }) {
    final absCents = cents.abs();
    final solesPart = absCents ~/ 100;
    final centsPart = absCents % 100;

    // Formatear separador de miles con coma de forma determinista y sin coma flotante
    final digits = solesPart.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    final formattedSoles = buffer.toString();
    final formattedCents = centsPart.toString().padLeft(2, '0');

    final sign = cents < 0 ? '-' : '';
    final sym = includeSymbol ? symbol : '';
    return '$sign$sym$formattedSoles.$formattedCents';
  }

  @override
  String toString() => format();
}