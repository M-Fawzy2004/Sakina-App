import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/arabic_numerals.dart';
import 'package:sakina_app/features/home_widgets/data/daily_quran_seed.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/hadith_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/prayer_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/quran_widget_view.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/tasbeeh_widget_view.dart';
import 'package:sakina_app/features/istighfar/data/models/istighfar_item_model.dart';
import 'package:sakina_app/features/maladh/domain/services/daily_hadith_service.dart';
import 'package:sakina_app/features/maladh/domain/services/global_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_date_formatter.dart';

abstract final class HomeWidgetSyncService {
  static const String appGroupId = 'group.com.sakina.islamic';
  static StreamSubscription<Uri?>? _widgetClickSubscription;

  /// Setup deep link listeners when a user taps any home widget
  static void initializeDeepLinks(GoRouter router) {
    if (kIsWeb) return;

    try {
      HomeWidget.setAppGroupId(appGroupId).catchError((e) {
        AppLogger.error('Failed to setAppGroupId', e, null, 'WIDGET');
        return false;
      });

      // Initial launch check
      HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
        if (uri != null) {
          _handleDeepLink(uri, router);
        }
      }).catchError((e) {
        AppLogger.error('Failed to get initiallyLaunchedFromHomeWidget', e, null, 'WIDGET');
      });

