import 'package:sakina_app/core/services/storage/preferences_service.dart';

/// Centralized storage keys and persistence utilities for application preferences and reminders.
abstract final class SettingsPersistenceManager {
  static const String keyReciterId = 'sakina_settings_reciter_id';
  static const String keyReciterName = 'sakina_settings_reciter_name';
  static const String keyAudioQuality = 'sakina_settings_audio_quality';
  static const String keyAutoPlayNext = 'sakina_settings_auto_play_next';
  static const String keySleepTimer = 'sakina_settings_sleep_timer';
  static const String keyReadingStyle = 'sakina_settings_reading_style';
  static const String keyKeepAwake = 'sakina_settings_keep_awake';

  static const String keyMorningEveningAzkar =
      'sakina_reminder_morning_evening_azkar';
  static const String keyDailyQuranReminder = 'sakina_reminder_daily_quran';
  static const String keyDailyHopeReminder = 'sakina_reminder_daily_hope';
  static const String keyNightPrayerReminder = 'sakina_reminder_night_prayer';

  static const String keyInabaLock = 'sakina_inaba_pin_lock_enabled';
  static const String keyStealthNotifications = 'sakina_stealth_notifications';

  /// Loads all user preferences in a structured record.
  static ({
    String reciterId,
    String reciterName,
    String audioQuality,
    bool autoPlayNext,
    String sleepTimer,
    String readingStyle,
    bool keepAwake,
    bool morningEveningAzkar,
    bool dailyQuranReminder,
    bool dailyHopeReminder,
    bool nightPrayerReminder,
    bool inabaLock,
    bool stealthNotifications,
  }) load(PreferencesService prefs) {
    return (
      reciterId: prefs.getString(keyReciterId) ?? 'Alafasy_128kbps',
      reciterName: prefs.getString(keyReciterName) ??
          'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي',
      audioQuality: prefs.getString(keyAudioQuality) ??
          'جَوْدَةٌ عَالِيَةٌ (HQ 128 kbps) — نَقَاءُ اسْتُودْيُو',
      autoPlayNext: prefs.getBool(keyAutoPlayNext) ?? true,
      sleepTimer: prefs.getString(keySleepTimer) ?? 'مُعَطَّلٌ حَالِيًّا',
      readingStyle: prefs.getString(keyReadingStyle) ??
          'كُرُوتُ الآيَاتِ المُنْفَرِدَةِ مَعَ إِضَاءَةِ التِّلَاوَةِ',
      keepAwake: prefs.getBool(keyKeepAwake) ?? true,
      morningEveningAzkar: prefs.getBool(keyMorningEveningAzkar) ?? true,
      dailyQuranReminder: prefs.getBool(keyDailyQuranReminder) ?? true,
      dailyHopeReminder: prefs.getBool(keyDailyHopeReminder) ?? true,
      nightPrayerReminder: prefs.getBool(keyNightPrayerReminder) ?? false,
      inabaLock: prefs.getBool(keyInabaLock) ?? true,
      stealthNotifications: prefs.getBool(keyStealthNotifications) ?? false,
    );
  }

  /// Resets all preference keys to factory defaults.
  static Future<void> resetAll(PreferencesService prefs) async {
    await prefs.remove(keyReciterId);
    await prefs.remove(keyReciterName);
    await prefs.remove(keyAudioQuality);
    await prefs.remove(keyAutoPlayNext);
    await prefs.remove(keySleepTimer);
    await prefs.remove(keyReadingStyle);
    await prefs.remove(keyKeepAwake);
    await prefs.remove(keyMorningEveningAzkar);
    await prefs.remove(keyDailyQuranReminder);
    await prefs.remove(keyDailyHopeReminder);
    await prefs.remove(keyNightPrayerReminder);
    await prefs.remove(keyInabaLock);
    await prefs.remove(keyStealthNotifications);
  }
}

