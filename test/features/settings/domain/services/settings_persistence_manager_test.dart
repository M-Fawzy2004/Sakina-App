import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
  });

  group('SettingsPersistenceManager', () {
    test('load returns robust defaults when no preferences stored', () {
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);

      final data = SettingsPersistenceManager.load(mockPrefs);

      expect(data.reciterId, 'Alafasy_128kbps');
      expect(data.reciterName, 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي');
      expect(data.autoPlayNext, true);
      expect(data.morningEveningAzkar, true);
      expect(data.dailyQuranReminder, true);
      expect(data.dailyHopeReminder, true);
      expect(data.nightPrayerReminder, true);
      expect(data.inabaLock, true);
      expect(data.stealthNotifications, false);
    });

    test('load returns custom stored values correctly', () {
      when(() => mockPrefs.getString(SettingsPersistenceManager.keyReciterId))
          .thenReturn('Husary_128kbps');
      when(() => mockPrefs.getString(SettingsPersistenceManager.keyReciterName))
          .thenReturn('الشَّيْخُ مَحْمُود خَلِيل الحُصَرِيُّ');
      when(() => mockPrefs.getString(SettingsPersistenceManager.keyAudioQuality))
          .thenReturn('HQ');
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyAutoPlayNext))
          .thenReturn(false);
      when(() => mockPrefs.getString(SettingsPersistenceManager.keySleepTimer))
          .thenReturn('٣٠ دقيقة');
      when(() => mockPrefs.getString(SettingsPersistenceManager.keyReadingStyle))
          .thenReturn('custom_style');
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyKeepAwake))
          .thenReturn(false);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyMorningEveningAzkar))
          .thenReturn(false);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyDailyQuranReminder))
          .thenReturn(false);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyDailyHopeReminder))
          .thenReturn(false);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyNightPrayerReminder))
          .thenReturn(true);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyInabaLock))
          .thenReturn(false);
      when(() => mockPrefs.getBool(SettingsPersistenceManager.keyStealthNotifications))
          .thenReturn(true);

      final data = SettingsPersistenceManager.load(mockPrefs);

      expect(data.reciterId, 'Husary_128kbps');
      expect(data.reciterName, 'الشَّيْخُ مَحْمُود خَلِيل الحُصَرِيُّ');
      expect(data.autoPlayNext, false);
      expect(data.sleepTimer, '٣٠ دقيقة');
      expect(data.morningEveningAzkar, false);
      expect(data.nightPrayerReminder, true);
      expect(data.inabaLock, false);
      expect(data.stealthNotifications, true);
    });

    test('resetAll removes all settings keys from preferences', () async {
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      await SettingsPersistenceManager.resetAll(mockPrefs);

      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyReciterId)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyReciterName)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyAudioQuality)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyAutoPlayNext)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keySleepTimer)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyReadingStyle)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyKeepAwake)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyMorningEveningAzkar)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyDailyQuranReminder)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyDailyHopeReminder)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyNightPrayerReminder)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyNotificationPermissionPrompted)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyInabaLock)).called(1);
      verify(() => mockPrefs.remove(SettingsPersistenceManager.keyStealthNotifications)).called(1);
    });
  });
}

