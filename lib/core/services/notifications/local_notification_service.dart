import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Contract for on-device, 100% offline-first scheduled notifications.
abstract class LocalNotificationService {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<void> scheduleMorningEveningAzkar({required bool enabled});
  Future<void> scheduleDailyQuranReminder({required bool enabled});
  Future<void> scheduleDailyHopeReminder({required bool enabled});
  Future<void> scheduleNightPrayerReminder({required bool enabled});
  Future<void> syncAllNotifications({
    required bool morningEveningAzkar,
    required bool dailyQuranReminder,
    required bool dailyHopeReminder,
    required bool nightPrayerReminder,
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
  Future<void> syncAllNotifications({
    required bool morningEveningAzkar,
    required bool dailyQuranReminder,
    required bool dailyHopeReminder,
    required bool nightPrayerReminder,
  }) async {
    await scheduleMorningEveningAzkar(enabled: morningEveningAzkar);
    await scheduleDailyQuranReminder(enabled: dailyQuranReminder);
    await scheduleDailyHopeReminder(enabled: dailyHopeReminder);
    await scheduleNightPrayerReminder(enabled: nightPrayerReminder);
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
