import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

const double _kPixelRatio = 3.0;
const Size _kSmall = Size(170, 170);
const Size _kWide = Size(360, 170);
const Size _kLarge = Size(360, 360);

/// Google Fonts are downloaded lazily. If they are not ready when the widget is
/// rendered offscreen, Flutter silently falls back to the default font, which
/// makes the widgets look wrong. Always wait for them first.
Future<void> _ensureWidgetFonts() async {
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.almarai(),
      GoogleFonts.almarai(fontWeight: FontWeight.bold),
      GoogleFonts.amiri(),
      GoogleFonts.amiri(fontWeight: FontWeight.bold),
      GoogleFonts.amiriQuran(),
    ]).timeout(const Duration(seconds: 4), onTimeout: () => []);
  } catch (e, stack) {
    AppLogger.error('Failed to preload widget fonts', e, stack, 'WIDGET');
  }
}

/// Background callback entry point for home widget interactivity (e.g. tasbeeh tap)
@pragma('vm:entry-point')
Future<void> homeWidgetBackgroundCallback(Uri? uri) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (uri == null) return;

  final host = uri.host.toLowerCase();
  if (host == 'tasbeeh_tap' || uri.toString().contains('tasbeeh_tap')) {
    try {
      final prefs = await SharedPreferences.getInstance();
      const items = IstighfarItemModel.defaultItems;

      int index = prefs.getInt('widget_tasbeeh_index') ?? 0;
      int count = prefs.getInt('widget_tasbeeh_count') ?? 0;

      final currentItem = items[index % items.length];
      count++;

      if (count >= currentItem.targetCount) {
        count = 0;
        index = (index + 1) % items.length;
      }

      await prefs.setInt('widget_tasbeeh_index', index);
      await prefs.setInt('widget_tasbeeh_count', count);

      final nextItem = items[index % items.length];
      final tasbeehData = WidgetTasbeehData(
        phrase: nextItem.arabic,
        shortTitle: nextItem.shortTitle,
        virtue: nextItem.virtue,
        targetCount: nextItem.targetCount,
        currentCount: count,
      );

      await _ensureWidgetFonts();
      await HomeWidgetSyncService._renderAndUpdate(
        view: TasbeehSmallWidgetView(data: tasbeehData),
        key: 'widget_tasbeeh_small',
        size: _kSmall,
        androidName: 'TasbeehSmallWidgetProvider',
        iosName: 'TasbeehWidget',
      );
    } catch (e, stack) {
      AppLogger.error('Failed to handle tasbeeh background tap', e, stack, 'WIDGET');
    }
  }
}

abstract final class HomeWidgetSyncService {
  static const String appGroupId = 'group.com.sakina.islamic';
  static StreamSubscription<Uri?>? _widgetClickSubscription;

