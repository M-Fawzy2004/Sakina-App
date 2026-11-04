import 'package:intl/intl.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/spiritual_habits_state.dart';

/// Service responsible for local persistence, daily midnight resets,
/// and streak calculation for the 3 Daily Spiritual Habits.
abstract final class SpiritualHabitsManager {
  static const String keyDate = 'spiritual_habits_date';
  static const String keyAthkar = 'spiritual_habits_athkar';
  static const String keyQuran = 'spiritual_habits_quran';
  static const String keyWitr = 'spiritual_habits_witr';
  static const String keyStreak = 'spiritual_habits_streak';

  static String get todayString =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Loads current habits state, automatically resetting for the new calendar day.
  static SpiritualHabitsState load(PreferencesService prefs) {
    final today = todayString;
    final savedDate = prefs.getString(keyDate);
    final savedStreak = prefs.getInt(keyStreak) ?? 1;

    // First time or same day
    if (savedDate == null) {
      return SpiritualHabitsState.initial(today);
    }

    if (savedDate == today) {
      return SpiritualHabitsState(
        athkarDone: prefs.getBool(keyAthkar) ?? false,
        quranDone: prefs.getBool(keyQuran) ?? false,
        witrDone: prefs.getBool(keyWitr) ?? false,
        streakDays: savedStreak,
        dateString: today,
      );
    }

    // New calendar day: check if yesterday was consecutive
    final yesterdayString = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    final wasConsecutive = savedDate == yesterdayString;

    final hadCompletedAllYesterday = (prefs.getBool(keyAthkar) ?? false) &&
        (prefs.getBool(keyQuran) ?? false) &&
        (prefs.getBool(keyWitr) ?? false);

    final nextStreak = wasConsecutive && hadCompletedAllYesterday
        ? savedStreak + 1
        : (wasConsecutive ? savedStreak : 1);

    // Save reset state for the new day
    final newState = SpiritualHabitsState(
      athkarDone: false,
      quranDone: false,
      witrDone: false,
      streakDays: nextStreak,
      dateString: today,
    );

    save(prefs, newState);
    return newState;
  }

  /// Persists the updated spiritual habits state.
  static Future<void> save(
    PreferencesService prefs,
    SpiritualHabitsState state,
  ) async {
    await prefs.setString(keyDate, state.dateString);
    await prefs.setBool(keyAthkar, state.athkarDone);
    await prefs.setBool(keyQuran, state.quranDone);
    await prefs.setBool(keyWitr, state.witrDone);
    await prefs.setInt(keyStreak, state.streakDays);
  }
}

