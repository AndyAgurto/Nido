import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';

/// Indica si el onboarding inicial ya ha sido completado por el usuario.
final onboardingCompletadoProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final val = await db.ajustesDao.getValor('onboarding_completado');
  return val == 'true';
});
