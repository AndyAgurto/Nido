/// Constantes globales de la aplicaciÃ³n Nido.
class AppConstants {
  AppConstants._();

  static const String appName = 'Nido';
  static const String appSlogan = 'Tu hogar, en equilibrio.';
  static const String appPrivacyNotice =
      'Nido funciona 100% sin internet. Tus datos se guardan solo en esta tablet.';

  // LocalizaciÃ³n y moneda por defecto
  static const String defaultLocale = 'es_PE';
  static const String defaultCurrencyCode = 'PEN';
  static const String defaultCurrencySymbol = 'S/';
  static const String dateFormat = 'dd/MM/yyyy';

  // Breakpoints responsivos para Tablet
  /// Ancho mÃ­nimo para desplegar vista en dos paneles (master-detail)
  static const double tabletBreakpoint = 840.0;

  /// TamaÃ±o mÃ­nimo accesible para elementos interactivos tÃ¡ctiles
  static const double minTouchTargetSize = 48.0;

  /// Radio estÃ¡ndar de esquinas en tarjetas y paneles
  static const double cardBorderRadius = 16.0;

  /// Radio estÃ¡ndar para campos de entrada y botones
  static const double inputBorderRadius = 12.0;

  /// Radio estandar para cuadros de dialogo y modales
  static const double dialogBorderRadius = 16.0;
}