  static Future<void> _renderAndUpdate({
    required Widget view,
    required String key,
    required Size size,
    required String androidName,
    required String iosName,
  }) async {
    try {
      await HomeWidget.renderFlutterWidget(
        view,
        key: key,
        logicalSize: size,
        pixelRatio: _kPixelRatio,
      );
      await HomeWidget.updateWidget(
        name: androidName,
        qualifiedAndroidName: 'com.sakina.islamic.widgets.$androidName',
        iOSName: iosName,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to render or update $androidName ($key)', e, stack, 'WIDGET');
    }
  }

  /// Setup deep link listeners and interactive background callbacks
  static void initializeDeepLinks(GoRouter router) {
    if (kIsWeb) return;

    try {
      HomeWidget.setAppGroupId(appGroupId).catchError((e) {
        AppLogger.error('Failed to setAppGroupId', e, null, 'WIDGET');
        return false;
      });

      HomeWidget.registerInteractivityCallback(homeWidgetBackgroundCallback).catchError((e) {
        AppLogger.error('Failed to registerInteractivityCallback', e, null, 'WIDGET');
        return false;
      });

      HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
        if (uri != null) {
          _handleDeepLink(uri, router);
        }
      }).catchError((e) {
        AppLogger.error('Failed to get initiallyLaunchedFromHomeWidget', e, null, 'WIDGET');
      });

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

  static String _prayerTime(DateTime? time, String fallback) =>
      time != null ? GlobalPrayerTimesCalculator.formatTime12(time) : fallback;

  /// Synchronizes and renders all 8 home screen widgets
  static Future<void> syncAllWidgets({PreferencesService? prefs}) async {
    if (kIsWeb) return;

    try {
      await _ensureWidgetFonts();
      final now = DateTime.now();

      // 1. Hadith
      final todayHadith = DailyHadithService.getTodayHadith(now);
      final hadithData = WidgetHadithData(
        id: todayHadith.id,
        text: todayHadith.arabic,
        narrator: todayHadith.narratorAr,
        sourceBook: todayHadith.bookTitleAr,
        topic: todayHadith.topic ?? '',
      );

      // 2. Prayer
      final scheduleInfo = GlobalPrayerTimesCalculator.calculate(
        prefs: prefs,
        customNow: now,
      );
      final hijri = PrayerDateFormatter.computeHijri(now);
      final hijriString =
          '${ArabicNumerals.format(hijri.day)} ${hijri.monthName} ${ArabicNumerals.format(hijri.year)} هـ';
      final gregorianString =
          '${ArabicNumerals.format(now.day)} ${PrayerDateFormatter.getGregorianMonthNameArabic(now)} ${ArabicNumerals.format(now.year)}';

      // A widget is a static image, so a ticking HH:MM:SS countdown would be
      // frozen and wrong. Show hours:minutes only ("بعد 00:45").
      final rem = scheduleInfo.remainingToNext;
      final safeRem = rem.isNegative ? Duration.zero : rem;
      final hStr = safeRem.inHours.toString().padLeft(2, '0');
      final mStr = (safeRem.inMinutes % 60).toString().padLeft(2, '0');
      final countdownStr = 'بعد $hStr:$mStr';

      final prayersList = [
        WidgetPrayerItem(
          name: 'الفجر',
          time: _prayerTime(scheduleInfo.fajrTime, scheduleInfo.fajrFormatted),
          isNext: scheduleInfo.nextPrayerIndex == 0,
        ),
        WidgetPrayerItem(
          name: 'الشروق',
          time: _prayerTime(scheduleInfo.sunriseTime, scheduleInfo.sunriseFormatted),
          isNext: false,
        ),
        WidgetPrayerItem(
          name: 'الظهر',
          time: _prayerTime(scheduleInfo.dhuhrTime, scheduleInfo.dhuhrFormatted),
          isNext: scheduleInfo.nextPrayerIndex == 1,
        ),
        WidgetPrayerItem(
          name: 'العصر',
          time: _prayerTime(scheduleInfo.asrTime, scheduleInfo.asrFormatted),
          isNext: scheduleInfo.nextPrayerIndex == 2,
        ),
        WidgetPrayerItem(
          name: 'المغرب',
          time: _prayerTime(scheduleInfo.maghribTime, scheduleInfo.maghribFormatted),
          isNext: scheduleInfo.nextPrayerIndex == 3,
        ),
        WidgetPrayerItem(
          name: 'العشاء',
          time: _prayerTime(scheduleInfo.ishaTime, scheduleInfo.ishaFormatted),
          isNext: scheduleInfo.nextPrayerIndex == 4,
        ),
      ];

      final diacritics = RegExp(r'[\u064B-\u065F]');
      final prayerData = WidgetPrayerData(
        cityName: scheduleInfo.cityName,
        hijriDate: hijriString,
        gregorianDate: gregorianString,
        nextPrayerName: scheduleInfo.nextPrayerName.replaceAll(diacritics, ''),
        nextPrayerTime: scheduleInfo.nextPrayerTime,
        remainingCountdown: countdownStr,
        previousPrayerName: scheduleInfo.currentPrayerName.replaceAll(diacritics, ''),
        previousPrayerTime: scheduleInfo.currentPrayerTime,
        prayers: prayersList,
      );

      // 3. Quran
      final quranData = DailyQuranSeed.getTodayVerse(now);

      // 4. Tasbeeh (persisted count & rotation)
      final sp = await SharedPreferences.getInstance();
      const items = IstighfarItemModel.defaultItems;
      final savedIndex = sp.getInt('widget_tasbeeh_index') ??
          (now.difference(DateTime(now.year, 1, 1)).inDays % items.length);
      final currentTasbeehItem = items[savedIndex % items.length];
      final currentCount = sp.getInt('widget_tasbeeh_count') ?? 0;

      final tasbeehData = WidgetTasbeehData(
        phrase: currentTasbeehItem.arabic,
        shortTitle: currentTasbeehItem.shortTitle,
        virtue: currentTasbeehItem.virtue,
        targetCount: currentTasbeehItem.targetCount,
        currentCount: currentCount,
      );

      // 5. Render + update
      await _renderAndUpdate(
        view: HadithMediumWidgetView(data: hadithData),
        key: 'widget_hadith_medium',
        size: _kWide,
        androidName: 'HadithMediumWidgetProvider',
        iosName: 'HadithWidget',
      );
      await _renderAndUpdate(
        view: HadithSmallWidgetView(data: hadithData),
        key: 'widget_hadith_small',
        size: _kSmall,
        androidName: 'HadithSmallWidgetProvider',
        iosName: 'HadithWidget',
      );
      await _renderAndUpdate(
        view: QuranMediumWidgetView(data: quranData),
        key: 'widget_quran_medium',
        size: _kWide,
        androidName: 'QuranMediumWidgetProvider',
        iosName: 'QuranAyahWidget',
      );
      await _renderAndUpdate(
        view: QuranSmallWidgetView(data: quranData),
        key: 'widget_quran_small',
        size: _kSmall,
        androidName: 'QuranSmallWidgetProvider',
        iosName: 'QuranAyahWidget',
      );
      await _renderAndUpdate(
        view: PrayerLargeWidgetView(data: prayerData),
        key: 'widget_prayer_large',
        size: _kLarge,
        androidName: 'PrayerLargeWidgetProvider',
        iosName: 'PrayerTimesWidget',
      );
      await _renderAndUpdate(
        view: PrayerMediumWidgetView(data: prayerData),
        key: 'widget_prayer_medium',
        size: _kWide,
        androidName: 'PrayerMediumWidgetProvider',
        iosName: 'PrayerTimesWidget',
      );
      await _renderAndUpdate(
        view: PrayerSmallWidgetView(data: prayerData),
        key: 'widget_prayer_small',
        size: _kSmall,
        androidName: 'PrayerSmallWidgetProvider',
        iosName: 'PrayerTimesWidget',
      );
      await _renderAndUpdate(
        view: TasbeehSmallWidgetView(data: tasbeehData),
        key: 'widget_tasbeeh_small',
        size: _kSmall,
        androidName: 'TasbeehSmallWidgetProvider',
        iosName: 'TasbeehWidget',
      );

      AppLogger.info('Successfully synced and updated all 8 home widgets', 'WIDGET');
    } catch (e, stack) {
      AppLogger.error('Failed to sync home widgets', e, stack, 'WIDGET');
    }
  }

  static void dispose() {
    _widgetClickSubscription?.cancel();
    _widgetClickSubscription = null;
  }
}