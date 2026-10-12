import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'seguridad_service.dart';

/// Provider singleton de SeguridadService.
final seguridadServiceProvider = Provider<SeguridadService>((ref) {
  return SeguridadService();
});

/// Indica si el PIN está configurado en el almacenamiento seguro.
final tienePinConfiguradoProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(seguridadServiceProvider);
  return service.tienePinConfigurado();
});

/// Indica si la biometría está disponible en el hardware del dispositivo.
final biometriaDisponibleProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(seguridadServiceProvider);
  return service.biometriaDisponible();
});

/// Indica si la biometría está activada por el usuario.
final biometriaActivaProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(seguridadServiceProvider);
  return service.biometriaActiva();
});

/// Estado que determina si la app se encuentra actualmente bloqueada (pantalla de PIN).
final estaBloqueadoProvider = StateProvider<bool>((ref) => false);