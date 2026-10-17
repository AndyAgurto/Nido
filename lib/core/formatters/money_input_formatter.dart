import 'package:flutter/services.dart';

/// Formateador de texto monetario con comportamiento bancario estilo BCP / transferencias.
/// Prioriza el ingreso natural de enteros y permite hasta 2 cifras decimales tras el punto.
/// Ejemplo:
/// - Teclear '1' -> '1'
/// - Teclear '5' -> '15'
/// - Teclear '0' -> '150'
/// - Teclear '.' -> '150.'
/// - Teclear '5' -> '150.5'
/// - Teclear '0' -> '150.50'
/// - No permite un segundo punto ni más de 2 decimales.
class BcpMoneyInputFormatter extends TextInputFormatter {
  const BcpMoneyInputFormatter({
    this.maxDigits = 10,
    this.allowDecimals = true,
  });

  final int maxDigits;
  final bool allowDecimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Si el texto está vacío, permitir
    if (text.isEmpty) {
      return newValue;
    }

    // Normalizar coma a punto
    text = text.replaceAll(',', '.');

    // Si empieza con punto, anteponer 0: '.5' -> '0.5'
    if (text.startsWith('.')) {
      text = '0$text';
    }

    // No permitir múltiples puntos
    final dotCount = '.'.allMatches(text).length;
    if (dotCount > 1) {
      return oldValue;
    }

    // Validar caracteres: solo dígitos y punto
    final validChars = RegExp(r'^[0-9.]*$');
    if (!validChars.hasMatch(text)) {
      return oldValue;
    }

    if (text.contains('.')) {
      if (!allowDecimals) return oldValue;

      final parts = text.split('.');
      final integerPart = parts[0];
      final decimalPart = parts[1];

      // Limitar longitud de parte entera
      if (integerPart.length > maxDigits) {
        return oldValue;
      }

      // Máximo 2 decimales
      if (decimalPart.length > 2) {
        return oldValue;
      }

      // Si empieza con múltiples ceros como '00', corregir
      String cleanInt = integerPart;
      if (cleanInt.length > 1 && cleanInt.startsWith('0')) {
        cleanInt = int.tryParse(cleanInt)?.toString() ?? cleanInt;
      }

      final formatted = '$cleanInt.$decimalPart';
      final cursorOffset = formatted.length;
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: newValue.selection.end > formatted.length
              ? cursorOffset
              : newValue.selection.end,
        ),
      );
    } else {
      // Solo enteros
      if (text.length > maxDigits) {
        return oldValue;
      }

      // Eliminar ceros iniciales superfluos como '05' -> '5'
      String cleanInt = text;
      if (cleanInt.length > 1 && cleanInt.startsWith('0')) {
        cleanInt = int.tryParse(cleanInt)?.toString() ?? cleanInt;
      }

      return TextEditingValue(
        text: cleanInt,
        selection: TextSelection.collapsed(
          offset: newValue.selection.end > cleanInt.length
              ? cleanInt.length
              : newValue.selection.end,
        ),
      );
    }
  }
}
