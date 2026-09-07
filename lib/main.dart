import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';
import 'models/medicine.dart';
import 'models/medicine_batch.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register Hive adapters before opening any Hive boxes.
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MedicineAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MedicineBatchAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediLink',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}