      // Subsequent background/resumed clicks
      _widgetClickSubscription?.cancel();
      _widgetClickSubscription = HomeWidget.widgetClicked.listen(
        (uri) {
          if (uri != null) {
            _handleDeepLink(uri, router);
          }
        },
        onError: (e) {
          AppLogger.error('Widget clicked stream error', e, null, 'WIDGET');
        },
      );
    } catch (e, stack) {
      AppLogger.error('Failed to initialize home widget deep links', e, stack, 'WIDGET');
    }
  }

  static void _handleDeepLink(Uri uri, GoRouter router) {
    AppLogger.info('Home widget tapped with URI: $uri', 'WIDGET');
    final host = uri.host.toLowerCase();
    switch (host) {
      case 'hadith':
        router.push(AppRoutes.sunnahBooks);
        break;
      case 'prayer':
        router.push(AppRoutes.prayerTimes);
        break;
      case 'quran':
        router.go(AppRoutes.quran);
        break;
      case 'tasbeeh':
        router.push(AppRoutes.istighfar);
        break;
      default:
        break;
    }
  }

  /// Synchronizes and renders all 9 home screen widgets
  static Future<void> syncAllWidgets({PreferencesService? prefs}) async {
    if (kIsWeb) return;

    try {
      final now = DateTime.now();

      // 1. Build Hadith Data
      final todayHadith = DailyHadithService.getTodayHadith(now);
      final hadithData = WidgetHadithData(
        id: todayHadith.id,
        text: todayHadith.arabic,
        narrator: todayHadith.narratorAr,
        sourceBook: todayHadith.bookTitleAr,
        topic: todayHadith.topic ?? '',
      );

      // 2. Build Prayer Data
      final scheduleInfo = GlobalPrayerTimesCalculator.calculate(
        prefs: prefs,
        customNow: now,
      );
      final hijri = PrayerDateFormatter.computeHijri(now);
      final hijriString = '${ArabicNumerals.format(hijri.day)} ${hijri.monthName} ${ArabicNumerals.format(hijri.year)} هـ';
      final gregorianString = '${ArabicNumerals.format(now.day)} ${PrayerDateFormatter.getGregorianMonthNameArabic(now)} ${ArabicNumerals.format(now.year)}';

      final rem = scheduleInfo.remainingToNext;
      final remHours = rem.inHours.toString().padLeft(2, '0');
      final remMinutes = (rem.inMinutes % 60).toString().padLeft(2, '0');
      final remSeconds = (rem.inSeconds % 60).toString().padLeft(2, '0');
      final countdownStr = '$remHours:$remMinutes:$remSeconds';

      final prayersList = [
        WidgetPrayerItem(
          name: 'الفجر',
          time: scheduleInfo.fajrTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.fajrTime!)
              : scheduleInfo.fajrFormatted,
          isNext: scheduleInfo.nextPrayerIndex == 0,
        ),
        WidgetPrayerItem(
          name: 'الشروق',
          time: scheduleInfo.sunriseTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.sunriseTime!)
              : scheduleInfo.sunriseFormatted,
          isNext: false,
        ),
        WidgetPrayerItem(
          name: 'الظهر',
          time: scheduleInfo.dhuhrTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.dhuhrTime!)
              : scheduleInfo.dhuhrFormatted,
          isNext: scheduleInfo.nextPrayerIndex == 1,
        ),
        WidgetPrayerItem(
          name: 'العصر',
          time: scheduleInfo.asrTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.asrTime!)
              : scheduleInfo.asrFormatted,
          isNext: scheduleInfo.nextPrayerIndex == 2,
        ),
        WidgetPrayerItem(
          name: 'المغرب',
          time: scheduleInfo.maghribTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.maghribTime!)
              : scheduleInfo.maghribFormatted,
          isNext: scheduleInfo.nextPrayerIndex == 3,
        ),
        WidgetPrayerItem(
          name: 'العشاء',
          time: scheduleInfo.ishaTime != null
              ? GlobalPrayerTimesCalculator.formatTime12(scheduleInfo.ishaTime!)
              : scheduleInfo.ishaFormatted,
          isNext: scheduleInfo.nextPrayerIndex == 4,
        ),
      ];

      final prayerData = WidgetPrayerData(
        cityName: scheduleInfo.cityName,
        hijriDate: hijriString,
        gregorianDate: gregorianString,
        nextPrayerName: scheduleInfo.nextPrayerName.replaceAll(RegExp(r'[\u064B-\u065F]'), ''),
        nextPrayerTime: scheduleInfo.nextPrayerTime,
        remainingCountdown: countdownStr,
        previousPrayerName: scheduleInfo.currentPrayerName.replaceAll(RegExp(r'[\u064B-\u065F]'), ''),
        previousPrayerTime: scheduleInfo.currentPrayerTime,
        prayers: prayersList,
      );

      // 3. Build Quran Ayah Data
      final quranData = DailyQuranSeed.getTodayVerse(now);

      // 4. Build Tasbeeh Data
      final defaultTasbeeh = IstighfarItemModel.defaultItems.first;
      final tasbeehData = WidgetTasbeehData(
        phrase: defaultTasbeeh.arabic,
        shortTitle: defaultTasbeeh.shortTitle,
        virtue: defaultTasbeeh.virtue,
        targetCount: defaultTasbeeh.targetCount,
      );

      // 5. Render Flutter views to offscreen PNG and update Native Providers
      // Hadith Large
      await HomeWidget.renderFlutterWidget(
        HadithLargeWidgetView(data: hadithData),
        key: 'widget_hadith_large',
        logicalSize: const Size(360, 360),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'HadithLargeWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.HadithLargeWidgetProvider',
        iOSName: 'HadithWidget',
      );

      // Hadith Medium
      await HomeWidget.renderFlutterWidget(
        HadithMediumWidgetView(data: hadithData),
        key: 'widget_hadith_medium',
        logicalSize: const Size(360, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'HadithMediumWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.HadithMediumWidgetProvider',
        iOSName: 'HadithWidget',
      );

      // Hadith Small
      await HomeWidget.renderFlutterWidget(
        HadithSmallWidgetView(data: hadithData),
        key: 'widget_hadith_small',
        logicalSize: const Size(170, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'HadithSmallWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.HadithSmallWidgetProvider',
        iOSName: 'HadithWidget',
      );

      // Prayer Large
      await HomeWidget.renderFlutterWidget(
        PrayerLargeWidgetView(data: prayerData),
        key: 'widget_prayer_large',
        logicalSize: const Size(360, 360),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'PrayerLargeWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.PrayerLargeWidgetProvider',
        iOSName: 'PrayerTimesWidget',
      );

      // Prayer Medium
      await HomeWidget.renderFlutterWidget(
        PrayerMediumWidgetView(data: prayerData),
        key: 'widget_prayer_medium',
        logicalSize: const Size(360, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'PrayerMediumWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.PrayerMediumWidgetProvider',
        iOSName: 'PrayerTimesWidget',
      );

      // Prayer Small
      await HomeWidget.renderFlutterWidget(
        PrayerSmallWidgetView(data: prayerData),
        key: 'widget_prayer_small',
        logicalSize: const Size(170, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'PrayerSmallWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.PrayerSmallWidgetProvider',
        iOSName: 'PrayerTimesWidget',
      );

      // Quran Large
      await HomeWidget.renderFlutterWidget(
        QuranLargeWidgetView(data: quranData),
        key: 'widget_quran_large',
        logicalSize: const Size(360, 360),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'QuranLargeWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.QuranLargeWidgetProvider',
        iOSName: 'QuranAyahWidget',
      );

      // Quran Medium
      await HomeWidget.renderFlutterWidget(
        QuranMediumWidgetView(data: quranData),
        key: 'widget_quran_medium',
        logicalSize: const Size(360, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'QuranMediumWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.QuranMediumWidgetProvider',
        iOSName: 'QuranAyahWidget',
      );

      // Tasbeeh Small
      await HomeWidget.renderFlutterWidget(
        TasbeehSmallWidgetView(data: tasbeehData),
        key: 'widget_tasbeeh_small',
        logicalSize: const Size(170, 170),
        pixelRatio: 2.0,
      );
      await HomeWidget.updateWidget(
        name: 'TasbeehSmallWidgetProvider',
        qualifiedAndroidName: 'com.sakina.islamic.widgets.TasbeehSmallWidgetProvider',
        iOSName: 'TasbeehWidget',
      );

      AppLogger.info('Successfully synced and updated all 9 home widgets', 'WIDGET');
    } catch (e, stack) {
      AppLogger.error('Failed to sync home widgets', e, stack, 'WIDGET');
    }
  }

  static void dispose() {
    _widgetClickSubscription?.cancel();
    _widgetClickSubscription = null;
  }
}
