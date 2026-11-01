import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/sakina_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Guarantee ScreenUtil viewport metrics are pre-calculated before first widget build
  await ScreenUtil.ensureScreenSize();

  // Lock preferred orientations to portrait for pristine luxury typography
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI styling (OLED immersion with transparent status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize service locator and asynchronous dependencies
  try {
    await initServiceLocator();
    AppLogger.info('Service locator successfully initialized', 'INIT');

    // Pre-warm local Quran catalog and Athkar in memory for 0ms instantaneous opening
    unawaited(sl<QuranCubit>().loadQuranData());
    unawaited(sl<AthkarCubit>().loadAthkar());
  } catch (e, stack) {
    AppLogger.error('Failed to initialize dependencies', e, stack, 'INIT');
  }

  runApp(
    DevicePreview(enabled: false, builder: (context) => const SakinaApp()),
  );
}
