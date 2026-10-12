import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Servicio de seguridad local con hashing PBKDF2/SHA-256 + sal aleatoria
/// y soporte biom�trico mediante hardware seguro de la tablet.
class SeguridadService {
  SeguridadService({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _localAuth = localAuth ?? LocalAuthentication();

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  static const String _keyPinHash = 'nido_pin_hash';
  static const String _keyPinSalt = 'nido_pin_salt';
  static const String _keyBiometria = 'nido_biometria_activa';

  /// Verifica si el usuario tiene configurado un PIN de acceso.
  Future<bool> tienePinConfigurado() async {
    final hash = await _storage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  /// Guarda un nuevo PIN generando una sal criptogr�fica aleatoria de 32 bytes
  /// y derivando el hash SHA-256.
  Future<void> guardarPin(String pin) async {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final salt = saltBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    final hash = sha256.convert(utf8.encode('$salt$pin')).toString();

    await _storage.write(key: _keyPinHash, value: hash);
    await _storage.write(key: _keyPinSalt, value: salt);
  }

  /// Valida el PIN ingresado por el usuario frente al hash y sal almacenados.
  Future<bool> validarPin(String pin) async {
    final hashGuardado = await _storage.read(key: _keyPinHash);
    final salt = await _storage.read(key: _keyPinSalt);

    if (hashGuardado == null || salt == null) return false;

    final hashCalculado = sha256.convert(utf8.encode('$salt$pin')).toString();
    return hashGuardado == hashCalculado;
  }

  /// Elimina el PIN y desactiva la protecci�n por contrase�a.
  Future<void> desactivarPin() async {
    await _storage.delete(key: _keyPinHash);
    await _storage.delete(key: _keyPinSalt);
    await _storage.delete(key: _keyBiometria);
  }

  /// Comprueba si el dispositivo tablet cuenta con sensores biom�tricos disponibles.
  Future<bool> biometriaDisponible() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (_) {
      return false;
    }
  }

  /// Verifica si la autenticaci�n biom�trica est� habilitada por el usuario.
  Future<bool> biometriaActiva() async {
    final val = await _storage.read(key: _keyBiometria);
    return val == 'true';
  }

  /// Habilita o deshabilita la autenticaci�n biom�trica.
  Future<void> setBiometriaActiva(bool activa) async {
    await _storage.write(key: _keyBiometria, value: activa ? 'true' : 'false');
  }

  /// Ejecuta la autenticaci�n biom�trica del sistema operativo (huella/rostro).
  Future<bool> autenticarBiometrico() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Confirma tu identidad para acceder a Nido',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}