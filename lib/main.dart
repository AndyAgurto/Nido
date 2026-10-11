import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/date_formatters.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDateFormats.init();

  runApp(
    const ProviderScope(
      child: NidoApp(),
    ),
  );
}
