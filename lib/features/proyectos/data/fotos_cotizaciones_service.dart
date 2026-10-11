import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Servicio local para almacenamiento privado de fotografías de cotizaciones.
/// Cumple con la regla de privacidad 100% LOCAL y almacenamiento relativo en sandbox.
class FotosCotizacionesService {
  static const String fotosSubfolder = 'cotizaciones_fotos';

  /// Guarda una foto seleccionada por el usuario dentro del directorio privado de la app.
  /// Retorna la ruta relativa (ej. 'cotizaciones_fotos/cotizacion_1_1697000000.jpg')
  /// para persistir en la base de datos de forma portable entre versiones de sandbox.
  static Future<String?> guardarFoto({
    required int partidaId,
    required XFile archivo,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fotosDir = Directory(p.join(appDir.path, fotosSubfolder));
      if (!await fotosDir.exists()) {
        await fotosDir.create(recursive: true);
      }

      final ext = p.extension(archivo.path).isNotEmpty
          ? p.extension(archivo.path)
          : '.jpg';
      final fileName =
          'cotizacion_${partidaId}_${DateTime.now().millisecondsSinceEpoch}$ext';
      final destinoPath = p.join(fotosDir.path, fileName);

      final nuevoArchivo = await File(archivo.path).copy(destinoPath);
      if (await nuevoArchivo.exists()) {
        return '$fotosSubfolder/$fileName';
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Resuelve la ruta absoluta en tiempo de ejecución a partir de la ruta relativa guardada.
  static Future<File?> resolverArchivo(String? rutaRelativa) async {
    if (rutaRelativa == null || rutaRelativa.isEmpty) return null;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final archivo = File(p.join(appDir.path, rutaRelativa));
      if (await archivo.exists()) {
        return archivo;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Elimina una fotografía física del sandbox privado.
  static Future<bool> eliminarFoto(String? rutaRelativa) async {
    if (rutaRelativa == null || rutaRelativa.isEmpty) return false;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final archivo = File(p.join(appDir.path, rutaRelativa));
      if (await archivo.exists()) {
        await archivo.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
