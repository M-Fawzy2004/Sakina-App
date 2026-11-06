import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockPreferencesService extends Mock implements PreferencesService {}

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

    test('schedulePrePrayerReminders schedules 5 daily pre-prayer notifications when enabled', () async {
      await service.schedulePrePrayerReminders(enabled: true);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerFajr,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_fajr',
          )).called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerDhuhr,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_dhuhr',
          )).called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerAsr,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_asr',
          )).called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerMaghrib,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_maghrib',
          )).called(1);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerIsha,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_isha',
          )).called(1);
    });

    test('schedulePrePrayerReminders cancels all 5 notifications when disabled', () async {
      await service.schedulePrePrayerReminders(enabled: false);

      verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idPrePrayerFajr)).called(1);
      verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idPrePrayerDhuhr)).called(1);
      verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idPrePrayerAsr)).called(1);
      verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idPrePrayerMaghrib)).called(1);
      verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idPrePrayerIsha)).called(1);
    });

    test('schedulePrePrayerReminders schedules using Yemen location when configured', () async {
      final mockPrefs = MockPreferencesService();
      when(() => mockPrefs.getString(PrayerLocationCatalog.keySelectedCityId))
          .thenReturn('ye_sanaa');

      await service.schedulePrePrayerReminders(enabled: true, prefs: mockPrefs);

      verify(() => mockPlugin.zonedSchedule(
            id: LocalNotificationServiceImpl.idPrePrayerFajr,
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: 'pre_prayer_fajr',
          )).called(1);
    });

    test('syncAllNotifications coordinates all reminder types', () async {
      await service.syncAllNotifications(
        morningEveningAzkar: true,
        dailyQuranReminder: false,
        dailyHopeReminder: true,
        nightPrayerReminder: false,
        prePrayerReminders: false,
        rotatingQuranNotifications: false,
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
        prePrayerReminders: true,
        rotatingQuranNotifications: false,
      );

      // Regex matching common emojis & symbols
      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      expect(capturedTitles.length, 10); // 2 azkar + 1 quran + 1 hope + 1 night + 5 pre-prayer
      expect(capturedBodies.length, 10);

      for (final title in capturedTitles) {
        expect(emojiRegex.hasMatch(title), isFalse,
            reason: 'Notification title "$title" should not contain emojis');
      }

      for (final body in capturedBodies) {
        expect(emojiRegex.hasMatch(body), isFalse,
            reason: 'Notification body "$body" should not contain emojis');
      }
    });

    test('scheduleRotatingQuranNotifications cancels all rotating IDs when disabled', () async {
      await service.scheduleRotatingQuranNotifications(enabled: false);

      for (int i = 0; i < LocalNotificationServiceImpl.rotatingQuranCount; i++) {
        verify(() => mockPlugin.cancel(id: LocalNotificationServiceImpl.idRotatingQuranBase + i)).called(1);
      }
    });

    test('scheduleRotatingQuranNotifications schedules slots without repetition and updates shown IDs', () async {
      final mockPrefs = MockPreferencesService();
      when(() => mockPrefs.getStringList(SettingsPersistenceManager.keyShownQuranNotificationIds))
          .thenReturn(['1', '2', '3']);
      when(() => mockPrefs.setStringList(SettingsPersistenceManager.keyShownQuranNotificationIds, any()))
          .thenAnswer((_) async => true);

      await service.scheduleRotatingQuranNotifications(enabled: true, prefs: mockPrefs);

      verify(() => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: captureAny(named: 'title'),
            body: captureAny(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            payload: any(named: 'payload'),
          )).called(greaterThan(0));

      final capturedSet = verify(() => mockPrefs.setStringList(
            SettingsPersistenceManager.keyShownQuranNotificationIds,
            captureAny(),
          )).captured;

      expect(capturedSet.isNotEmpty, isTrue);
      final updatedList = capturedSet.last as List<String>;
      expect(updatedList.length, greaterThan(3));
      // Ensures previously shown IDs 1, 2, 3 are preserved in the cycle history
      expect(updatedList.contains('1'), isTrue);
      expect(updatedList.contains('2'), isTrue);
      expect(updatedList.contains('3'), isTrue);
    });

    test('scheduleRotatingQuranNotifications resets pool when exhausted', () async {
      final mockPrefs = MockPreferencesService();
      // Fill shown IDs with all 60 pool items
      final allIds = List.generate(60, (index) => (index + 1).toString());
      when(() => mockPrefs.getStringList(SettingsPersistenceManager.keyShownQuranNotificationIds))
          .thenReturn(allIds);
      when(() => mockPrefs.setStringList(SettingsPersistenceManager.keyShownQuranNotificationIds, any()))
          .thenAnswer((_) async => true);

      await service.scheduleRotatingQuranNotifications(enabled: true, prefs: mockPrefs);

      final capturedSet = verify(() => mockPrefs.setStringList(
            SettingsPersistenceManager.keyShownQuranNotificationIds,
            captureAny(),
          )).captured;

      expect(capturedSet.isNotEmpty, isTrue);
      final updatedList = capturedSet.last as List<String>;
      // Since it reset, it now holds only the freshly scheduled batch count (at most 21)
      expect(updatedList.length, lessThanOrEqualTo(LocalNotificationServiceImpl.rotatingQuranCount));
    });

    test('handleFirstLaunchPermissions enables all reminders when granted', () async {
      final mockPrefs = MockPreferencesService();
      final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();

      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyNotificationPermissionPrompted))
          .thenReturn(null);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getStringList(SettingsPersistenceManager.keyShownQuranNotificationIds))
          .thenReturn(null);
      when(() => mockPrefs.setStringList(SettingsPersistenceManager.keyShownQuranNotificationIds, any()))
          .thenAnswer((_) async => true);
      when(() => mockPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(mockAndroid);
      when(() => mockAndroid.requestNotificationsPermission()).thenAnswer((_) async => true);

      final result = await service.handleFirstLaunchPermissions(prefs: mockPrefs);

      expect(result, isTrue);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyNotificationPermissionPrompted, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyMorningEveningAzkar, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyDailyQuranReminder, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyDailyHopeReminder, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyNightPrayerReminder, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyPrePrayerReminder, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyRotatingQuranNotifications, true)).called(1);
    });

    test('handleFirstLaunchPermissions disables all reminders and cancels schedules when denied', () async {
      final mockPrefs = MockPreferencesService();
      final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();

      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyNotificationPermissionPrompted))
          .thenReturn(false);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(mockAndroid);
      when(() => mockAndroid.requestNotificationsPermission()).thenAnswer((_) async => false);

      final result = await service.handleFirstLaunchPermissions(prefs: mockPrefs);

      expect(result, isFalse);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyNotificationPermissionPrompted, true)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyMorningEveningAzkar, false)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyDailyQuranReminder, false)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyDailyHopeReminder, false)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyNightPrayerReminder, false)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyPrePrayerReminder, false)).called(1);
      verify(() => mockPrefs.setBool(SettingsPersistenceManager.keyRotatingQuranNotifications, false)).called(1);
      verify(() => mockPlugin.cancelAll()).called(1);
    });

    test('handleFirstLaunchPermissions does nothing if already prompted previously', () async {
      final mockPrefs = MockPreferencesService();

      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyNotificationPermissionPrompted))
          .thenReturn(true);

      final result = await service.handleFirstLaunchPermissions(prefs: mockPrefs);

      expect(result, isFalse);
      verifyNever(() => mockPrefs.setBool(any(), any()));
    });
  });
}
