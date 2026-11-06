import 'package:equatable/equatable.dart';

/// Pure domain entity holding real-time prayer schedule context.
class PrayerScheduleInfo extends Equatable {
  final String nextPrayerName;
  final String nextPrayerTime;
  final String currentPrayerName;
  final String currentPrayerTime;
  final Duration remainingToNext;
  final int nextPrayerIndex; // 0: Fajr, 1: Dhuhr, 2: Asr, 3: Maghrib, 4: Isha

  final DateTime? fajrTime;
  final DateTime? sunriseTime;
  final DateTime? dhuhrTime;
  final DateTime? asrTime;
  final DateTime? maghribTime;
  final DateTime? ishaTime;

  final String fajrFormatted;
  final String sunriseFormatted;
  final String dhuhrFormatted;
  final String asrFormatted;
  final String maghribFormatted;
  final String ishaFormatted;

  final String cityName;
  final String countryName;

  const PrayerScheduleInfo({
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.currentPrayerName,
    required this.currentPrayerTime,
    required this.remainingToNext,
    required this.nextPrayerIndex,
    this.fajrTime,
    this.sunriseTime,
    this.dhuhrTime,
    this.asrTime,
    this.maghribTime,
    this.ishaTime,
    this.fajrFormatted = '4:41',
    this.sunriseFormatted = '6:10',
    this.dhuhrFormatted = '11:40',
    this.asrFormatted = '2:43',
    this.maghribFormatted = '5:07',
    this.ishaFormatted = '6:26',
    this.cityName = 'القاهرة',
    this.countryName = 'مصر',
  });

  @override
  List<Object?> get props => [
        nextPrayerName,
        nextPrayerTime,
        currentPrayerName,
        currentPrayerTime,
        remainingToNext,
        nextPrayerIndex,
        fajrFormatted,
        sunriseFormatted,
        dhuhrFormatted,
        asrFormatted,
        maghribFormatted,
        ishaFormatted,
        cityName,
        countryName,
      ];
}

/// Pure Dart calculator for Cairo (Egypt official calendar) prayer times.
/// Accurately transitions each prayer sequentially through the 24-hour cycle.
class CairoPrayerTimesCalculator {
  const CairoPrayerTimesCalculator();

  static PrayerScheduleInfo calculate([DateTime? customNow]) {
    final now = customNow ?? DateTime.now();
    final y = now.year;
    final m = now.month;
    final d = now.day;

    final fajrToday = DateTime(y, m, d, 4, 41);
    final dhuhrToday = DateTime(y, m, d, 11, 40);
    final asrToday = DateTime(y, m, d, 14, 43);
    final maghribToday = DateTime(y, m, d, 17, 7);
    final ishaToday = DateTime(y, m, d, 18, 26);

    if (now.isBefore(fajrToday)) {
      return PrayerScheduleInfo(
        nextPrayerName: 'الفَجْرُ',
        nextPrayerTime: '4:41',
        currentPrayerName: 'العِشَاءُ',
        currentPrayerTime: '6:26',
        remainingToNext: fajrToday.difference(now),
        nextPrayerIndex: 0,
      );
    } else if (now.isBefore(dhuhrToday)) {
      return PrayerScheduleInfo(
        nextPrayerName: 'الظُّهْرُ',
        nextPrayerTime: '11:40',
        currentPrayerName: 'الفَجْرُ',
        currentPrayerTime: '4:41',
        remainingToNext: dhuhrToday.difference(now),
        nextPrayerIndex: 1,
      );
    } else if (now.isBefore(asrToday)) {
      return PrayerScheduleInfo(
        nextPrayerName: 'العَصْرُ',
        nextPrayerTime: '2:43',
        currentPrayerName: 'الظُّهْرُ',
        currentPrayerTime: '11:40',
        remainingToNext: asrToday.difference(now),
        nextPrayerIndex: 2,
      );
    } else if (now.isBefore(maghribToday)) {
      return PrayerScheduleInfo(
        nextPrayerName: 'المَغْرِبُ',
        nextPrayerTime: '5:07',
        currentPrayerName: 'العَصْرُ',
        currentPrayerTime: '2:43',
        remainingToNext: maghribToday.difference(now),
        nextPrayerIndex: 3,
      );
    } else if (now.isBefore(ishaToday)) {
      return PrayerScheduleInfo(
        nextPrayerName: 'العِشَاءُ',
        nextPrayerTime: '6:26',
        currentPrayerName: 'المَغْرِبُ',
        currentPrayerTime: '5:07',
        remainingToNext: ishaToday.difference(now),
        nextPrayerIndex: 4,
      );
    } else {
      final fajrTomorrow = DateTime(y, m, d + 1, 4, 41);
      return PrayerScheduleInfo(
        nextPrayerName: 'الفَجْرُ',
        nextPrayerTime: '4:41',
        currentPrayerName: 'العِشَاءُ',
        currentPrayerTime: '6:26',
        remainingToNext: fajrTomorrow.difference(now),
        nextPrayerIndex: 0,
      );
    }
  }

  /// Formats duration into standard standard Arabic countdown ticker string.
  static String formatCountdown(Duration duration, String prayerName) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours.toString().padLeft(2, '0');
    final minutes = (safeDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (safeDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$prayerName بعد $hours:$minutes:$seconds';
  }
}

