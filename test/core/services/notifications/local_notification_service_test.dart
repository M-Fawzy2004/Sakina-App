import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    registerFallbackValue(
      const InitializationSettings(),
    );
    registerFallbackValue(
      const NotificationDetails(),
    );
    registerFallbackValue(
      tz.TZDateTime.now(tz.local),
    );
    registerFallbackValue(
      AndroidScheduleMode.inexactAllowWhileIdle,
    );
    registerFallbackValue(
      DateTimeComponents.time,
    );
  });

  late MockFlutterLocalNotificationsPlugin mockPlugin;
  late LocalNotificationServiceImpl service;

  setUp(() {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    service = LocalNotificationServiceImpl(plugin: mockPlugin);

    when(() => mockPlugin.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        )).thenAnswer((_) async => true);

    when(() => mockPlugin.zonedSchedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          payload: any(named: 'payload'),
        )).thenAnswer((_) async {});

    when(() => mockPlugin.cancel(id: any(named: 'id')))
        .thenAnswer((_) async {});

    when(() => mockPlugin.cancelAll()).thenAnswer((_) async {});
  });

  group('LocalNotificationService Tests', () {
    test('initializes local notification plugin properly', () async {
      await service.initialize();

      verify(() => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse:
                any(named: 'onDidReceiveNotificationResponse'),
          )).called(1);
    });

    test('scheduleMorningEveningAzkar schedules notifications when enabled',
        () async {
      await service.scheduleMorningEveningAzkar(enabled: true);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idMorningAzkar,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'morning_azkar',
          )).called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idEveningAzkar,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'evening_azkar',
          )).called(1);
    });

    test('scheduleMorningEveningAzkar cancels notifications when disabled',
        () async {
      await service.scheduleMorningEveningAzkar(enabled: false);

      verify(() => mockPlugin.cancel(
          id: LocalNotificationServiceImpl.idMorningAzkar)).called(1);
      verify(() => mockPlugin.cancel(
          id: LocalNotificationServiceImpl.idEveningAzkar)).called(1);
    });

    test('scheduleDailyQuranReminder schedules when true and cancels when false',
        () async {
      await service.scheduleDailyQuranReminder(enabled: true);
      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idDailyQuran,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'daily_quran',
          )).called(1);

      await service.scheduleDailyQuranReminder(enabled: false);
      verify(() =>
              mockPlugin.cancel(id: LocalNotificationServiceImpl.idDailyQuran))
          .called(1);
    });

    test('scheduleDailyHopeReminder schedules when true and cancels when false',
        () async {
      await service.scheduleDailyHopeReminder(enabled: true);
      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idDailyHope,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'daily_hope',
          )).called(1);

      await service.scheduleDailyHopeReminder(enabled: false);
      verify(() =>
              mockPlugin.cancel(id: LocalNotificationServiceImpl.idDailyHope))
          .called(1);
    });

    test('scheduleNightPrayerReminder schedules when true and cancels when false',
        () async {
      await service.scheduleNightPrayerReminder(enabled: true);
      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idNightPrayer,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'night_prayer',
          )).called(1);

      await service.scheduleNightPrayerReminder(enabled: false);
      verify(() =>
              mockPlugin.cancel(id: LocalNotificationServiceImpl.idNightPrayer))
          .called(1);
    });

    test('syncAllNotifications coordinates all 4 reminder types', () async {
      await service.syncAllNotifications(
        morningEveningAzkar: true,
        dailyQuranReminder: false,
        dailyHopeReminder: true,
        nightPrayerReminder: false,
      );

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idMorningAzkar,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'morning_azkar',
          )).called(1);

      verify(() =>
              mockPlugin.cancel(id: LocalNotificationServiceImpl.idDailyQuran))
          .called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idDailyHope,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'daily_hope',
          )).called(1);

      verify(() =>
              mockPlugin.cancel(id: LocalNotificationServiceImpl.idNightPrayer))
          .called(1);
    });

    test('guarantees notification titles and bodies contain ZERO emojis',
        () async {
      final capturedTitles = <String>[];
      final capturedBodies = <String>[];

      when(() => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: any(named: 'payload'),
          )).thenAnswer((invocation) async {
        final title = invocation.namedArguments[#title] as String?;
        final body = invocation.namedArguments[#body] as String?;
        if (title != null) capturedTitles.add(title);
        if (body != null) capturedBodies.add(body);
      });

      await service.syncAllNotifications(
        morningEveningAzkar: true,
        dailyQuranReminder: true,
        dailyHopeReminder: true,
        nightPrayerReminder: true,
      );

      // Regex matching common emojis & symbols
      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      expect(capturedTitles.length, 5); // 2 azkar + 1 quran + 1 hope + 1 night
      expect(capturedBodies.length, 5);

      for (final title in capturedTitles) {
        expect(emojiRegex.hasMatch(title), isFalse,
            reason: 'Notification title "$title" should not contain emojis');
      }

      for (final body in capturedBodies) {
        expect(emojiRegex.hasMatch(body), isFalse,
            reason: 'Notification body "$body" should not contain emojis');
      }
    });
  });
}
