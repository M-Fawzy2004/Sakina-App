import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sakina_app/core/services/notifications/quran_reflections_catalog.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Contract for on-device, 100% offline-first scheduled notifications.
abstract class LocalNotificationService {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> handleFirstLaunchPermissions({
    required PreferencesService prefs,
  });
  Future<void> scheduleMorningEveningAzkar({required bool enabled});
  Future<void> scheduleDailyQuranReminder({required bool enabled});
  Future<void> scheduleDailyHopeReminder({required bool enabled});
  Future<void> scheduleNightPrayerReminder({required bool enabled});
  Future<void> schedulePrePrayerReminders({required bool enabled});
  Future<void> scheduleRotatingQuranNotifications({
    required bool enabled,
    PreferencesService? prefs,
  });
  Future<void> syncAllNotifications({
    required bool morningEveningAzkar,
    required bool dailyQuranReminder,
    required bool dailyHopeReminder,
    required bool nightPrayerReminder,
    bool prePrayerReminders = true,
    bool rotatingQuranNotifications = true,
    PreferencesService? prefs,
  });
  Future<void> cancel(int id);
  Future<void> cancelAll();
}

/// Implementation of [LocalNotificationService] using [FlutterLocalNotificationsPlugin] and [timezone].
///
/// Designed exclusively for Sakina:
/// - Pure, eloquent spiritual Arabic text without emojis or text symbols.
/// - Reliable recurring daily schedules.
/// - Battery-friendly background execution compliant with Android & iOS guidelines.
class LocalNotificationServiceImpl implements LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationServiceImpl({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'sakina_spiritual_reminders';
  static const String _channelName = 'التذكيرات والورد اليومي';
  static const String _channelDescription =
      'تنبيهات أذكار الصباح والمساء والورد القرآني وقيام الليل في تطبيق سكينة';

  static const int idMorningAzkar = 101;
  static const int idEveningAzkar = 102;
  static const int idDailyQuran = 103;
  static const int idDailyHope = 104;
  static const int idNightPrayer = 105;

  static const int idPrePrayerFajr = 201;
  static const int idPrePrayerDhuhr = 202;
  static const int idPrePrayerAsr = 203;
  static const int idPrePrayerMaghrib = 204;
  static const int idPrePrayerIsha = 205;

  static const int idRotatingQuranBase = 300;
  static const int rotatingDaysAhead = 7;
  static const int slotsPerDay = 3;
  static const int rotatingQuranCount = rotatingDaysAhead * slotsPerDay; // 21

  static const List<int> rotatingSlotHours = [9, 15, 21];
  static const List<int> rotatingSlotMinutes = [15, 45, 15];

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _configureLocalTimeZone();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      AppLogger.info('LocalNotificationService initialized', 'NOTIFICATION');
    } catch (e, st) {
      AppLogger.error('Failed to initialize LocalNotificationService', e, st,
          'NOTIFICATION');
    }
  }

  void _configureLocalTimeZone() {
    tz.initializeTimeZones();
    try {
      final String timeZoneName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // Fallback gracefully to default timezone if abbreviation is not recognized
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info(
      'Notification tapped: ${response.id} with payload: ${response.payload}',
      'NOTIFICATION',
    );
  }

  @override
  Future<bool> requestPermissions() async {
    bool granted = false;

    try {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final androidGranted =
            await androidImplementation.requestNotificationsPermission();
        granted = androidGranted ?? false;
      }

      final iosImplementation = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        final iosGranted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        granted = iosGranted ?? false;
      }
    } catch (e, st) {
      AppLogger.error(
          'Error requesting notification permissions', e, st, 'NOTIFICATION');
    }

    return granted;
  }

  @override
  Future<bool> handleFirstLaunchPermissions({
    required PreferencesService prefs,
  }) async {
    final alreadyPrompted = prefs.getBool(
          SettingsPersistenceManager.keyNotificationPermissionPrompted,
        ) ??
        false;

    if (alreadyPrompted) {
      return false;
    }

    final granted = await requestPermissions();
    await prefs.setBool(
      SettingsPersistenceManager.keyNotificationPermissionPrompted,
      true,
    );

    if (granted) {
      await prefs.setBool(
        SettingsPersistenceManager.keyMorningEveningAzkar,
        true,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyDailyQuranReminder,
        true,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyDailyHopeReminder,
        true,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyNightPrayerReminder,
        true,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyPrePrayerReminder,
        true,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyRotatingQuranNotifications,
        true,
      );

      await syncAllNotifications(
        morningEveningAzkar: true,
        dailyQuranReminder: true,
        dailyHopeReminder: true,
        nightPrayerReminder: true,
        prePrayerReminders: true,
        rotatingQuranNotifications: true,
        prefs: prefs,
      );
      AppLogger.info(
        'First launch notification permission granted: all reminders activated',
        'NOTIFICATION',
      );
    } else {
      await prefs.setBool(
        SettingsPersistenceManager.keyMorningEveningAzkar,
        false,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyDailyQuranReminder,
        false,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyDailyHopeReminder,
        false,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyNightPrayerReminder,
        false,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyPrePrayerReminder,
        false,
      );
      await prefs.setBool(
        SettingsPersistenceManager.keyRotatingQuranNotifications,
        false,
      );

      await cancelAll();
      AppLogger.info(
        'First launch notification permission denied: all reminders deactivated',
        'NOTIFICATION',
      );
    }

    return granted;
  }

  NotificationDetails _buildNotificationDetails() {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFD4AF37),
      enableLights: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String payload,
  }) async {
    try {
      final scheduledDate = _nextInstanceOfTime(hour, minute);
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _buildNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to schedule notification $id ($title)',
        e,
        st,
        'NOTIFICATION',
      );
    }
  }

  @override
  Future<void> scheduleMorningEveningAzkar({required bool enabled}) async {
    if (!enabled) {
      await cancel(idMorningAzkar);
      await cancel(idEveningAzkar);
      return;
    }

    // Morning Azkar at 06:00 AM
    await _scheduleDaily(
      id: idMorningAzkar,
      title: 'أذكار الصباح',
      body:
          'أصبحنا وأصبح الملك لله، عطر يومك بذكر الله وحصن نفسك بالمعوذات وأذكار الصباح المأثورة.',
      hour: 6,
      minute: 0,
      payload: 'morning_azkar',
    );

    // Evening Azkar at 17:30 (5:30 PM)
    await _scheduleDaily(
      id: idEveningAzkar,
      title: 'أذكار المساء',
      body:
          'أمسينا وأمسى الملك لله، أقبل المساء بنفحات السكينة وحفظ الله الحفيظ، ردد أذكار المساء لحفظ نفسك وأهلك.',
      hour: 17,
      minute: 30,
      payload: 'evening_azkar',
    );
  }

  @override
  Future<void> scheduleDailyQuranReminder({required bool enabled}) async {
    if (!enabled) {
      await cancel(idDailyQuran);
      return;
    }

    // Daily Quran portion at 13:30 (1:30 PM after Dhuhr)
    await _scheduleDaily(
      id: idDailyQuran,
      title: 'الورد القرآني اليومي',
      body:
          'طهِّر فؤادك بآيات من الذكر الحكيم، واجعل لك ورداً ثابتاً من كتاب ربك يحفظك ويبارك في يومك.',
      hour: 13,
      minute: 30,
      payload: 'daily_quran',
    );
  }

  @override
  Future<void> scheduleDailyHopeReminder({required bool enabled}) async {
    if (!enabled) {
      await cancel(idDailyHope);
      return;
    }

    // Daily Hope Dose at 10:30 AM
    await _scheduleDaily(
      id: idDailyHope,
      title: 'جرعة أمل وسكينة',
      body:
          'فإن مع العسر يسراً، إن مع العسر يسراً؛ ثق بتدبير الله ولطفه، فما ضاقت إلا لتفرج.',
      hour: 10,
      minute: 30,
      payload: 'daily_hope',
    );
  }

  @override
  Future<void> scheduleNightPrayerReminder({required bool enabled}) async {
    if (!enabled) {
      await cancel(idNightPrayer);
      return;
    }

    // Night prayer & Sahar at 03:00 AM (last third of the night)
    await _scheduleDaily(
      id: idNightPrayer,
      title: 'قيام الليل والأسحار',
      body:
          'نفحات الثلث الأخير من الليل؛ خلوة بين يدي الله ودعاء مستجاب في وقت النزول الإلهي.',
      hour: 3,
      minute: 0,
      payload: 'night_prayer',
    );
  }

  @override
  Future<void> schedulePrePrayerReminders({required bool enabled}) async {
    if (!enabled) {
      await cancel(idPrePrayerFajr);
      await cancel(idPrePrayerDhuhr);
      await cancel(idPrePrayerAsr);
      await cancel(idPrePrayerMaghrib);
      await cancel(idPrePrayerIsha);
      return;
    }

    // Fajr (04:41) - 5 mins = 04:36
    await _scheduleDaily(
      id: idPrePrayerFajr,
      title: 'اقترب موعد أذان الفجر',
      body:
          'بقيت خمس دقائق على أذان الفجر؛ تهيأ للوقوف بين يدي الله والوضوء لصلاة الفجر المباركة.',
      hour: 4,
      minute: 36,
      payload: 'pre_prayer_fajr',
    );

    // Dhuhr (11:40) - 5 mins = 11:35
    await _scheduleDaily(
      id: idPrePrayerDhuhr,
      title: 'اقترب موعد أذان الظهر',
      body:
          'بقيت خمس دقائق على أذان الظهر؛ أقبل على صلاتك وتهيأ لإراحة فؤادك بين يدي ربك.',
      hour: 11,
      minute: 35,
      payload: 'pre_prayer_dhuhr',
    );

    // Asr (14:43) - 5 mins = 14:38
    await _scheduleDaily(
      id: idPrePrayerAsr,
      title: 'اقترب موعد أذان العصر',
      body:
          'بقيت خمس دقائق على أذان العصر؛ حافظ على الصلاة الوسطى وأقبل على لقاء الله بقلب خاشع.',
      hour: 14,
      minute: 38,
      payload: 'pre_prayer_asr',
    );

    // Maghrib (17:07) - 5 mins = 17:02
    await _scheduleDaily(
      id: idPrePrayerMaghrib,
      title: 'اقترب موعد أذان المغرب',
      body:
          'بقيت خمس دقائق على أذان المغرب؛ اختم نهارك بذكر الله وتهيأ لأداء الفريضة.',
      hour: 17,
      minute: 2,
      payload: 'pre_prayer_maghrib',
    );

    // Isha (18:26) - 5 mins = 18:21
    await _scheduleDaily(
      id: idPrePrayerIsha,
      title: 'اقترب موعد أذان العشاء',
      body:
          'بقيت خمس دقائق على أذان العشاء؛ أقبل على صلاتك واختم يومك بالطاعة والسكينة.',
      hour: 18,
      minute: 21,
      payload: 'pre_prayer_isha',
    );
  }

  @override
  Future<void> scheduleRotatingQuranNotifications({
    required bool enabled,
    PreferencesService? prefs,
  }) async {
    if (!enabled) {
      for (int i = 0; i < rotatingQuranCount; i++) {
        await cancel(idRotatingQuranBase + i);
      }
      return;
    }

    try {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      final List<tz.TZDateTime> upcomingSlots = [];

      for (int day = 0; day < rotatingDaysAhead; day++) {
        for (int s = 0; s < slotsPerDay; s++) {
          final candidate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day + day,
            rotatingSlotHours[s],
            rotatingSlotMinutes[s],
          );
          if (candidate.isAfter(now)) {
            upcomingSlots.add(candidate);
          }
        }
      }

      final int neededCount = upcomingSlots.length.clamp(0, rotatingQuranCount);
      if (neededCount == 0) return;

      // Cancel previous slots before re-scheduling to ensure clean state
      for (int i = 0; i < rotatingQuranCount; i++) {
        await cancel(idRotatingQuranBase + i);
      }

      final Set<String> shownIds = prefs != null
          ? (prefs.getStringList(
                    SettingsPersistenceManager.keyShownQuranNotificationIds,
                  ) ??
                  [])
              .toSet()
          : <String>{};

      List<QuranReflectionItem> availablePool = QuranReflectionsCatalog.pool
          .where((item) => !shownIds.contains(item.id.toString()))
          .toList();

      // If available pool has fewer items than needed, reset shown history to start a fresh cycle
      if (availablePool.length < neededCount) {
        shownIds.clear();
        availablePool = List.of(QuranReflectionsCatalog.pool);
      }

      availablePool.shuffle();
      final selectedItems = availablePool.take(neededCount).toList();

      for (int i = 0; i < neededCount; i++) {
        final item = selectedItems[i];
        final scheduledTime = upcomingSlots[i];

        await _plugin.zonedSchedule(
          id: idRotatingQuranBase + i,
          title: item.notificationTitle,
          body: item.notificationBody,
          scheduledDate: scheduledTime,
          notificationDetails: _buildNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: 'rotating_quran_${item.id}',
        );

        shownIds.add(item.id.toString());
      }

      if (prefs != null) {
        await prefs.setStringList(
          SettingsPersistenceManager.keyShownQuranNotificationIds,
          shownIds.toList(),
        );
      }

      AppLogger.info(
        'Scheduled $neededCount rotating Quran notifications without repetition',
        'NOTIFICATION',
      );
    } catch (e, st) {
      AppLogger.error(
        'Failed to schedule rotating Quran notifications',
        e,
        st,
        'NOTIFICATION',
      );
    }
  }

  @override
  Future<void> syncAllNotifications({
    required bool morningEveningAzkar,
    required bool dailyQuranReminder,
    required bool dailyHopeReminder,
    required bool nightPrayerReminder,
    bool prePrayerReminders = true,
    bool rotatingQuranNotifications = true,
    PreferencesService? prefs,
  }) async {
    await scheduleMorningEveningAzkar(enabled: morningEveningAzkar);
    await scheduleDailyQuranReminder(enabled: dailyQuranReminder);
    await scheduleDailyHopeReminder(enabled: dailyHopeReminder);
    await scheduleNightPrayerReminder(enabled: nightPrayerReminder);
    await schedulePrePrayerReminders(enabled: prePrayerReminders);
    await scheduleRotatingQuranNotifications(
      enabled: rotatingQuranNotifications,
      prefs: prefs,
    );
  }

  @override
  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (e, st) {
      AppLogger.error('Failed to cancel notification $id', e, st, 'NOTIFICATION');
    }
  }

  @override
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e, st) {
      AppLogger.error(
          'Failed to cancel all notifications', e, st, 'NOTIFICATION');
    }
  }
}
