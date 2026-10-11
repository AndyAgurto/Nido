import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Utilidades de formato de fechas seguras y localizadas para Nido.
class AppDateFormats {
  static bool _initialized = false;

  /// Asegura que los simbolos locales esten disponibles.
  static Future<void> init() async {
    if (!_initialized) {
      try {
        await initializeDateFormatting('es_PE', null);
        _initialized = true;
      } catch (_) {}
    }
  }

  /// Formatea mes y anio (ej: OCTUBRE 2026).
  static String formatMesAnio(DateTime date) {
    try {
      return DateFormat('MMMM yyyy', 'es_PE').format(date).toUpperCase();
    } catch (_) {
      return DateFormat('MMMM yyyy').format(date).toUpperCase();
    }
  }

  /// Formatea fecha y dia (ej: 11/10/2026 domingo).
  static String formatFechaConDia(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy (EEEE)', 'es_PE').format(date);
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  /// Formatea fecha y hora completa en espanol.
  static String formatFechaHoraCompleta(DateTime date) {
    try {
      return DateFormat('EEEE, d MMMM yyyy - HH:mm', 'es_PE').format(date);
    } catch (_) {
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    }
  }

  /// Formato simple dd/MM/yyyy.
  static String formatSimple(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formato simple dd/MM/yyyy HH:mm.
  static String formatSimpleHora(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Formato completo con segundos dd/MM/yyyy HH:mm:ss.
  static String formatSimpleSegundos(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }
}
