import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_cubit.dart';
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

    // Initialize on-device local notifications & sync scheduled reminders
    if (sl.isRegistered<LocalNotificationService>()) {
      await sl<LocalNotificationService>().initialize();
      if (sl.isRegistered<PreferencesService>()) {
        final prefs = sl<PreferencesService>();
        final data = SettingsPersistenceManager.load(prefs);
        unawaited(
          sl<LocalNotificationService>().syncAllNotifications(
            morningEveningAzkar: data.morningEveningAzkar,
            dailyQuranReminder: data.dailyQuranReminder,
            dailyHopeReminder: data.dailyHopeReminder,
            nightPrayerReminder: data.nightPrayerReminder,
          ),
        );
      }
    }

    // Pre-warm local Quran catalog, Athkar, Hisn al-Muslim, and Sunnah Books in memory for 0ms instantaneous opening
    unawaited(sl<QuranCubit>().loadQuranData());
    unawaited(sl<AthkarCubit>().loadAthkar());
    unawaited(sl<HisnCubit>().ensureLoaded());
    unawaited(sl<SunnahBooksCubit>().ensureLoaded());
  } catch (e, stack) {
    AppLogger.error('Failed to initialize dependencies', e, stack, 'INIT');
  }

  runApp(DevicePreview(enabled: true, builder: (context) => const SakinaApp()));
}
