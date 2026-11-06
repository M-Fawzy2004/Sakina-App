import 'package:adhan/adhan.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';

/// Worldwide astronomical prayer times calculator based on the standard [adhan] library.
/// Supports all calculation methods (Umm Al-Qura, Egyptian, Dubai, Kuwait, MWL, etc.)
/// and accurate geographical coordinates across 100+ cities worldwide.
abstract final class GlobalPrayerTimesCalculator {
  static CalculationParameters _getCalculationParameters(String method) {
    switch (method) {
      case 'umm_al_qura':
        return CalculationMethod.umm_al_qura.getParameters();
      case 'dubai':
        return CalculationMethod.dubai.getParameters();
      case 'kuwait':
        return CalculationMethod.kuwait.getParameters();
      case 'qatar':
        return CalculationMethod.qatar.getParameters();
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league.getParameters();
      case 'karachi':
        return CalculationMethod.karachi.getParameters();
      case 'north_america':
        return CalculationMethod.north_america.getParameters();
      case 'singapore':
        return CalculationMethod.singapore.getParameters();
      case 'turkey':
        return CalculationMethod.turkey.getParameters();
      case 'tehran':
        return CalculationMethod.tehran.getParameters();
      case 'egyptian':
      default:
        return CalculationMethod.egyptian.getParameters();
    }
  }

  /// Calculates prayer schedule for a specific date and city location.
  static PrayerScheduleInfo calculate({
    CityLocation? location,
    DateTime? customNow,
    PreferencesService? prefs,
  }) {
    final effectiveLocation = location ??
        PrayerLocationCatalog.findFromPreferences(prefs);
    final now = customNow ?? DateTime.now();

    final coordinates = Coordinates(
      effectiveLocation.latitude,
      effectiveLocation.longitude,
    );
    final params = _getCalculationParameters(effectiveLocation.calculationMethod);

    // Calculate prayer times for today
    final todayComponents = DateComponents(now.year, now.month, now.day);
    final prayerTimesToday = PrayerTimes(coordinates, todayComponents, params);

    // Calculate timezone difference between phone local timezone and target city's timezone
    final localOffsetHours = now.timeZoneOffset.inMinutes / 60.0;
    final diffHours = effectiveLocation.utcOffsetHours - localOffsetHours;
    final tzAdjustment = Duration(minutes: (diffHours * 60).round());

    final fajrToday = prayerTimesToday.fajr.add(tzAdjustment);
    final sunriseToday = prayerTimesToday.sunrise.add(tzAdjustment);
    final dhuhrToday = prayerTimesToday.dhuhr.add(tzAdjustment);
    final asrToday = prayerTimesToday.asr.add(tzAdjustment);
    final maghribToday = prayerTimesToday.maghrib.add(tzAdjustment);
    final ishaToday = prayerTimesToday.isha.add(tzAdjustment);

    // Calculate tomorrow's Fajr for overnight countdown
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowComponents = DateComponents(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
    );
    final prayerTimesTomorrow =
        PrayerTimes(coordinates, tomorrowComponents, params);
    final fajrTomorrow = prayerTimesTomorrow.fajr.add(tzAdjustment);

    String nextName;
    String nextTime;
    String currentName;
    String currentTime;
    Duration remaining;
    int nextIndex;

    if (now.isBefore(fajrToday)) {
      nextName = 'الفَجْرُ';
      nextTime = _formatTime12(fajrToday);
      currentName = 'العِشَاءُ';
      currentTime = _formatTime12(ishaToday);
      remaining = fajrToday.difference(now);
      nextIndex = 0;
    } else if (now.isBefore(dhuhrToday)) {
      nextName = 'الظُّهْرُ';
      nextTime = _formatTime12(dhuhrToday);
      currentName = 'الفَجْرُ';
      currentTime = _formatTime12(fajrToday);
      remaining = dhuhrToday.difference(now);
      nextIndex = 1;
    } else if (now.isBefore(asrToday)) {
      nextName = 'العَصْرُ';
      nextTime = _formatTime12(asrToday);
      currentName = 'الظُّهْرُ';
      currentTime = _formatTime12(dhuhrToday);
      remaining = asrToday.difference(now);
      nextIndex = 2;
    } else if (now.isBefore(maghribToday)) {
      nextName = 'المَغْرِبُ';
      nextTime = _formatTime12(maghribToday);
      currentName = 'العَصْرُ';
      currentTime = _formatTime12(asrToday);
      remaining = maghribToday.difference(now);
      nextIndex = 3;
    } else if (now.isBefore(ishaToday)) {
      nextName = 'العِشَاءُ';
      nextTime = _formatTime12(ishaToday);
      currentName = 'المَغْرِبُ';
      currentTime = _formatTime12(maghribToday);
      remaining = ishaToday.difference(now);
      nextIndex = 4;
    } else {
      nextName = 'الفَجْرُ';
      nextTime = _formatTime12(fajrTomorrow);
      currentName = 'العِشَاءُ';
      currentTime = _formatTime12(ishaToday);
      remaining = fajrTomorrow.difference(now);
      nextIndex = 0;
    }

    return PrayerScheduleInfo(
      nextPrayerName: nextName,
      nextPrayerTime: nextTime,
      currentPrayerName: currentName,
      currentPrayerTime: currentTime,
      remainingToNext: remaining,
      nextPrayerIndex: nextIndex,
      fajrTime: fajrToday,
      sunriseTime: sunriseToday,
      dhuhrTime: dhuhrToday,
      asrTime: asrToday,
      maghribTime: maghribToday,
      ishaTime: ishaToday,
      fajrFormatted: _formatTime12(fajrToday),
      sunriseFormatted: _formatTime12(sunriseToday),
      dhuhrFormatted: _formatTime12(dhuhrToday),
      asrFormatted: _formatTime12(asrToday),
      maghribFormatted: _formatTime12(maghribToday),
      ishaFormatted: _formatTime12(ishaToday),
      cityName: effectiveLocation.cityNameArabic,
      countryName: effectiveLocation.countryNameArabic,
    );
  }

  static String _formatTime12(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$hour12:$m';
  }

  /// Formats 12-hour format string (e.g. "04:46 ص" / "05:32 م")
  static String formatTime12(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '$hour:$m $period';
  }
}

