import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider reactivo para gestionar el modo visual de la aplicación (Claro, Oscuro o Sistema).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
