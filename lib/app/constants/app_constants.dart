/// Constantes globales de la aplicación Nido.
class AppConstants {
  AppConstants._();

  static const String appName = 'Nido';
  static const String appSlogan = 'Tu hogar, en equilibrio.';
  static const String appPrivacyNotice =
      'Nido funciona 100% sin internet. Tus datos se guardan solo en esta tablet.';

  // Localización y moneda por defecto
  static const String defaultLocale = 'es_PE';
  static const String defaultCurrencyCode = 'PEN';
  static const String defaultCurrencySymbol = 'S/';
  static const String dateFormat = 'dd/MM/yyyy';

  // Breakpoints responsivos para Tablet
  /// Ancho mínimo para desplegar vista en dos paneles (master-detail)
  static const double tabletBreakpoint = 840.0;

  /// Tamaño mínimo accesible para elementos interactivos táctiles
  static const double minTouchTargetSize = 48.0;

  /// Radio estándar de esquinas en tarjetas y paneles
  static const double cardBorderRadius = 16.0;

  /// Radio estándar para campos de entrada y botones
  static const double inputBorderRadius = 12.0;
}
