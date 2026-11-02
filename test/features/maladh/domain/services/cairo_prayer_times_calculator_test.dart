import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

void main() {
  group('CairoPrayerTimesCalculator Tests', () {
    test('at 02:00 AM (before Fajr): next is Fajr 04:41, previous is Isha 06:26', () {
      final now = DateTime(2026, 11, 2, 2, 0);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'الفَجْرُ');
      expect(result.nextPrayerTime, '04:41');
      expect(result.currentPrayerName, 'العِشَاءُ');
      expect(result.currentPrayerTime, '06:26');
      expect(result.nextPrayerIndex, 0);
      expect(result.remainingToNext.inMinutes, 161); // 2 hours 41 mins
    });

    test('at 09:45 AM (morning after Fajr): next is Dhuhr 11:40, previous is Fajr 04:41', () {
      final now = DateTime(2026, 11, 2, 9, 45);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'الظُّهْرُ');
      expect(result.nextPrayerTime, '11:40');
      expect(result.currentPrayerName, 'الفَجْرُ');
      expect(result.currentPrayerTime, '04:41');
      expect(result.nextPrayerIndex, 1);
      expect(result.remainingToNext.inMinutes, 115); // 1 hour 55 mins
    });

    test('at 13:00 PM (after Dhuhr): next is Asr 02:43, previous is Dhuhr 11:40', () {
      final now = DateTime(2026, 11, 2, 13, 0);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'العَصْرُ');
      expect(result.nextPrayerTime, '02:43');
      expect(result.currentPrayerName, 'الظُّهْرُ');
      expect(result.currentPrayerTime, '11:40');
      expect(result.nextPrayerIndex, 2);
      expect(result.remainingToNext.inMinutes, 103); // 1 hour 43 mins
    });

    test('at 15:30 PM (after Asr): next is Maghrib 05:07, previous is Asr 02:43', () {
      final now = DateTime(2026, 11, 2, 15, 30);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'المَغْرِبُ');
      expect(result.nextPrayerTime, '05:07');
      expect(result.currentPrayerName, 'العَصْرُ');
      expect(result.currentPrayerTime, '02:43');
      expect(result.nextPrayerIndex, 3);
      expect(result.remainingToNext.inMinutes, 97); // 1 hour 37 mins
    });

    test('at 17:30 PM (after Maghrib): next is Isha 06:26, previous is Maghrib 05:07', () {
      final now = DateTime(2026, 11, 2, 17, 30);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'العِشَاءُ');
      expect(result.nextPrayerTime, '06:26');
      expect(result.currentPrayerName, 'المَغْرِبُ');
      expect(result.currentPrayerTime, '05:07');
      expect(result.nextPrayerIndex, 4);
      expect(result.remainingToNext.inMinutes, 56);
    });

    test('at 21:00 PM (after Isha): next is Fajr tomorrow 04:41, previous is Isha 06:26', () {
      final now = DateTime(2026, 11, 2, 21, 0);
      final result = CairoPrayerTimesCalculator.calculate(now);

      expect(result.nextPrayerName, 'الفَجْرُ');
      expect(result.nextPrayerTime, '04:41');
      expect(result.currentPrayerName, 'العِشَاءُ');
      expect(result.currentPrayerTime, '06:26');
      expect(result.nextPrayerIndex, 0);
      expect(result.remainingToNext.inMinutes, 461); // 7 hours 41 mins
    });

    test('formatCountdown formats duration cleanly', () {
      const duration = Duration(hours: 1, minutes: 54, seconds: 15);
      final formatted = CairoPrayerTimesCalculator.formatCountdown(duration, 'الظُّهْرُ');
      expect(formatted, 'الظُّهْرُ بعد 01:54:15');
    });
  });
}

