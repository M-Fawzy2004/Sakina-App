abstract final class AppConstants {
  static const String appName = 'سكينة';
  static const String appNameEnglish = 'Sakina';

  // Database
  static const String databaseName = 'sakina_sanctuary_v1.db';
  static const int databaseVersion = 1;

  // Cache & Prefs Keys
  static const String keyLastReadPage = 'last_read_page';
  static const String keyLastReadSurah = 'last_read_surah';
  static const String keyLastReadAyah = 'last_read_ayah';
  static const String keySelectedReciter = 'selected_reciter';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyInabaStreakDays = 'inaba_streak_days';
  static const String keyLastInabaCheckIn = 'last_inaba_check_in';
  static const String keyAppLocale = 'app_locale';

  // Timing & Animation standard durations
  static const Duration splashDelay = Duration(milliseconds: 2500);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 350);
  static const Duration quickAnimationDuration = Duration(milliseconds: 200);
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);
  static const Duration sleepTimerDuckingDuration = Duration(seconds: 15);

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 10);
}

